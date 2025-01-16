//
//  SudokuBoard.swift
//  Sudoku
//
//  Created by Grace She on 2025-01-13.
//

import Foundation

class Board: ObservableObject{
    
    @Published var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)  // Make grid mutable
    var fullGrid: [[Int]] = []  // Make grid mutable
    var boolCheck: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)  // true if cell is mutable. all cells are initialized as false
//    var restart: Bool
//
//    init() {
//        generateBoard(numClues: 30)
//    }
    
    func fillGrid() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col] == 0 {
                    var numbers: [Int] = Array(1...9)
                    numbers.shuffle()
                    
                    for num in numbers {
                        if checkValid(row: row, col: col, num: num, grid: &grid) {
                            grid[row][col] = num
                            if fillGrid() {
                                return true
                            }
                            grid[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true // if all cells have been filled following the rules of Sudoku
    }
    
    func checkValid(row: Int, col: Int, num: Int, grid: inout [[Int]]) -> Bool {
        for i in 0..<9 {
            if grid[i][col] == num || grid[row][i] == num {
                return false
            }
        }
        
        let smallCellRow: Int = (row / 3) * 3 // gets the starting row of the 3x3 grid
        let smallCellCol: Int = (col / 3) * 3 // gets the starting col of the 3x3 grid
        for i in smallCellRow..<smallCellRow + 3 {
            for j in smallCellCol..<smallCellCol + 3 {
                if grid[i][j] == num {
                    return false
                }
            }
        }
        return true
    }
    
    func removedNumbers(numClues clues: Int, grid: inout [[Int]]) {
        // create a list of all cell positions
//        let fullGrid = grid
        var positions: [(Int, Int)] = [(Int, Int)]()
        for row in 0..<9 {
            for col in 0..<9 {
                positions.append((row, col))
            }
        }
        
        positions.shuffle() // cell positions are no longer in order
        print(positions)
        
        while positions.count > 0 && numFilledCells(&grid) > clues {
            let (row, col) = positions.removeFirst()
            let backup: Int = grid[row][col]
            grid[row][col] = 0
            
//            var gridCopy = self.grid
            if !validSolution(&grid) {
                grid[row][col] = backup
            }
        }
    }
    
    func numFilledCells(_ grid: inout [[Int]]) -> Int {
        return grid.flatMap{$0}.filter{$0 != 0}.count
        // .flatMap{$0} returns a 2D array as a 1D array and returns the value as it is
        // .filter{$0 != 0} creates a new array that only has values that are not equal to 0
        // .count returns the number of elements in the new array
    }
    
    func validSolution(_ grid: inout [[Int]]) -> Bool {
        var count: Int = 0
        _ = checkSolution(&grid, &count)
        return count == 1
    }
    
    func checkSolution(_ grid: inout [[Int]], _ count: inout Int) -> Bool {
        if count > 1 {
            return true
        }
        
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col] == 0 {
                    for num in 1...9 {
                        if checkValid(row: row, col: col, num: num, grid: &grid) {
                            grid[row][col] = num
                            if checkSolution(&grid, &count) {
                                // Nothing happens. The recursion is used to check the entire board each time a new cell is assigned a value. This function is recursively called after every "empty" cell is assigned a new number, then proceeds to try to solve the rest of the board. When false, the last assigned cell is changed back to 0 and the function returns false, backtracking to the previous recursion to assign a new number to the last cell. When no valid solution can be assigned to the last cell, the function backtracks to the second last cell and changes the value of that cell and tries to proceed with solving the rest of the grid.
                            }
                            grid[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        count += 1 // all cells of the grid have been filled – a valid solution has been found. Number of solutions (count) += 1
        return false // exits the recursion
    }
    
    func generateBoard(numClues clues: Int, restart: Bool) {
        if restart {
            grid = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        }
        _ = fillGrid() // the grid gets completely filled with a valid solution
        fullGrid = grid
        removedNumbers(numClues: 30, grid: &grid)
    }
    
    func printGrid() {
        for row in grid {
            print(row.map({ String($0) }).joined(separator: " "))
        }
        print("-----------------")
        for row in fullGrid {
            print(row.map({ String($0) }).joined(separator: " "))
        }
    }
    
    func playBoard() -> [[Int]]{
        return grid
    }
    
    func fullBoard() -> [[Int]]{
        return fullGrid
    }
    
    func cellBool() {
        for row in 0..<9 {
            for col in 0..<9 {
                boolCheck[row][col] = (grid[row][col] == 0)
            }
        }
    }
    
    func updateCell(row: Int, col: Int, num: Int) {
        grid[row][col] = num
        boolCheck[row][col] = false
    }
    
    func generateBoolBoard(){
        cellBool()
    }
    
    func boolBoard() -> [[Bool]] {
        cellBool()
        return boolCheck
    }
}
