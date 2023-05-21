//
//  PlayerNode.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 21/05/23.
//

import SpriteKit
import SwiftUI

class AttackerNode: SKNode {
    
    private let circle: SKShapeNode = SKShapeNode(circleOfRadius: 15)
    
    init(spawnPoint: CGPoint) {
        super.init()
        self.name = "Players"
        self.zPosition = 2
        self.position = spawnPoint
        self.setupPhysics()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension AttackerNode {
    private func setupPhysics() {
        circle.fillColor = Constants.Colors.primaryBlueColor
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        circle.physicsBody?.isDynamic = false
        addChild(circle)
    }
}
