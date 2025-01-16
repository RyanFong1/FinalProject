//
// ContentView.swift
// Sudoku
//
// Created by Grace She on 2025-01-13

// restart button

import SwiftUI

struct CellChanges: View {
    @ObservedObject var board = Board()
    @Binding var tapped: Bool
    @Binding var fill: [Bool]
    var row: Int
    var col: Int
    @State var cellNum = false
    @Binding var currentNumber : Int
    @Binding var newlyAdded: [[Int]]
    @Binding var lives: [Bool]
    @State private var navigateToGameOver = false
    @Binding var gameOver: Bool

    
    var body: some View {

        ZStack {
            Rectangle()
                .fill(Color.white)
                .border(.black)
                .frame(width: 40, height: 40)
                .onTapGesture {
                    if currentNumber != -1 {
                        board.updateCell(row: row, col: col, num: currentNumber)
                        board.printGrid()
                        if !newlyAdded.contains([row, col]) {
                            newlyAdded.append([row, col])
                        }
                        if board.playBoard()[row][col] != board.fullBoard()[row][col] {
                            if lives.count > 0 {
                                lives.removeLast()
                            } else {
                                gameOver = true
                            }
                        }
                        print("\(newlyAdded)")
                    }
                    cellNum = true

                }
            
        }
        
        .onChange(of: currentNumber) {
            cellNum = false
        }
    }
}

struct BoardView: View {
    
    @ObservedObject var board = Board()
    
    @State var tapLocation: CGPoint?
    @Binding var fill: [Bool]
    @Binding var tapped: Bool
    @State var tappedCellIndex = 0
    @Binding var currentNum: Int
    @Binding var newlyAdded: [[Int]]
    @Binding var lives: [Bool]
    @Binding var gameOver: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self) { col in
                            // Create a binding for each sudoku cell
                            if board.boolBoard()[row][col] {
                                CellChanges(board: board, tapped: $tapped, fill: $fill, row: row, col: col, currentNumber: $currentNum, newlyAdded: $newlyAdded, lives: $lives, gameOver: $gameOver)
                                    .onTapGesture {
                                        currentNum = -1
                                    }
                            } else {
                                ZStack {
                                    Rectangle()
                                        .fill(.white)
                                        .border(.black)
                                        .frame(width: 40, height: 40)
                                    Text("\(board.playBoard()[row][col])")
                                        .foregroundColor(board.playBoard()[row][col] == board.fullBoard()[row][col] ? .black : .red)
                                        .font(.system(size: 29, weight: .medium))
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


struct ContentView: View {
    
    @State private var notes = false
    @State private var erase = false
    @State private var undo = false
    @State var tapLocation: CGPoint?
    
    @State var fill = Array(repeating: false, count: 81)
    @State var tapped = false
    @State var currentNumber = -1

    private var actions = ["Undo", "Erase", "Notes", "Hint"]
    
    private var board = Board()
    
    @State private var isPressed = false
    @State var colorUndo = Color.blue.opacity(1.0)
    @State var newlyAdded: [[Int]] = [] // will contain coordinates the newly added cells
    
    @State var lives = [true, true, true]
    @State var gameOver = false
    @State var restart = false
    @State private var one = false
    @State private var two = false
    @State private var three = false
    @State private var four = false
    @State private var five = false
    @State private var six = false
    @State private var seven = false
    @State private var eight = false
    @State private var nine = false

    
    var body: some View {
        
        ZStack {
            VStack {
                if lives.count == 3 {
                    HStack(spacing: 8) {
                        ForEach(1..<4) { _ in
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 30, height: 27)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 50)
                } else if lives.count == 2 {
                    HStack(spacing: 8) {
                        ForEach(1..<3) { _ in
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 30, height: 27)
                                .foregroundColor(.red)
                        }
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 30, height: 27)
                    }
                    .padding(.top, 50)
                } else if lives.count == 1 {
                    HStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 30, height: 27)
                            .foregroundColor(.red)
                        ForEach(1..<3) { _ in
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 30, height: 27)
                        }
                    }
                    .padding(.top, 50)
                } else if lives.count == 0 {
                    HStack(spacing: 8) {
                        ForEach(1..<4) { _ in
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 30, height: 27)
                        }
                    }
                    .padding(.top, 50)
                }
                Spacer()
                ZStack {
                    BoardView(board: board, fill: $fill, tapped: $tapped, currentNum: $currentNumber, newlyAdded: $newlyAdded, lives: $lives, gameOver: $gameOver)
                    CellView()
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(one ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("1")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 1
                                    toggleFillerActions(action: "one")
                                }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(two ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("2")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 2
                                    toggleFillerActions(action: "two")
                                }
                            
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(three ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("3")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 3
                                    toggleFillerActions(action: "three")
                                }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(four ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("4")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 4
                                    toggleFillerActions(action: "four")
                                }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(five ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("5")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 5
                                    toggleFillerActions(action: "five")
                                }
                        }
                        
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(six ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("6")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 6
                                    toggleFillerActions(action: "six")
                                }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(seven ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("7")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 7
                                    toggleFillerActions(action: "seven")
                                }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(eight ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("8")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 8
                                    toggleFillerActions(action: "eight")
                                }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(nine ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                                .frame(width: 50 , height: 60)
                            Text("9")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    currentNumber = 9
                                    toggleFillerActions(action: "nine")
                                }
                        }
                        
                    }
                }
                
                HStack(spacing: 25) {
                    
                    // Undo
                    VStack {
                        Circle()
                            .foregroundColor(colorUndo)
                            .frame(width: 80, height: 80)
                            .overlay (
                                Image(systemName: "arrow.counterclockwise")
                                    .resizable()
                                    .frame(width: 40, height: 45)
                                    .foregroundColor(.white)
                            )
                        //                        .onTapGesture {
                        
                        
                        //                            toggleActions(action: "undo")
                        //                        }
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged {_ in
                                        colorUndo = Color.blue.opacity(0.5)
                                    }
                                    .onEnded { _ in
                                        colorUndo = Color.blue.opacity(1.0)
                                        if newlyAdded.count > 0 {
                                            let last = newlyAdded.removeLast()
                                            board.updateCell(row: last[0], col: last[1], num: 0)
                                        }
                                    }
                            )
                        
                        
                        Text(actions[0]) // "Undo"
                    }
                    
                    // Erase
                    VStack {
                        Circle()
                            .foregroundColor(erase ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                            .frame(width: 80, height: 80)
                            .overlay (
                                Image(systemName: "eraser")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.white)
                            )
                            .onTapGesture {
                                toggleActions(action: "erase")
                            }
                        Text(actions[1]) // "Erase"
                    }
                    
                    // Notes
                    VStack {
                        Circle()
                            .foregroundColor(notes ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                            .frame(width: 80, height: 80)
                            .overlay (
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 43, height: 43)
                                    .foregroundColor(.white)
                                    .offset(x: 3.5, y: -2)
                            )
                            .onTapGesture {
                                toggleActions(action: "notes")
                            }
                        Text(actions[2]) // "Notes"
                    }
                }
                
            }
            .onAppear {
                board.generateBoard(numClues: 30, restart: restart)
                board.printGrid()
                print(board.generateBoolBoard())
            }
            
            if gameOver {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .border(.black, width: 5)
                        .frame(width: 300, height: 200)
                    VStack {
                        Text("GAME LOST")
                            .font(.largeTitle)
                        Button(action: {
                            board.printGrid()
                            gameOver = false
                            restart = true
                            lives = [true, true, true]
                            board.generateBoard(numClues: 30, restart: restart)
                            board.printGrid()
                        }) {
                            Text("Restart")
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
    
//    private func toggleActions(action: String, cellBool: Bool, cellValue: Int, cellNotes: Int) {
//        if action == "undo" {
//            if cellBool {
//                undo = true
//            }
//        }
//        
//        if action == "notes" {
//            notes = true
//            if cellBool {
//                if cellValue != 0 || cellNotes != 0 { // need to create notes and allow cell value and cell notes to be entered
//                    erase = true
//                    undo = true
//                } else {
//                    erase = false
//                }
//            }
//        }
    private func toggleActions(action: String) {
        undo = action == "undo"
        erase = action == "erase"
        notes = action == "notes"
    }
    
    private func toggleFillerActions(action: String) {
        one = action == "one"
        two = action == "two"
        three = action == "three"
        four = action == "four"
        five = action == "five"
        six = action == "six"
        seven = action == "seven"
        eight = action == "eight"
        nine = action == "nine"
    }
}


#Preview {
    ContentView()
}
