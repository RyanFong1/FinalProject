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
    var notesBool: [[[[Bool]]]] = Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 9), count: 9), count: 9), count: 9) // notes are all initialized to false (editable)
    var notes: [[[[Int]]]] = Array(repeating: Array(repeating: [[1, 2, 3], [4, 5, 6], [7, 8, 9]], count: 9), count: 9)
    // [row][col][currentNum-1]
    
    func fillGrid() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if grid[row][col] == 0 { // if this current cell has not been filled yet
                    var numbers: [Int] = Array(1...9)
                    numbers.shuffle()
                    
                    // fill each cell with a random number from 1-9
                    for num in numbers {
                        // checks if filling the cell with a given number between 1-9 abides to the rules of Sudoku
                        if checkValid(row: row, col: col, num: num, grid: &grid) {
                            grid[row][col] = num // if this number is valid to be in this cell, update the grid array to contain this number
                            if fillGrid() { // if one cell is successfully filled, recursively check the entire grid to fill the next cell. Rinse and repeat.
                                return true
                            }
                            grid[row][col] = 0 // if none of the numbers from 1-9 is valid in this cell, the recursion is exited and this cell is initialized to 0 again (to indicate that it is empty and needs to be filled)
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
            if grid[i][col] == num || grid[row][i] == num { // checks each row and column. If the row and column this current cell is in already has this number, return false so this cell can be filled with the next number
                return false
            }
        }
        
        let smallCellRow: Int = (row / 3) * 3 // gets the starting row of the 3x3 grid
        let smallCellCol: Int = (col / 3) * 3 // gets the starting col of the 3x3 grid
        // checks each 3x3 grid
        for i in smallCellRow..<smallCellRow + 3 {
            for j in smallCellCol..<smallCellCol + 3 {
                if grid[i][j] == num { // if the number that wants to be filled into this cell already exists in the 3x3, return false
                    return false
                }
            }
        }
        return true // otherwise, return true. This number can be filled in this cell without violating the rules of Sudoku
    }
    
    func removedNumbers(numClues clues: Int, grid: inout [[Int]]) {
        // create a list of all cell positions
        var positions: [(Int, Int)] = [(Int, Int)]()
        for row in 0..<9 {
            for col in 0..<9 {
                positions.append((row, col))
            }
        }
        
        positions.shuffle() // cell positions are no longer in order
        
        while positions.count > 0 && numFilledCells(&grid) > clues { // if the number of filled cells is greater than the number of cells that need to remain filled (number of clues)
            let (row, col) = positions.removeFirst() // remove the value of a cell (now the cell is empty)
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
        if restart { // if the game is restarted, re-initialize the array of actual values and notes so a new boad can be generated again
            grid = Array(repeating: Array(repeating: 0, count: 9), count: 9)
            notesBool = Array(repeating: Array(repeating: Array(repeating: Array(repeating: false, count: 9), count: 9), count: 9), count: 9)
        }
        _ = fillGrid() // the grid gets completely filled with a valid solution (new board is generated)
        fullGrid = grid
        removedNumbers(numClues: clues, grid: &grid) // removes all cells (so they are empty) and keeping only the values in x number of cells (this is the number of clues)
    }
    
    func printGrid() {
        for row in grid {
            print(row.map({ String($0) }).joined(separator: " ")) // prints the game board (including empty cells)
        }
        print("-----------------")
        for row in fullGrid {
            print(row.map({ String($0) }).joined(separator: " ")) // prints the solutions board (all cells have a value)
        }
    }
    
    func playBoard() -> [[Int]]{ // returns the board containing 0s (empty cells)
        return grid
    }
    
    func fullBoard() -> [[Int]]{ // returns the solutions board
        return fullGrid
    }
    
    func cellBool() {
        for row in 0..<9 {
            for col in 0..<9 {
                boolCheck[row][col] = (grid[row][col] == 0) // generates a boolean board. Bool for each cell is true if empty, false otherwise
            }
        }
    }
    
    func updateCell(row: Int, col: Int, num: Int, bool: Bool) {
        // when a new number is added to an editable cell, that cell gets updated to the number selected and the boolean is false (indicating this cell is no longer empty)
        grid[row][col] = num
        boolCheck[row][col] = bool
    }
    
    func boolBoard() -> [[Bool]] {
        cellBool()
        return boolCheck
    }
    
    func updateNotes(row: Int, col: Int, noteRow: Int, noteCol: Int, bool: Bool) {
        // updates the mini grid of the notes with a boolean (true for editable, false for non-editable)
        notesBool[row][col][noteCol][noteRow] = bool
    }
    
    func notesGrid() -> [[[[Int]]]] {
        return notes // return notes array [[1, 2, 3], [4, 5, 6], [7, 8, 9]] for each cell
    }
    
    func notesBoolGrid() -> [[[[Bool]]]] {
        return notesBool // returns notes bool array (true/false for each note's mini-cell)
    }
    
}
