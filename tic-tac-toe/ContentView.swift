//
//  ContentView.swift
//  tic-tac-toe
//
//  Created by Keegan Tjoa on 2025-01-13.
//

import SwiftUI

struct TicTacToeView: View {
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3) // Start with empty strings
    @State private var isPlayer1Turn: Bool = true
    @State private var resultMessage: String = ""
    @State private var gameOver: Bool = false

    var body: some View {
        ZStack {
            // Animated Background Color
            (isPlayer1Turn ? Color.red : Color.blue)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: isPlayer1Turn) // Smooth background transition

            VStack(spacing: 20) {
                // Title
                Text("Tic Tac Toe")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)

                // Game Board
                VStack(spacing: 0) { // No spacing for grid lines
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<3, id: \.self) { column in
                                Button(action: {
                                    handleTap(row: row, column: column)
                                }) {
                                    ZStack {
                                        // Animated Button Background
                                        Rectangle()
                                            .fill(isPlayer1Turn ? Color.red : Color.blue) // Matches the animated background color
                                            .frame(width: 100, height: 100)
                                            .animation(.easeInOut(duration: 0.5), value: isPlayer1Turn) // Smooth button transition

                                        // Player's mark (X or O)
                                        if !board[row][column].isEmpty {
                                            Text(board[row][column])
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .overlay(
                                    ZStack {
                                        if row != 0 {
                                            Rectangle()
                                                .frame(height: 2)
                                                .foregroundColor(.white)
                                                .offset(y: -50)
                                        }
                                        if row != 2 {
                                            Rectangle()
                                                .frame(height: 2)
                                                .foregroundColor(.white)
                                                .offset(y: 50)
                                        }
                                        if column != 0 {
                                            Rectangle()
                                                .frame(width: 2)
                                                .foregroundColor(.white)
                                                .offset(x: -50)
                                        }
                                        if column != 2 {
                                            Rectangle()
                                                .frame(width: 2)
                                                .foregroundColor(.white)
                                                .offset(x: 50)
                                        }
                                    }
                                )
                                .disabled(!board[row][column].isEmpty || gameOver)
                            }
                        }
                    }
                }

                // Display Turn or Result Message
                Text(resultMessage.isEmpty ? "Player \(isPlayer1Turn ? "X" : "O")'s Turn" : resultMessage)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                // Restart Button
                if gameOver {
                    Button("Restart Game") {
                        resetGame()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }

    // Handle a tile tap
    func handleTap(row: Int, column: Int) {
        if board[row][column].isEmpty { // Check if the cell is empty
            board[row][column] = isPlayer1Turn ? "X" : "O"
            if checkWin() {
                resultMessage = "Player \(isPlayer1Turn ? "X" : "O") Wins!"
                gameOver = true
            } else if checkTie() {
                resultMessage = "It's a Tie!"
                gameOver = true
            } else {
                withAnimation { // Animate the toggle
                    isPlayer1Turn.toggle()
                }
            }
        }
    }

    // Check for a win
    func checkWin() -> Bool {
        // Check rows and columns
        for i in 0..<3 {
            if board[i][0] == board[i][1], board[i][1] == board[i][2], !board[i][0].isEmpty {
                return true
            }
            if board[0][i] == board[1][i], board[1][i] == board[2][i], !board[0][i].isEmpty {
                return true
            }
        }
        // Check diagonals
        if board[0][0] == board[1][1], board[1][1] == board[2][2], !board[0][0].isEmpty {
            return true
        }
        if board[0][2] == board[1][1], board[1][1] == board[2][0], !board[0][2].isEmpty {
            return true
        }
        return false
    }

    // Check for a tie
    func checkTie() -> Bool {
        for row in board {
            if row.contains("") { // Check for any empty cell
                return false
            }
        }
        return true
    }

    // Reset the game
    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3) // Reset to empty strings
        isPlayer1Turn = true
        resultMessage = ""
        gameOver = false
    }
}

#Preview {
    TicTacToeView()
}
