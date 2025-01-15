//
// ContentView.swift
// Sudoku
//
// Created by Grace She on 2025-01-13

import SwiftUI

struct CellChanges: View {
    @ObservedObject var board = Board()
    @State var state: Bool
    @Binding var tapped: Bool
    @Binding var fill: [Bool]
    @Binding var tappedCellIndex: Int
    @Binding var fillNum: [Bool]
    var row: Int
    var col: Int
    @State var cellNum = false
    @Binding var currentNumber : Int
    @Binding var newlyAdded: [[Int]]
    

    
    var body: some View {

        ZStack {
            Rectangle()
                .fill(Color.white)
                .border(.black)
                .frame(width: 40, height: 40)
                .onTapGesture {
                    cellNum = true
                    if currentNumber != -1 {
                        board.updateCell(row: row, col: col, num: currentNumber)
//                        board.generateBoolBoard()
                        newlyAdded.append([row, col])
                        print("\(newlyAdded)")
                    }

                }
            if (cellNum) && (currentNumber != -1) && (newlyAdded.contains([row, col])) {
                Text("\(currentNumber)")
                    .foregroundColor(.black)
                    .font(.system(size: 29, weight: .medium))
//                            fillNum = [false, false, false, false, false, false, false, false, false]
                            
            
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
    @State var tapped = false
    @State var tappedCellIndex = 0
    @Binding var fillNum: [Bool]
    @Binding var currentNum: Int
    @Binding var newlyAdded: [[Int]]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self) { col in
                            // Create a binding for each sudoku cell
                            if board.generateBoolBoard()[row][col] {
                                CellChanges(board: board, state: board.generateBoolBoard()[row][col], tapped: $tapped, fill: $fill, tappedCellIndex: $tappedCellIndex, fillNum: $fillNum, row: row, col: col, currentNumber: $currentNum, newlyAdded: $newlyAdded)
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
    
    @State var fillNum = [false, false, false, false, false, false, false, false, false]
    @State var fill = Array(repeating: false, count: 81)
    @State var tapped = false
    @State var tappedCellIndex = 0
    @State var currentNumber = -1

    private var actions = ["Undo", "Erase", "Notes", "Hint"]
    
    private var board = Board()
    
    @State private var isPressed = false
    @State var colorUndo = Color.blue.opacity(1.0)
    @State var newlyAdded: [[Int]] = [] // will contain coordinates the newly added cells
    
    var body: some View {
        
        VStack {
            HStack(spacing: 8) {
                ForEach(1..<4) { _ in
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 23, height: 20)
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 50)
            Spacer()
            ZStack {
                BoardView(board: board, fill: $fill, fillNum: $fillNum, currentNum: $currentNumber, newlyAdded: $newlyAdded)
                CellView()
            }
            
            Spacer()
            
            VStack {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("1")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
//                                fillNum = [true, false, false, false, false, false, false, false, false]
//                                print(fill)
                                currentNumber = 1
                                print("1 was tapped!")
                            }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("2")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
                                currentNumber = 2
                            }

                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("3")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
                                currentNumber = 3
                            }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("4")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
                                currentNumber = 4
                            }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("5")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
                                currentNumber = 5
                            }
                    }
                    
                }
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("6")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
                                currentNumber = 6
                            }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("7")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
                                currentNumber = 7
                            }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("8")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
                                currentNumber = 8
                            }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .border(.black)
                            .frame(width: 50 , height: 60)
                        Text("9")
                            .font(.system(size: 45, weight: .semibold))
                            .foregroundColor(.red)
                            .onTapGesture {
                                currentNumber = 9
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
//                                    if newlyAdded.count > 0 {
//                                        colorUndo = Color.blue.opacity(1.0)
//                                    }
                                    }
                                .onEnded { _ in
                                    colorUndo = Color.blue.opacity(1.0)
                                    if newlyAdded.count > 0 {
                                        var last = newlyAdded.removeLast()
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
            board.generateBoard(numClues: 30)
            board.printGrid()
            print(board.generateBoolBoard())
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
    
//    private func whileTapping() {
//        Circle()
//            .foregroundColor(Color.blue.opacity(1.0))
//            .frame(width: 80, height: 80)
//            .overlay (
//                Image(systemName: "arrow.counterclockwise")
//                    .resizable()
//                    .frame(width: 40, height: 45)
//                    .foregroundColor(.white)
//            )
//    }
//    
//    private func afterTapping() {
//        Circle()
//            .foregroundColor(Color.blue.opacity(0.5))
//            .frame(width: 80, height: 80)
//            .overlay (
//                Image(systemName: "arrow.counterclockwise")
//                    .resizable()
//                    .frame(width: 40, height: 45)
//                    .foregroundColor(.white)
//            )
//    }
}

#Preview {
    ContentView()
}
