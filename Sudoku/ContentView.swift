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
    @Binding var undo: Bool
    @Binding var gameWon: Bool
    @Binding var erase: Bool
    @Binding var notes: Bool
    @Binding var notesNum: Int
    @Binding var notesList: [[Int]]
    
    var body: some View {

        ZStack {
            Rectangle()
                .fill(Color.white)
                .border(.black)
                .frame(width: 39, height: 39)
                .onTapGesture {
                    if currentNumber != -1 {
                        if notes {
                            
                            for noteRow in 0..<3 {
                                for noteCol in 0..<3 {
                                    if board.notesGrid()[row][col][noteCol][noteRow] == currentNumber {
                                        board.updateNotes(row: row, col: col, num: currentNumber-1, noteRow: noteRow, noteCol: noteCol, bool: true)
                                        notesList.append([row, col, noteCol, noteRow])
                                        print(notesList)
                                        print(board.notesBoolGrid())
                                    }
                                }
                            }
                            
                        } else {
                            
                            board.updateCell(row: row, col: col, num: currentNumber, bool: false)
                            board.printGrid()
                            if !newlyAdded.contains([row, col]) {
                                newlyAdded.append([row, col])
                            }
                            if newlyAdded.count <= 0 {
                                undo = false
                                erase = false
                            } else {
                                undo = true
                            }
                            if board.playBoard()[row][col] != board.fullBoard()[row][col] {
                                if lives.count > 0 {
                                    lives.removeLast()
                                } else {
                                    gameOver = true
                                }
                            }
                            if board.playBoard() == board.fullBoard() {
                                gameWon = true
                            }
                            print("\(newlyAdded)")
                        }
                        
                    }
                }
        }


    }
}

struct PrintNum: View {
    @ObservedObject var board = Board()
    var row: Int
    var col: Int
    @Binding var erase: Bool
    @Binding var newlyAdded: [[Int]]
    @Binding var undo: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .border(.black)
                .frame(width: 39, height: 39)
            Text("\(board.playBoard()[row][col])")
                .foregroundColor(board.playBoard()[row][col] == board.fullBoard()[row][col] ? .black : .red)
                .font(.system(size: 29, weight: .medium))
                .onTapGesture {
                    if erase {
                        if newlyAdded.contains([row, col]) {
                            if let firstIndex = newlyAdded.firstIndex(of: [row, col]) {
                                newlyAdded.remove(at: firstIndex)
                                if newlyAdded.count == 0 {
                                    erase = false
                                    undo = false
                                }
                            }
                            board.updateCell(row: row, col: col, num: 0, bool: true)
                        }
                    }
                }
        }
    }
}


struct PrintFilledNotes: View {
    
    @Binding var currentNum: Int
    
    var body: some View {
        Text("\(currentNum)")
            .foregroundColor(.blue)
            .font(.system(size: 10, weight: .regular))
    }
}

struct PrintBlankNotes: View {
    
    @ObservedObject var board = Board()
    var row: Int
    var col: Int
    @Binding var currentNum: Int
    @Binding var notes: Bool
    @Binding var notesNum: Int
    @Binding var notesList: [[Int]]
    
    var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { noteRow in
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { noteCol in
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .border(.clear)
                                    .frame(width: (39/3), height: (39/3))
                                ForEach(0..<9, id:\.self) { num in
                                    if currentNum != -1 && notesList.contains([row, col, noteCol, noteRow]) && board.notesBoolGrid()[row][col][noteCol][noteRow] {
                                        Text("\(board.notesGrid()[row][col][noteCol][noteRow])")
                                            .foregroundColor(.blue)
                                            .font(.system(size: 10, weight: .regular))
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
    
    }
}


struct BoardView: View {
    
    @ObservedObject var board = Board()
    
    @Binding var fill: [Bool]
    @Binding var tapped: Bool
    @State var tappedCellIndex = 0
    @Binding var currentNum: Int
    @Binding var newlyAdded: [[Int]]
    @Binding var lives: [Bool]
    @Binding var gameOver: Bool
    @Binding var undo: Bool
    @Binding var gameWon: Bool
    @Binding var erase: Bool
    @Binding var notes: Bool
    @Binding var notesNum: Int
    @Binding var notesList: [[Int]]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self)
                        { col in
                            // Create a binding for each sudoku cell
                            if board.boolBoard()[row][col] {
                                ZStack {
                                    CellChanges(board: board, tapped: $tapped, fill: $fill, row: row, col: col, currentNumber: $currentNum, newlyAdded: $newlyAdded, lives: $lives, gameOver: $gameOver, undo: $undo, gameWon: $gameWon, erase: $erase, notes: $notes, notesNum: $notesNum, notesList: $notesList)
                                    PrintBlankNotes(board: board, row: row, col: col, currentNum: $currentNum, notes: $notes, notesNum: $notesNum, notesList: $notesList)
                                }
                            } else {
                                PrintNum(board: board, row: row, col: col, erase: $erase, newlyAdded: $newlyAdded, undo: $undo)

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
    
    @State var fill = Array(repeating: false, count: 81)
    @State var tapped = false
    @State var currentNumber = -1

    private var actions = ["Undo", "Erase", "Notes", "Hint"]
    
    private var board = Board()
    
    @State private var isPressed = false
    @State var colorUndo = Color.blue.opacity(0.5)
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
    @State private var instructions = true
    @State private var firstTime = true
    @State private var imageName = "questionmark.circle"
    @State var gameWon = false
    @State var levelSelection = false
    @State var numClues = 0
    @State var eraseRow = 0
    @State var eraseCol = 0
    @State var notesNum = 0
    @State var notesList: [[Int]] = []
    
    var body: some View {
        
        ZStack {
            VStack {
                if lives.count == 3 {
                    ZStack {
                        HStack(spacing: 8) {
                            ForEach(1..<4) { _ in
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 30, height: 27)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.top, 50)
                        Image(systemName: imageName)
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(width: 70, height: 70)
                            .padding(.leading, 270)
                            .padding(.top, 10)
                            .onTapGesture {
                                imageName = "questionmark.circle"
                                instructions = true
                            }
                    }
                } else if lives.count == 2 {
                    ZStack {
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
                        Image(systemName: imageName)
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(width: 70, height: 70)
                            .padding(.leading, 270)
                            .padding(.top, 10)
                            .onTapGesture {
                                imageName = "questionmark.circle"
                                instructions = true
                            }
                    }
                } else if lives.count == 1 {
                    ZStack {
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
                        Image(systemName: imageName)
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(width: 70, height: 70)
                            .padding(.leading, 270)
                            .padding(.top, 10)
                            .onTapGesture {
                                imageName = "questionmark.circle"
                                instructions = true
                            }
                    }
                } else if lives.count == 0 {
                    ZStack {
                        HStack(spacing: 8) {
                            ForEach(1..<4) { _ in
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 30, height: 27)
                            }
                        }
                        .padding(.top, 50)
                        Image(systemName: imageName)
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(width: 70, height: 70)
                            .padding(.leading, 270)
                            .padding(.top, 10)
                            .onTapGesture {
                                imageName = "questionmark.circle"
                                instructions = true
                            }
                    }
                }
                Spacer()
                ZStack {
                    BoardView(board: board, fill: $fill, tapped: $tapped, currentNum: $currentNumber, newlyAdded: $newlyAdded, lives: $lives, gameOver: $gameOver, undo: $undo, gameWon: $gameWon, erase: $erase, notes: $notes, notesNum: $notesNum, notesList: $notesList)
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
                            .foregroundColor(undo ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5))
                            .frame(width: 80, height: 80)
                            .overlay (
                                Image(systemName: "arrow.counterclockwise")
                                    .resizable()
                                    .frame(width: 40, height: 45)
                                    .foregroundColor(.white)
                            )
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged {_ in
                                        undo = false
                                    }
                                    .onEnded { _ in
                                        if newlyAdded.count > 0 {
                                            undo.toggle()
                                            let last = newlyAdded.removeLast()
                                            board.updateCell(row: last[0], col: last[1], num: 0, bool: true)
                                            if newlyAdded.count == 0 {
                                                undo = false
                                            }
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

            if instructions {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .border(.black, width: 5)
                        .frame(width: 300, height: 325)
                }
                VStack {
                    Text("Instructions")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Text("""
    1. Fill the 9x9 grid with 
        numbers 1-9
    2. In each row, each column, 
        and each 3x3 box, the numbers 
        1-9 must only appear ONCE
    3. Use the existing numbers
        as clues
    4. Good luck!
    """)
                    Button(action: {
                        instructions = false
                        if firstTime {
                            levelSelection = true
                            firstTime = false
                        }
                        imageName = "questionmark.circle.fill"
                    }) {
                        Text("Close")
                            .font(.title)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            
            if levelSelection {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .border(.black, width: 5)
                        .frame(width: 200, height: 200)
                    VStack {
                        Button(action: {
                            board.generateBoard(numClues: 50, restart: restart)
                            board.printGrid()
                            print(board.generateBoolBoard())
                            levelSelection = false
                        }) {
                            Text("Easy")
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            board.generateBoard(numClues: 40, restart: restart)
                            board.printGrid()
                            print(board.generateBoolBoard())
                            levelSelection = false
                        }) {
                            Text("Medium")
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            board.generateBoard(numClues: 30, restart: restart)
                            board.printGrid()
                            print(board.generateBoolBoard())
                            levelSelection = false
                        }) {
                            Text("Hard")
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            
            if gameOver || gameWon {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .border(.black, width: 5)
                        .frame(width: 300, height: 200)
                    VStack {
                        Text(gameOver ? "GAME LOST" : "GAME WON")
                            .font(.largeTitle)
                        Button(action: {
                            board.printGrid()
                            gameOver = false
                            gameWon = false
                            restart = true
                            lives = [true, true, true]
                            one = false
                            two = false
                            three = false
                            four = false
                            five = false
                            six = false
                            seven = false
                            eight = false
                            nine = false
                            currentNumber = -1
                            undo = false
                            erase = false
                            notes = false
                            newlyAdded = []
                            levelSelection = true
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
    
    private func toggleActions(action: String) {
        if erase {
            erase = false
        } else {
            erase = action == "erase"
        }
        
        if notes {
            notes = false
        } else {
            notes = action == "notes"
        }
        
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
