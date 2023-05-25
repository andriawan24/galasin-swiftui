//
//  HomeView.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 24/05/23.
//

import SwiftUI

struct HomePage: View {
    @ObservedObject var gameManager: GameManager
    @State private var showDetailDialog = false
    
    var body: some View {
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
                    gameManager.startGame(type: .multiPlayer)
                } label: {
                    Text("Multi Player")
                        .font(.custom("Kodchasan-SemiBold", size: 18))
                        .foregroundColor(.primary)
                }
                .buttonStyle(.bordered)
                .disabled(gameManager.authStatus != .authenticated)

                Button {
                    gameManager.startGame(type: .singlePlayer)
                } label: {
                    Text("Single Player")
                        .font(.custom("Kodchasan-SemiBold", size: 18))
                        .foregroundColor(.primary)
                }
                .buttonStyle(.bordered)
                .disabled(gameManager.authStatus != .authenticated)
            }.padding()
            
            Spacer()
            
            Text("\(gameManager.authStatus.rawValue)")
            
            Button {
                showDetailDialog.toggle()
            } label: {
                Label("How to play?", systemImage: "questionmark.circle")
                    .font(.custom("Kodchasan-SemiBold", size: 16))
                    .foregroundColor(.primary)
                    .padding(.top, 100)
                    .padding([.horizontal, .bottom])
            }.buttonStyle(.borderless)
                .sheet(isPresented: $showDetailDialog) {
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

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        var gameManager: GameManager {
            let gameManager = GameManager()
            gameManager.authStatus = .authenticated
            return gameManager
        }
        
        HomePage(gameManager: gameManager)
    }
}

struct HomePageIpad_Previews: PreviewProvider {
    static var previews: some View {
        var gameManager: GameManager {
            let gameManager = GameManager()
            gameManager.authStatus = .authenticated
            return gameManager
        }
        
        HomePage(gameManager: gameManager)
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}
