//
//  BoardView.swift
//  Sudoku
//
//  Created by Grace She on 2025-01-14.
//

//import SwiftUI
//
//struct BoardView: View {
//    
//    var board = Board()
////    @State var sudokuCell: SudokuCell
//
////    private var cellState = board.generateBoolBoard()
//    
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
//                ForEach(0..<9, id: \.self) {row in
//                    HStack(spacing: 0) {
//                        ForEach(0..<9, id: \.self) {col in
//                            CellChanges(sudokuCell: board.generateBoolBoard()[row][col])
//                            Rectangle()
//                                .fill(.white)
//                                .border(.black)
//                                .frame(width: 40, height: 40)
////                                .onTapGesture {
////                                    .fill(board.generateBoolBoard()[row][col] ? .blue : .white)
////                                }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//


//#Preview {
//    BoardView()
//}

//import SwiftUI

//struct BoardView: View {
//    
//    @State var board = Board() // Use @State to store the board
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
//                ForEach(0..<9, id: \.self) { row in
//                    HStack(spacing: 0) {
//                        ForEach(0..<9, id: \.self) { col in
//                            // Create a binding for each sudoku cell
//                            CellChanges(sudokuCell: $board.generateBoolBoard()[row][col])
//                            Rectangle()
//                                .fill(.white)
//                                .border(.black)
//                                .frame(width: 40, height: 40)
//                        }
//                    }
//                }
//            }
//        }
//    }
////}
//
//#Preview {
//    BoardView()
//}
