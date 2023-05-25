//
//  GameView.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    @State private var showDialogCancellationConfirmation = false
    
    private func getAvailableDirections(_ player: AttackerNode?, _ defender: DefenderNode?) -> [GamePadDirection] {
        if let defender = defender {
            if defender.type == .horizontal {
                return [.left, .right]
            } else {
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
                .padding()
            }
            
            GamePadController(directionAvailables: getAvailableDirections(gameManager.chosenPlayer, gameManager.chosenDefender)) { direction in
                gameManager.movePlayer(direction: direction)
            }
            .padding(.vertical)
            .padding(.bottom)
        }
        .alert("Game Ended!", isPresented: $gameManager.gameFinished) {
            Button("Ok") {
                gameManager.resetGame()
            }
        } message: {
            Text("Congratulation for finishing the game! I guess now you are ready to beat your friend, try multiplayer mode and invite your friend to play together!")
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

struct GameViewController: UIViewRepresentable {
    
    var size: CGSize
    @ObservedObject var gameManager: GameManager
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.showsFPS = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = true
        
        let scene = GameScene(gameManager: gameManager, size: size)
        gameManager.scene = scene
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // TODO: Update UI View
    }
}

struct GameViewiPhone_Previews: PreviewProvider {
    static var gameManager: GameManager {
        let gameManager = GameManager()
        gameManager.gameType = .multiPlayer
        return gameManager
    }
    
    static var previews: some View {
        GameView(gameManager: gameManager)
    }
}

struct GameViewiPad_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameManager: GameManager())
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}

