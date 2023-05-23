//
//  GameScene.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene {
    var gameManager: GameManager? = nil
    
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
    
    init(gameManager: GameManager, size: CGSize) {
        super.init(size: size)
        self.gameManager = gameManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .systemBackground
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let playerNode = nodes(at: touch.location(in: self)).filter({ node in
            return node.name == "Player"
        }).last else { return }
        
        if let player = playerNode as? AttackerNode {
            attacker1.isActive = false
            attacker2.isActive = false
            attacker3.isActive = false
            attacker4.isActive = false
            attacker5.isActive = false
            
            player.isActive.toggle()
            gameManager?.choosePlayer(player: player)
        }
    }
}

extension GameScene {
    private func setupNodes() {
        // MARK: - Center Field
        let centerFieldSize = CGSize(width: frame.width - 20, height: frame.height - 250)
        centerFieldSquare = SKShapeNode(rectOf: centerFieldSize, cornerRadius: 8)
        centerFieldSquare.strokeColor = .black
        centerFieldSquare.zPosition = -1
        centerFieldSquare.lineWidth = 3
        centerFieldSquare.position = CGPoint(x: frame.midX, y: frame.midY)
        centerFieldSquare.physicsBody = SKPhysicsBody(rectangleOf: centerFieldSize)
        centerFieldSquare.physicsBody?.isDynamic = false
        addChild(centerFieldSquare)
        
        // MARK: - Bottom Field
        let bottomFieldSize = CGSize(width: frame.width - 20, height: 100)
        bottomFieldSquare = SKShapeNode(rectOf: bottomFieldSize)
        bottomFieldSquare.strokeColor = .red
        bottomFieldSquare.zPosition = -1
        bottomFieldSquare.lineWidth = 2
        bottomFieldSquare.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        bottomFieldSquare.physicsBody = SKPhysicsBody(rectangleOf: bottomFieldSize)
        bottomFieldSquare.physicsBody?.isDynamic = false
        bottomFieldSquare.physicsBody?.usesPreciseCollisionDetection = false
        addChild(bottomFieldSquare)
        
        // MARK: - Top Field
        let topFieldSize = CGSize(width: frame.width - 20, height: 100)
        topFieldSquare = SKShapeNode(rectOf: topFieldSize)
        topFieldSquare.strokeColor = .red
        topFieldSquare.zPosition = -1
        topFieldSquare.lineWidth = 2
        topFieldSquare.position = CGPoint(x: frame.midX, y: frame.maxY - 50)
        topFieldSquare.physicsBody = SKPhysicsBody(rectangleOf: bottomFieldSize)
        topFieldSquare.physicsBody?.isDynamic = false
        topFieldSquare.physicsBody?.affectedByGravity = false
        topFieldSquare.physicsBody?.categoryBitMask = PhysicalCategory.FinishField
        topFieldSquare.physicsBody?.mass = 100.0
//        topFieldSquare.physicsBody?.restitution = 0.0
//        topFieldSquare.physicsBody?.friction = 1.0
        addChild(topFieldSquare)
        
        // MARK: - Add Lines
        var path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.minX, y: centerFieldSquare.frame.maxY))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.maxX, y: centerFieldSquare.frame.maxY))
        topLines = SKShapeNode(path: path)
        topLines.zPosition = -1
        addChild(topLines)
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.minX, y: centerFieldSquare.frame.maxY * 3/4))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.maxX, y: centerFieldSquare.frame.maxY  * 3/4))
        topMiddleLines = SKShapeNode(path: path)
        topMiddleLines.strokeColor = .black
        topMiddleLines.zPosition = -1
        topMiddleLines.lineWidth = 3
        addChild(topMiddleLines)
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.minX, y: centerFieldSquare.frame.maxY * 2/4))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.maxX, y: centerFieldSquare.frame.maxY  * 2/4))
        bottomMiddleLines = SKShapeNode(path: path)
        bottomMiddleLines.strokeColor = .black
        bottomMiddleLines.zPosition = -1
        bottomMiddleLines.lineWidth = 3
        addChild(bottomMiddleLines)
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.minX, y: centerFieldSquare.frame.minY))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.maxX, y: centerFieldSquare.frame.minY))
        bottomLines = SKShapeNode(path: path)
        bottomLines.zPosition = -1
        addChild(bottomLines)
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: centerFieldSquare.frame.midX, y: centerFieldSquare.frame.minY))
        path.addLine(to: CGPoint(x: centerFieldSquare.frame.midX, y: centerFieldSquare.frame.maxY))
        centerVerticalLines = SKShapeNode(path: path)
        centerVerticalLines.strokeColor = .black
        centerVerticalLines.lineWidth = 3
        centerVerticalLines.zPosition = -1
        addChild(centerVerticalLines)
        
        // MARK: - Add Attackers
        attacker1 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX - 120, y: frame.minY + 50))
        attacker2 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX - 60, y: frame.minY + 50))
        attacker3 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX, y: frame.minY + 50))
        attacker4 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX + 60, y: frame.minY + 50))
        attacker5 = AttackerNode(spawnPoint: CGPoint(x: bottomFieldSquare.frame.midX + 120, y: frame.minY + 50))
        addChild(attacker1)
        addChild(attacker2)
        addChild(attacker3)
        addChild(attacker4)
        addChild(attacker5)
        
        // MARK: - Add Defenders
        defender1 = DefenderNode(spawnPoint: CGPoint(x: topLines.frame.midX / 2, y: topLines.frame.midY))
        defender2 = DefenderNode(spawnPoint: CGPoint(x: topMiddleLines.frame.midX + (topMiddleLines.frame.midX/2), y: topMiddleLines.frame.midY))
        defender3 = DefenderNode(spawnPoint: CGPoint(x: bottomMiddleLines.frame.midX / 2, y: bottomMiddleLines.frame.midY))
        defender4 = DefenderNode(spawnPoint: CGPoint(x: bottomLines.frame.midX + (bottomLines.frame.midX/2), y: bottomLines.frame.midY))
        defender5 = DefenderNode(spawnPoint: CGPoint(x: centerVerticalLines.frame.midX, y: centerVerticalLines.frame.midY))
        addChild(defender1)
        addChild(defender2)
        addChild(defender3)
        addChild(defender4)
        addChild(defender5)
        
        let moveDelay = SKAction.wait(forDuration: 1.0)
        
        let moveToLeftAction = SKAction.move(to: CGPoint(x: topLines.frame.minX, y: defender1.position.y), duration: 2.2)
        let moveToRightAction = SKAction.move(to: CGPoint(x: topLines.frame.maxX, y: defender1.position.y), duration: 2.3)
        let sequence = SKAction.sequence([moveToLeftAction, moveToRightAction])
        let sequenceForever = SKAction.repeatForever(sequence)
        defender1.run(sequenceForever)
        
        let moveToLeftAction2 = SKAction.move(to: CGPoint(x: topMiddleLines.frame.minX, y: defender2.position.y), duration: 2.0)
        let moveToRightAction2 = SKAction.move(to: CGPoint(x: topMiddleLines.frame.maxX, y: defender2.position.y), duration: 2.0)
        let sequence2 = SKAction.sequence([moveDelay, moveToLeftAction2, moveToRightAction2])
        let sequenceForever2 = SKAction.repeatForever(sequence2)
        defender2.run(sequenceForever2)
        
        let moveToLeftAction4 = SKAction.move(to: CGPoint(x: bottomLines.frame.minX, y: defender4.position.y), duration: 1.8)
        let moveToRightAction4 = SKAction.move(to: CGPoint(x: bottomLines.frame.maxX, y: defender4.position.y), duration: 1.8)
        let sequence4 = SKAction.sequence([moveToRightAction4, moveDelay, moveToLeftAction4])
        let sequenceForever4 = SKAction.repeatForever(sequence4)
        defender4.run(sequenceForever4)
        
        let moveToLeftAction3 = SKAction.move(to: CGPoint(x: bottomMiddleLines.frame.minX, y: defender3.position.y), duration: 2.0)
        let moveToRightAction3 = SKAction.move(to: CGPoint(x: bottomMiddleLines.frame.maxX, y: defender3.position.y), duration: 2.0)
        let sequence3 = SKAction.sequence([moveToRightAction3, moveToLeftAction3, moveDelay])
        let sequenceForever3 = SKAction.repeatForever(sequence3)
        defender3.run(sequenceForever3)
        
        let moveToLeftAction5 = SKAction.move(to: CGPoint(x: centerVerticalLines.frame.midX, y: centerVerticalLines.frame.minY), duration: 2.0)
        let moveToRightAction5 = SKAction.move(to: CGPoint(x: centerVerticalLines.frame.midX, y: centerVerticalLines.frame.maxY), duration: 2.0)
        let sequence5 = SKAction.sequence([moveToRightAction5, moveToLeftAction5, moveDelay])
        let sequenceForever5 = SKAction.repeatForever(sequence5)
        defender5.run(sequenceForever5)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let body = contact.bodyA.categoryBitMask == PhysicalCategory.Attacker ? contact.bodyB : contact.bodyA
        let player = contact.bodyA.categoryBitMask == PhysicalCategory.Attacker ? contact.bodyA : contact.bodyB
        
        switch body.categoryBitMask {
        case PhysicalCategory.Defender:
            player.node?.removeFromParent()
            gameManager?.reducePlayer()
        case PhysicalCategory.FinishField:
            player.node?.removeFromParent()
            gameManager?.increaseScore()
        default:
            break
        }
    }
}
