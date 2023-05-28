//
//  HomeView.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 24/05/23.
//

import SwiftUI

struct HomePage: View {
    @ObservedObject var gameManager: GameManager
    @State private var showDetailDialog = true
    
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
                    playHaptic()
                    gameManager.startGame(type: .multiPlayer)
                } label: {
                    Text("Multi Player")
                        .font(.custom("Kodchasan-SemiBold", size: 18))
                        .foregroundColor(.primary)
                }
                .buttonStyle(.bordered)
                .disabled(gameManager.authStatus != .authenticated)

                Button {
                    playHaptic()
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
                playHaptic()
                showDetailDialog.toggle()
            } label: {
                Label("How to play?", systemImage: "questionmark.circle")
                    .font(.custom("Kodchasan-SemiBold", size: 16))
                    .foregroundColor(.primary)
                    .padding(.top, 100)
                    .padding([.horizontal, .bottom])
            }.buttonStyle(.borderless)
                .sheet(isPresented: $showDetailDialog) {
                    ScrollView {
                        VStack(alignment: .center) {
                            Text("How to play?")
                                .font(.custom(Constants.Fonts.poppinsSemibold, size: 24))
                            
                            HStack {
                                Text("Players")
                                    .font(.custom(Constants.Fonts.poppinsSemibold, size: 16))
                                Spacer()
                            }
                            
                            HStack {
                                Text("The game can be played by 2 players, but more players can join to make it more exciting")
                                    .font(.custom(Constants.Fonts.poppins, size: 14))
                                Spacer()
                            }
                            
                            HStack {
                                Text("Game Objective")
                                    .font(.custom(Constants.Fonts.poppinsSemibold, size: 16))
                                Spacer()
                            }
                            .padding(.top)
                            
                            HStack {
                                Text("The objective of Gobak Sodor is for the attacking team to successfully cross from one end of the playing area to the other, while the defending team tries to prevent them from doing so")
                                    .font(.custom(Constants.Fonts.poppins, size: 14))
                                Spacer()
                            }
                            
                            HStack {
                                Text("Teams")
                                    .font(.custom(Constants.Fonts.poppinsSemibold, size: 16))
                                Spacer()
                            }
                            .padding(.top)
                            
                            HStack {
                                Text("Divide the players into two teams: the attacking team and the defending team. The attacking team will attempt to cross the playing area, while the defending team will try to tag the attacking players to eliminate them")
                                    .font(.custom(Constants.Fonts.poppins, size: 14))
                                Spacer()
                            }
                            
                            HStack {
                                Text("Winning")
                                    .font(.custom(Constants.Fonts.poppinsSemibold, size: 16))
                                Spacer()
                            }
                            .padding(.top)
                            
                            HStack {
                                Text("The attacking team wins if they successfully cross the playing area without being tagged by the defending team. The defending team wins if they tag all the attacking players before they can cross")
                                    .font(.custom(Constants.Fonts.poppins, size: 14))
                                Spacer()
                            }
                        }
                        .padding()
                        .padding(.top)
                    }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
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
