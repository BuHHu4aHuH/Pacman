//
//  Wall.swift
//  Pacman
//
//  Created by Maksim Shershun on 22.09.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class Wall: SKSpriteNode {
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)

        let rect = SKShapeNode(rectOf: size)
        rect.fillColor = .brown
        let textureBall : SKTexture! = SKTexture(imageNamed:"wall.svg")
        rect.fillTexture = textureBall
        rect.strokeColor = .clear

        addChild(rect)

        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = TypeMask.obstacleCategory
        physicsBody?.collisionBitMask = TypeMask.pacmanCategory
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
