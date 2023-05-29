//
//  GameView.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SpriteKit
import SwiftUI

struct GamePage: View {
    @ObservedObject var gameManager: GameManager
    @State private var showDialogCancellationConfirmation = false
    
    private func getAvailableDirections(_ player: AttackerNode?, _ defender: DefenderNode?) -> [GamePadDirection] {
        if let defender = defender {
            if defender.type == .horizontal {
                // MARK: - This is for horizontal defender
                return [.left, .right]
            } else {
                // MARK: - This is for vertical defender
                return [.down, .up]
            }
        } else {
            return [.down, .left, .up, .right]
        }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                if gameManager.gameType == .singlePlayer {
                    Button {
                        showDialogCancellationConfirmation = true
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .scaledToFit()
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.borderless)
                }
                
                VStack {
                    Text("Score")
                        .font(.custom(Constants.Fonts.kodchasanBold, size: 28))
                        .bold()
                    
                    if gameManager.gameType == .singlePlayer {
                        Text("\(gameManager.score)")
                            .font(.custom(Constants.Fonts.poppinsSemibold, size: 24))
                    } else if gameManager.gameType == .multiPlayer {
                        HStack(alignment: .center) {
                            Text(gameManager.localPlayer.displayName)
                                .lineLimit(1)
                            Text("\(gameManager.score)")
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background {
                                    Rectangle()
                                        .cornerRadius(8)
                                        .foregroundColor(Color(gameManager.currentTeam == .red ? Constants.Colors.primaryRedColor : Constants.Colors.primaryBlueColor))
                                }
                            Text("\(gameManager.enemyScore)")
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background {
                                    Rectangle()
                                        .cornerRadius(8)
                                        .foregroundColor(Color(gameManager.currentTeam == .red ? Constants.Colors.primaryBlueColor : Constants.Colors.primaryRedColor))
                                }
                            Text("\(gameManager.otherPlayer?.displayName ?? "")")
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            GeometryReader { value in
                GameViewController(
                    size: value.size,
                    gameManager: gameManager
                )
                .padding(.vertical)
            }
            
            GamePadController(directionAvailables: getAvailableDirections(gameManager.chosenPlayer, gameManager.chosenDefender)) { direction in
                gameManager.movePlayer(direction: direction)
            }
            .padding(.vertical)
            .padding(.bottom)
        }
        .alert(
            gameManager.gameType == .singlePlayer ? "Game Ended!" : gameManager.score > gameManager.enemyScore ? "Match Has Ended!" : "Thank you.",
            isPresented: $gameManager.gameFinished
        ) {
            Button("Ok") {
                gameManager.resetGame()
            }
        } message: {
            if gameManager.gameType == .singlePlayer {
                Text("Congratulation for finishing the game! I guess now you are ready to beat your friend, try multiplayer mode and invite your friend to play together!")
            } else {
                if gameManager.score > gameManager.enemyScore {
                    Text("Congratulations on your victory in this match! You showed great skill, teamwork, and determination with yourself. Well done! Enjoy the sweet taste of success and savor this moment of triumph. Keep up the great work and continue to excel in every challenge that comes your way")
                } else if gameManager.score < gameManager.enemyScore {
                    Text("Although you didn't emerge as the winner in this game, your participation and effort were commendable. Remember that winning isn't the only measure of success. The important thing is that you played with enthusiasm, sportsmanship, and gave it your all. Take this experience as an opportunity to learn and grow. Keep practicing, stay positive, and you'll achieve greatness in future games")
                } else {
                    Text("Wow, what an intense match in this game! It's a tie, showing the incredible talent and determination of both players. You've demonstrated your skill and made the game an unforgettable experience. Great job to both of you!")
                }
            }
        }
        .confirmationDialog(
            "Quit Now?",
            isPresented: $showDialogCancellationConfirmation
        ) {
            Button("Quit", role: .destructive) {
                gameManager.resetGame()
            }
            
            Button("Keep Playing", role: .cancel) {
                showDialogCancellationConfirmation = false
            }
        } message: {
            Text("Do you want to quit the game and return to home page?")
        }
    }
}

struct GameViewiPhone_Previews: PreviewProvider {
    static var gameManager: GameManager {
        let gameManager = GameManager()
        gameManager.gameType = .multiPlayer
        return gameManager
    }
    
    static var previews: some View {
        GamePage(gameManager: gameManager)
    }
}

struct GameViewiPad_Previews: PreviewProvider {
    static var previews: some View {
        GamePage(gameManager: GameManager())
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}

