//
//  ContentView.swift
//  AppSelector
//
//  Created by Ryan Fong on 2025-01-14.
//

import SwiftUI

struct ContentView: View {
    let items = ["item1", "item2", "item3", "item4"]
    let info: [(String, String)] = [("Tic Tac Toe", "Keegan Tjoa"), ("Connect 4", "Hayden Chau"), ("Sudoku", "Grace She"), ("Road Rage", "Ryan Fong")]
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome")
                    .font(.largeTitle.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.top, 80)
                Spacer()
            }
            
            TabView {
                TabView(selection: $currentIndex) {
                    ForEach(items.indices, id: \.self) { index in
                        Image(items[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .padding(.bottom, 40)
            
            VStack {
                Spacer()
                Button(action: {
                    print("pressed")
                }) {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 320, height: 80)
                            .cornerRadius(30)
                        
                        HStack {
                            HStack {
                                Image(systemName: "play")
                                    .foregroundColor(.black)
                                
                                Text(info[currentIndex].0)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .scaleEffect(0.9)
                                    .padding(.leading, 5)
                            }
                            .padding(.leading, 30)
                            
                            Spacer()
                            
                            Text(info[currentIndex].1)
                                .font(.body)
                                .foregroundColor(.black)
                                .scaleEffect(0.8)
                                .padding(.trailing, 20)
                        }
                        .frame(width: 320, height: 80)
                    }
                }
                .padding(.bottom, 103)
            }
        }
    }
}

#Preview {
    ContentView()
}
