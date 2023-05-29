//
//  GameViewController.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 29/05/23.
//

import SwiftUI
import SpriteKit

struct GameViewController: UIViewRepresentable {
    
    var size: CGSize
    @ObservedObject var gameManager: GameManager
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.showsFPS = false
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = false
        
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
