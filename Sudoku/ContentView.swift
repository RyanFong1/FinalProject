//
// ContentView.swift
// Sudoku
//
// Created by Grace She on 2025-01-13

import SwiftUI

struct CellChanges: View {
    @ObservedObject var board = Board()
    var row: Int
    var col: Int
    @Binding var currentNumber : Int
    @Binding var newlyAdded: [[Int]]
    @Binding var lives: [Bool]
    @Binding var gameOver: Bool
    @Binding var undo: Bool
    @Binding var gameWon: Bool
    @Binding var erase: Bool
    @Binding var notes: Bool
    
    var body: some View {

        ZStack {
            Rectangle()
                .fill(Color.white)
                .border(.black)
                .frame(width: 39, height: 39)
                .onTapGesture {
                    if erase {
                        
                        let removeItem = [row, col] // coordinates of the cell to erase
                        
                        // updates the newlyAdded array (contains all the filled cell coordinates) after filtering out (taking out) the element that matches the removeItem array (the coordinates to remove)
                        newlyAdded = newlyAdded.filter { subarray in
                            if let firstIndex = subarray.firstIndex(of: removeItem[0]), subarray[firstIndex + 1] == removeItem[1] {
                                board.updateNotes(row: row, col: col, noteRow: subarray[3], noteCol: subarray[2], bool: false) // updates the array containing boolean values for notes cell (false means it is available for filling in again)
                                return false

                            }
                            return true
                        }
                        if newlyAdded.count == 0 {
                            // erase and undo modes are disabled if there are no more items to remove
                            erase = false
                            undo = false
                        }
                    
    
                    } else if currentNumber != -1 {
                            if notes { // if notes mode is enabled
                                // 2 for-loops for looping through a mini 3x3 grid in each cell that represents the locations for the notes
                                for noteRow in 0..<3 {
                                    for noteCol in 0..<3 {
                                        // if the number button selected at the bottom of the screen matches the corresponding notes value, update the notesBool array so that the corresponding boolean value for this selected cell is true – a note can now be printed in the cell as a small blue number
                                        if board.notesGrid()[row][col][noteCol][noteRow] == currentNumber {
                                            board.updateNotes(row: row, col: col, noteRow: noteRow, noteCol: noteCol, bool: true)
                                            // add the coordinate of the notes to the array containing all the edited cell
                                            if !newlyAdded.contains([row, col, noteCol, noteRow]) {
                                                newlyAdded.append([row, col, noteCol, noteRow])
                                            }
                                        }
                                    }
                                }
                                if newlyAdded.count <= 0{
                                    // undo and erase modes disabled if all editable cell are empty
                                    undo = false
                                    erase = false
                                }
                            
                            } else { // if NOT in notes mode (regular mode)
                                if !erase {
                                    // update the array containing actual values for each cell with the new value that has been selected to be placed in the selected cell and also turns the location to false so it can no longer be edited
                                    board.updateCell(row: row, col: col, num: currentNumber, bool: false)
                                    if !newlyAdded.contains([row, col]) {
                                        newlyAdded.append([row, col])
                                    }
                                    if newlyAdded.count <= 0 {
                                        undo = false
                                        erase = false
                                    } else {
                                        // if there are still filled-in values, the undo mode is enabled
                                        undo = true
                                    }
                                    // checks if the filled in number is the incorrect number to be in the filled cell
                                    if board.playBoard()[row][col] != board.fullBoard()[row][col] {
                                        // if there are still lives remaining, remove a life
                                        if lives.count > 0 {
                                            lives.removeLast()
                                        } else { // if there are no more lives remaining, player "dies" and game over
                                            gameOver = true
                                        }
                                    }
                                    // check if the player's filled in board is the same as the actual board (with solutions)
                                    if board.playBoard() == board.fullBoard() {
                                        gameWon = true // if the filled board completely matches the solutions, game is won
                                    }
                                }
                                
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
        ZStack { // draws a rectangle (the cell) and prints a number on top of the rectangle (the number in each cell)
            Rectangle()
                .fill(.white)
                .border(.black)
                .frame(width: 39, height: 39)
            Text("\(board.playBoard()[row][col])") // prints the corresponding number for the grid
                .foregroundColor(board.playBoard()[row][col] == board.fullBoard()[row][col] ? .black : .red) // if correct number, print in black. If an incorrect number is placed in the cell, print the number in red
                .font(.system(size: 29, weight: .medium))
                .onTapGesture {
                    if erase { // if the cell is tapped and erase mode is enabled
                        if newlyAdded.contains([row, col]) { // if the tapped cell is an editable cell (not a clue) and a number has already been added to this cell
                            if let firstIndex = newlyAdded.firstIndex(of: [row, col]) {
                                newlyAdded.remove(at: firstIndex) // remove the number from the chosen cell
                                if newlyAdded.count == 0 {
                                    erase = false
                                    undo = false
                                }
                            }
                            // update the array after removing the number from the chosen cell so that it is editable again
                            board.updateCell(row: row, col: col, num: 0, bool: true)
                        }
                    }
                }
        }
    }
}

struct PrintBlankNotes: View {
    
    @ObservedObject var board = Board()
    var row: Int
    var col: Int
    @Binding var currentNum: Int
    @Binding var notes: Bool
    @Binding var newlyAdded: [[Int]]
    
    
    var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { noteRow in
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { noteCol in
                            ZStack {
                                // print a clear small cell representing where each note should be
                                Rectangle()
                                    .fill(.clear)
                                    .border(.clear)
                                    .frame(width: (39/3), height: (39/3))
                                ForEach(0..<9, id:\.self) { num in
                                    // if the notes cell was edited, print the note value in the corresponding notes cell as a small blue number
                                    if currentNum != -1 && newlyAdded.contains([row, col, noteCol, noteRow]) && board.notesBoolGrid()[row][col][noteCol][noteRow] {
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
    

    @Binding var currentNum: Int
    @Binding var newlyAdded: [[Int]]
    @Binding var lives: [Bool]
    @Binding var gameOver: Bool
    @Binding var undo: Bool
    @Binding var gameWon: Bool
    @Binding var erase: Bool
    @Binding var notes: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self)
                        { col in
                            // After looping through each cell, check if the cell is editable (empty)
                            if board.boolBoard()[row][col] { // if cell is empty/editable
                                ZStack {
                                    // Checks if user wants to print notes or print an actual value
                                    CellChanges(board: board, row: row, col: col, currentNumber: $currentNum, newlyAdded: $newlyAdded, lives: $lives, gameOver: $gameOver, undo: $undo, gameWon: $gameWon, erase: $erase, notes: $notes)
                                    // prints the mini cells for notes in each empty cell
                                    PrintBlankNotes(board: board, row: row, col: col, currentNum: $currentNum, notes: $notes, newlyAdded: $newlyAdded)
                                }
                            } else { // if the cell is edited/not editable, print the corresponding value in the cell
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
    
    private var board = Board() // instantiate an object for the Board class
    
    // all modes are initialized as false (disabled)
    @State private var notes = false
    @State private var erase = false
    @State private var undo = false
    
    @State var currentNumber = -1 // current number initialized to -1 so none of the numbers are selected (1-9)
    
    @State var colorUndo = Color.blue.opacity(0.5) // color of the undo button is initialized as light blue to represent the mode being disabled
    @State var newlyAdded: [[Int]] = [] // will contain coordinates the newly added cells
    
    @State var lives = [true, true, true] // start with three hearts (technically you have four lives b/c even after all three hearts has been lost you still have one more life remaining)
    @State var gameOver = false // initialize game as NOT over
    @State var restart = false
    // none of the number buttons are selected – all are initialized as false (disabled)
    @State private var one = false
    @State private var two = false
    @State private var three = false
    @State private var four = false
    @State private var five = false
    @State private var six = false
    @State private var seven = false
    @State private var eight = false
    @State private var nine = false
    @State private var instructions = true // prints the instructions upon starting the game
    @State private var firstTime = true // first time the player plays. When it's the first time, the instructions appear before the level selection. Otherwise, the instructions popup will only appear when the player taps on the info icon in the top right corner
    @State private var imageName = "questionmark.circle" // initialize the info icon to be tapped b/c the instructions appear first (this is for imitating the info icon has been tapped)
    @State var gameWon = false // game is obviously not won when it has just begun so it's initialized to false
    @State var levelSelection = false // level selection does not appear first. It gets initialized to true after the instructions popup is closed so the level selection popup will appear
    @State var numClues = 0 // start with 0 clues. This will be changed according to the level od difficulty that is selected
    
    var body: some View {
        
        ZStack {
            VStack { // vertically stacks lives, info icon, board, number options, and modes buttons (undo, erase, notes)
                if lives.count == 3 { // if none of the hearts has been lost
                    ZStack {
                        // horizontally print 3 filled hearts
                        HStack(spacing: 8) {
                            ForEach(1..<4) { _ in
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 30, height: 27)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.top, 50)
                        // prints the info icon
                        Image(systemName: imageName)
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(width: 70, height: 70)
                            .padding(.leading, 270)
                            .padding(.top, 10)
                            .onTapGesture { // when the icon is tapped, change the icon to be filled and the instructions bool to true so the instructions pop up will appear
                                imageName = "questionmark.circle"
                                instructions = true
                            }
                    }
                } else if lives.count == 2 { // if one life has been lost
                    ZStack {
                        HStack(spacing: 8) { // horizontally print 2 filled hearts and 1 empty heart
                            ForEach(1..<3) { _ in
                                Image(systemName: "heart.fill") // prints filled hearts
                                    .resizable()
                                    .frame(width: 30, height: 27)
                                    .foregroundColor(.red)
                            }
                            Image(systemName: "heart") // prints empty heart
                                .resizable()
                                .frame(width: 30, height: 27)
                        }
                        .padding(.top, 50)
                        // print the info icon
                        Image(systemName: imageName)
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(width: 70, height: 70)
                            .padding(.leading, 270)
                            .padding(.top, 10)
                            .onTapGesture { // when the icon is tapped, change the icon to be filled and the instructions bool to true so the instructions pop up will appear
                                imageName = "questionmark.circle"
                                instructions = true
                            }
                    }
                } else if lives.count == 1 { // if two hearts has been lost
                    ZStack {
                        HStack(spacing: 8) { // hortizontally print 1 filled heart and 2 empty hearts
                            Image(systemName: "heart.fill") // prints filled heart
                                .resizable()
                                .frame(width: 30, height: 27)
                                .foregroundColor(.red)
                            ForEach(1..<3) { _ in
                                Image(systemName: "heart") // prints empty hearts
                                    .resizable()
                                    .frame(width: 30, height: 27)
                            }
                        }
                        // print the info icon
                        .padding(.top, 50)
                        Image(systemName: imageName)
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(width: 70, height: 70)
                            .padding(.leading, 270)
                            .padding(.top, 10)
                            .onTapGesture { // when the icon is tapped, change the icon to be filled and the instructions bool to true so the instructions pop up will appear
                                imageName = "questionmark.circle"
                                instructions = true
                            }
                    }
                } else if lives.count == 0 { // if all three hearts has been lost
                    ZStack {
                        HStack(spacing: 8) { // horizontally print three empty hearts
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
                            .onTapGesture { // when the icon is tapped, change the icon to be filled and the instructions bool to true so the instructions pop up will appear
                                imageName = "questionmark.circle"
                                instructions = true
                            }
                    }
                }
                Spacer()
                ZStack { // prints the board
                    BoardView(board: board, currentNum: $currentNumber, newlyAdded: $newlyAdded, lives: $lives, gameOver: $gameOver, undo: $undo, gameWon: $gameWon, erase: $erase, notes: $notes)
                    CellView() // prints the board setup (the 3x3 grids and thick border of the board)
                }
                
                Spacer()
                
                VStack {
                    HStack { // horizontally displays the 1-5 bottons
                        ZStack {
                            RoundedRectangle(cornerRadius: 7) // rounded rectangle
                                .fill(one ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5)) // if the "one" button is selected, fill with dark blue (to indicate that it has been selected). Otherwise, fill with light blue (so it looks disabled)
                                .frame(width: 50 , height: 60)
                            Text("1")
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .onTapGesture { // tapping it indicates that this is the number the player wants to fill a cell/note cell with
                                    currentNumber = 1
                                    toggleFillerActions(action: "one") // turns all other number buttons to false (disables them)
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
                            .foregroundColor(undo ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5)) // if undo button is enabled (true), fill with dark blue to indicate that it is enabled. Otherwise, fill with light blue to show that it is "disabled"
                            .frame(width: 80, height: 80)
                            .overlay (
                                Image(systemName: "arrow.counterclockwise")
                                    .resizable()
                                    .frame(width: 40, height: 45)
                                    .foregroundColor(.white)
                            )
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged {_ in // when it is first tapped, the undo is turned to false
                                        undo = false
                                    }
                                    .onEnded { _ in // when it is not being tapped anymore, the undo is changed to true. This imitates the tapping gesture by flickering the colour of the button
                                        if newlyAdded.count > 0 {
                                            undo.toggle()
                                            let last = newlyAdded.removeLast() // undo the last value that was added. This edited cell is no longer in the list of edited cells
                                            if last.count == 2 { // if the last value was an actual value, update the actual board so the last added value is deleted
                                                board.updateCell(row: last[0], col: last[1], num: 0, bool: true)

                                            } else if last.count == 4 { // if the last value was a note, update the notes board so the last note added is deleted
                                                board.updateNotes(row: last[0], col: last[1], noteRow: last[3], noteCol: last[2], bool: false)
                                            }
                                            // if after undoing, there are no more values to undo/erase, disable the two buttons
                                            if newlyAdded.count == 0 {
                                                undo = false
                                                erase = false
                                            }
                                        }
                                    }
                            )
                        Text("Undo") // prints "Undo" below the round button
                    }
                    
                    // Erase
                    VStack {
                        Circle()
                            .foregroundColor(erase ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5)) // prints the circle in dark blue if erase mode is enabled, otherwise the circle button is printed in light blue to show that it is disabled
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
                        Text("Erase") // prints "Erase" below the round button
                    }
                    
                    // Notes
                    VStack {
                        Circle()
                            .foregroundColor(notes ? Color.blue.opacity(1.0) : Color.blue.opacity(0.5)) // prints the circle in dark blue if notes mode is enabled, otherwise the circle button is printed in light blue to show that the notes mode is disabled
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
                        Text("Notes") // prints "Notes" below the round button
                    }
                }
                
            }

            if instructions { // displays the instructions popup
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
                    Button(action: { // when the button is pressed, instructions gets turned to false so the popup will no longer be displayed. If it's the first game (firstTime == true), display the level selection popup after the instructions popup is closed (by chaning levelSelection to true)
                        instructions = false
                        if firstTime {
                            levelSelection = true
                            firstTime = false
                        }
                        imageName = "questionmark.circle.fill" // the info icon now looks different, showing that it can be pressed
                    }) {
                        Text("Close") // print "close" on the button
                            .font(.title)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            
            if levelSelection { // displays the various levels of difficulty
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .border(.black, width: 5)
                        .frame(width: 200, height: 200)
                    VStack {
                        Button(action: { // if the player selects easy mode, they start off with 50 hints
                            board.generateBoard(numClues: 50, restart: restart) // board is initialized with 50 hints (pre-existing values on the board)
                            levelSelection = false // level selection disappears
                        }) {
                            Text("Easy")
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            board.generateBoard(numClues: 40, restart: restart) // medium level gives the player 40 hints
                            levelSelection = false
                        }) {
                            Text("Medium")
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            board.generateBoard(numClues: 30, restart: restart) // hard level initializes the board with 30 known values (hints)
                            levelSelection = false
                        }) {
                            Text("Hard")
                                .font(.title)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            
            if gameOver || gameWon { // if game lost (all lives lost) or game won (board is correctly filled)
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .border(.black, width: 5)
                        .frame(width: 300, height: 200)
                    VStack {
                        Text(gameOver ? "GAME LOST" : "GAME WON") // prints "GAME LOST" if the player lost. Otherwise, print "GAME WON"
                            .font(.largeTitle)
                        Button(action: {
                            // initialize variables to restart the game
                            board.printGrid()
                            gameOver = false
                            gameWon = false
                            restart = true // during board generation, the board will be initialized to be empty before a new board is generated
                            lives = [true, true, true] // all lives are restored!
                            // none of the buttons are pressed
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
                            // none of the modes are enabled
                            undo = false
                            erase = false
                            notes = false
                            newlyAdded = [] // no more values in the array of edited cells
                            levelSelection = true // display level selection
                            
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
        if newlyAdded.count == 0 {
            erase = false
            undo = false
        } else {
            if erase { // if erase is true, pressing it again will turn it off to false. If erase is false, pressing it will turn it on to true
                erase = false
            } else {
                erase = action == "erase"
            }
        }
        
        
        if notes { // if notes is true, pressing it again will turn it off to false. If notes is false, pressing it will turn it on to true
            notes = false
        } else {
            notes = action == "notes"
        }
        
    }
    
    private func toggleFillerActions(action: String) {
        // pressing one of the number buttons will disable all others (turn them all to false)
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
    ContentView() // display everything
}
