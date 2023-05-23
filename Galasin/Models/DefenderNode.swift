//
//  DefenderNode.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 21/05/23.
//

import SpriteKit

class DefenderNode: SKNode {
    
    private let circle: SKShapeNode = SKShapeNode(circleOfRadius: 18)
    
    init(spawnPoint: CGPoint) {
        super.init()
        self.name = "Player"
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
