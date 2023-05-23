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
    
    var body: some View {
        VStack {
            Text("Score")
                .font(.custom(Constants.Fonts.kodchasanBold, size: 28))
                .bold()
            
            if gameManager.gameType == .singlePlayer {
                Text("\(gameManager.score)")
                    .font(.custom(Constants.Fonts.poppinsSemibold, size: 24))
            } else if gameManager.gameType == .multiPlayer {
                
            }
            
            //            HStack {
            //                Text("Naufal Fawwaz Andriw")
            //            }
            
            GeometryReader { value in
                GameViewController(
                    size: value.size,
                    gameManager: gameManager
                )
                .padding()
            }
            
            GamePadController { direction in
                gameManager.moveAttacker(direction: direction)
            }
            .padding(.vertical)
            .padding(.bottom)
        }
        .alert("Congratulations!", isPresented: $gameManager.gameFinished) {
            Button("Ok") {
                gameManager.resetGame()
            }
        } message: {
            Text("You finished the game, and now you're ready to beat your friend, try multiplayer now")
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
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // TODO: Update UI View
    }
}

struct GameViewiPhone_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameManager: GameManager())
    }
}

struct GameViewiPad_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameManager: GameManager())
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}

