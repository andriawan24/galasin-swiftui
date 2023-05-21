//
//  GameView.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            Text("Score")
                .font(.custom(Constants.Fonts.kodchasanBold, size: 32))
            
            GeometryReader { value in
                GameViewController(size: value.size)
                    .padding()
            }
            
            GamePadController { direction in
                print("Direction \(direction)")
            }
            .padding(.vertical)
        }
    }
}

struct GameViewController: UIViewRepresentable {
    
    var size: CGSize
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.showsFPS = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        
        let scene = GameScene(size: size)
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
        GameView()
    }
}

struct GameViewiPad_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}

