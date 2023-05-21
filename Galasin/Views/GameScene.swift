//
//  GameScene.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    // Field Layout
    var topFieldSquare: SKShapeNode!
    var centerFieldSquare: SKShapeNode!
    var bottomFieldSquare: SKShapeNode!
    
    // Field Lines
    var bottomLines: SKShapeNode!
    var bottomMiddleLines: SKShapeNode!
    var centerVerticalLines: SKShapeNode!
    var topMiddleLines: SKShapeNode!
    var topLines: SKShapeNode!
    
    // Attackers
    var attacker1: AttackerNode!
    var attacker2: AttackerNode!
    var attacker3: AttackerNode!
    var attacker4: AttackerNode!
    var attacker5: AttackerNode!
    
    // Defenders
    var defender1: DefenderNode!
    var defender2: DefenderNode!
    var defender3: DefenderNode!
    var defender4: DefenderNode!
    var defender5: DefenderNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .systemBackground
        setupNodes()
    }
}

extension GameScene {
    private func setupNodes() {
        
        // MARK: - Center Field
        let centerFieldSize = CGSize(width: frame.width - 20, height: frame.height - 300)
        centerFieldSquare = SKShapeNode(rectOf: centerFieldSize, cornerRadius: 8)
        centerFieldSquare.strokeColor = .black
        centerFieldSquare.zPosition = 2
        centerFieldSquare.lineWidth = 4
        centerFieldSquare.position = CGPoint(x: frame.midX, y: frame.midY)
        centerFieldSquare.physicsBody = SKPhysicsBody(rectangleOf: centerFieldSize)
        centerFieldSquare.physicsBody?.isDynamic = false
        addChild(centerFieldSquare)
        
        // MARK: - Bottom Field
        let bottomFieldSize = CGSize(width: frame.width - 20, height: 100)
        bottomFieldSquare = SKShapeNode(rectOf: bottomFieldSize)
        bottomFieldSquare.strokeColor = .red
        bottomFieldSquare.zPosition = 2
        bottomFieldSquare.lineWidth = 2
        bottomFieldSquare.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        bottomFieldSquare.physicsBody = SKPhysicsBody(rectangleOf: bottomFieldSize)
        bottomFieldSquare.physicsBody?.isDynamic = false
        addChild(bottomFieldSquare)
        
        // MARK: - Top Field
        let topFieldSize = CGSize(width: frame.width - 20, height: 100)
        topFieldSquare = SKShapeNode(rectOf: topFieldSize)
        topFieldSquare.strokeColor = .red
        topFieldSquare.zPosition = 1
        topFieldSquare.lineWidth = 2
        topFieldSquare.position = CGPoint(x: frame.midX, y: frame.maxY - 50)
        topFieldSquare.physicsBody = SKPhysicsBody(rectangleOf: bottomFieldSize)
        topFieldSquare.physicsBody?.isDynamic = false
        addChild(topFieldSquare)
        
        // MARK: - Add Lines
        var path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.minX, y: centerFieldSquare.frame.maxY))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.maxX, y: centerFieldSquare.frame.maxY))
        topLines = SKShapeNode(path: path)
        // topLines.strokeColor = .blue
        topLines.zPosition = 1
        addChild(topLines)
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.minX, y: centerFieldSquare.frame.maxY * 3/4))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.maxX, y: centerFieldSquare.frame.maxY  * 3/4))
        topMiddleLines = SKShapeNode(path: path)
        topMiddleLines.strokeColor = .black
        topMiddleLines.zPosition = 1
        topMiddleLines.lineWidth = 4
        addChild(topMiddleLines)
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.minX, y: centerFieldSquare.frame.maxY * 2/4))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.maxX, y: centerFieldSquare.frame.maxY  * 2/4))
        bottomMiddleLines = SKShapeNode(path: path)
        bottomMiddleLines.strokeColor = .black
        bottomMiddleLines.lineWidth = 4
        addChild(bottomMiddleLines)
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.minX, y: centerFieldSquare.frame.minY))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.maxX, y: centerFieldSquare.frame.minY))
        bottomLines = SKShapeNode(path: path)
        // bottomLines.strokeColor = .blue
        addChild(bottomLines)
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.midX, y: centerFieldSquare.frame.minY))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.midX, y: centerFieldSquare.frame.maxY))
        centerVerticalLines = SKShapeNode(path: path)
        centerVerticalLines.strokeColor = .black
        centerVerticalLines.lineWidth = 4
        addChild(centerVerticalLines)
        
        // MARK: - Add Players
        let attacker1 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX - 120, y: frame.minY + 50))
        let attacker2 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX - 60, y: frame.minY + 50))
        let attacker3 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX, y: frame.minY + 50))
        let attacker4 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX + 60, y: frame.minY + 50))
        let attacker5 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX + 120, y: frame.minY + 50))
        addChild(attacker1)
        addChild(attacker2)
        addChild(attacker3)
        addChild(attacker4)
        addChild(attacker5)
        
        // MARK: - Add Defenders
        let defender1 = DefenderNode(spawnPoint: CGPoint(x: topLines.frame.midX / 2, y: topLines.frame.midY))
        let defender2 = DefenderNode(spawnPoint: CGPoint(x: topMiddleLines.frame.midX + (topMiddleLines.frame.midX/2), y: topMiddleLines.frame.midY))
        let defender3 = DefenderNode(spawnPoint: CGPoint(x: bottomMiddleLines.frame.midX / 2, y: bottomMiddleLines.frame.midY))
        let defender4 = DefenderNode(spawnPoint: CGPoint(x: bottomLines.frame.midX + (bottomLines.frame.midX/2), y: bottomLines.frame.midY))
        addChild(defender1)
        addChild(defender2)
        addChild(defender3)
        addChild(defender4)
    }
}
