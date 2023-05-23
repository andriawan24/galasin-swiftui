//
//  ContentView.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameManager: GameManager
    @State private var showDialog = false
    
    var body: some View {
        if gameManager.inGame {
            GameView(gameManager: gameManager)
        } else {
            VStack {
                Text("Galasin")
                    .font(.custom("Kodchasan-Bold", size: 40))
                    .padding(.top)
                    .padding(.horizontal)
                
                // TODO: Add image for night mode
                Image("imageHome")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.9)
                    .padding(.horizontal)
                    .padding(.vertical)
                
                Text("Choose Mode!")
                    .font(.custom("Kodchasan-Bold", size: 40))
                    .padding(.top)
                    .padding(.horizontal)
                
                HStack(spacing: 40) {
                    Button {
                        // TODO: Play Multiplayer
                    } label: {
                        Text("Multi Player")
                            .font(.custom("Kodchasan-SemiBold", size: 22))
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.borderless)

                    Button {
                        // TODO: Play Single Player
                        gameManager.startGame(type: .singlePlayer)
                    } label: {
                        Text("Single Player")
                            .font(.custom("Kodchasan-SemiBold", size: 22))
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                
                Spacer()
                
                Button {
                    // TODO: Show dialog opening rules
                    showDialog.toggle()
                } label: {
                    Label("How to play?", systemImage: "questionmark.circle")
                        .font(.custom("Kodchasan-SemiBold", size: 16))
                        .foregroundColor(.primary)
                        .padding(.top, 100)
                        .padding([.horizontal, .bottom])
                }
                .buttonStyle(.borderless)
                .sheet(isPresented: $showDialog) {
                    VStack {
                        // TODO: Add Information about the game
                        Text("This is Sheet")
                        Text("This could be explanation for the app")
                    }
                }

            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ContentViewIPhone_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameManager: GameManager())
    }
}

struct ContentViewIPhoneDark_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameManager: GameManager())
            .preferredColorScheme(.dark)
    }
}

struct ContentViewIPad_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameManager: GameManager())
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}
