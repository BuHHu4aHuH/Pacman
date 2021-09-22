//
//  Food.swift
//  Pacman
//
//  Created by Maksim Shershun on 22.09.2021.
//

import SpriteKit
import GameplayKit

class Food: SKSpriteNode {
    init(radius: CGFloat) {
        super.init(texture: nil, color: .clear, size: CGSize(width: radius * 2, height: radius * 2))

        let cirlce = SKShapeNode(circleOfRadius: radius)
        cirlce.fillColor = .yellow
        cirlce.strokeColor = .clear
        addChild(cirlce)

        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = TypeMask.foodCategory
        physicsBody?.contactTestBitMask = TypeMask.pacmanCategory

        name = "food"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
