//
//  DefenderNode.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 21/05/23.
//

import SpriteKit

class DefenderNode: SKNode {
    
    private let circle: SKShapeNode = SKShapeNode(circleOfRadius: 18)
    private(set) var type: DefenderType = .horizontal
    var moveable = true
    var isActive: Bool = false {
        willSet {
            circle.strokeColor = newValue ? .black : .clear
            circle.lineWidth = 4
        }
    }
    
    init(spawnPoint: CGPoint, type: DefenderType = .horizontal) {
        super.init()
        self.name = "Defender"
        self.type = type
        self.zPosition = 8.0
        self.position = spawnPoint
        self.setupPhysics()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DefenderNode {
    private func setupPhysics() {
        circle.fillColor = Constants.Colors.primaryRedColor
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 18)
        circle.physicsBody?.isDynamic = false
        circle.physicsBody?.categoryBitMask = PhysicalCategory.Defender
        addChild(circle)
    }
}

extension DefenderNode {
    func move(direction: GamePadDirection) {
        if moveable {
            switch direction {
            case .up:
                let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 0.2)
                // TODO: Send data to another user
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

enum DefenderType {
    case horizontal, vertical
}
