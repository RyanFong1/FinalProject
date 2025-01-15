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
            VStack(spacing: 0) {
                ForEach(0..<3, id: \.self) {row in
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) {col in
                            Rectangle()
                                .foregroundColor(Color.black.opacity(0.0))
                                .border(Color.black, width: 2)
                                .frame(width: 120, height: 120)
                        }
                    }
                }
            }
            
            Rectangle()
                .frame(width: 369, height: 369)
                .foregroundColor(Color.black.opacity(0.0))
                .border(Color.black, width: 8)
        }
    }
    
}
#Preview {
    CellView()
}
