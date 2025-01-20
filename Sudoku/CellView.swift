//
//  CellView.swift
//  Sudoku
//
//  Created by Grace She on 2025-01-14.
//

import SwiftUI

struct CellView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) { // prints the 3x3 grids in a thicker border
                ForEach(0..<3, id: \.self) {row in
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) {col in
                            Rectangle()
                                .foregroundColor(Color.black.opacity(0.0))
                                .border(Color.black, width: 2)
                                .frame(width: 117, height: 117)
                        }
                    }
                }
            }
            
            // prints the thick border around the entire board
            Rectangle()
                .frame(width: 365, height: 365)
                .foregroundColor(Color.black.opacity(0.0))
                .border(Color.black, width: 8)
        }
    }
    
}
#Preview {
    CellView()
}
