//
//  PlayerNode.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 21/05/23.
//

import SpriteKit
import SwiftUI

class AttackerNode: SKNode {
    
    var moveable = true
    var spawnPoint: CGPoint!
    var color: UIColor!
    var size: CGFloat!
    var circle: SKShapeNode!
    
    var isActive: Bool = false {
        willSet {
            circle.strokeColor = newValue ? .black : .clear
            circle.lineWidth = 4
        }
    }
    
    init(spawnPoint: CGPoint, color: UIColor, size: CGFloat) {
        super.init()
        self.color = color
        self.size = size
        self.spawnPoint = spawnPoint
        self.circle = SKShapeNode(circleOfRadius: size)
        self.name = "Player"
        self.zPosition = 10.0
        self.position = spawnPoint
        self.setupPhysics()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension AttackerNode {
    private func setupPhysics() {
        circle.fillColor = color
        circle.name = "Player"
        circle.zPosition = .pi
        circle.physicsBody = SKPhysicsBody(circleOfRadius: size)
        circle.physicsBody?.isDynamic = true
        circle.physicsBody?.affectedByGravity = false
        circle.physicsBody?.linearDamping = 0.0
        circle.physicsBody?.allowsRotation = false
        circle.physicsBody?.usesPreciseCollisionDetection = true
//        circle.physicsBody?.friction = 1.0
//        circle.physicsBody?.restitution = 0.0
//        circle.physicsBody?.mass = 10.0
        // circle.physicsBody?.collisionBitMask = 0
        circle.physicsBody?.categoryBitMask = PhysicalCategory.Attacker
        circle.physicsBody?.contactTestBitMask = PhysicalCategory.Defender | PhysicalCategory.FinishField
        circle.physicsBody?.collisionBitMask = PhysicalCategory.Wall
        addChild(circle)
    }
}

extension AttackerNode {
    func move(direction: GamePadDirection) {
        if moveable {
            switch direction {
            case .up:
                let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 0.2)
                circle.run(moveUp)
                break
            case .down:
                let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -20), duration: 0.2)
                circle.run(moveDown)
                break
            case .right:
                let moveRight = SKAction.move(by: CGVector(dx: 20, dy: 0), duration: 0.2)
                circle.run(moveRight)
                break
            case .left:
                let moveLeft = SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 0.2)
                circle.run(moveLeft)
                break
            }
        }
    }
    
    func activateMovement(_ activate: Bool) {
        moveable = activate
    }
}
