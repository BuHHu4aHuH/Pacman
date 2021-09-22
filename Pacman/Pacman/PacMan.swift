//
//  PacMan.swift
//  Pacman
//
//  Created by Maksim Shershun on 22.09.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class PacMan: SKSpriteNode {

    private var topSemicircle: SKShapeNode!
    private var bottomSemicircle: SKShapeNode!

    var currentDirection: Direction = .right
    private let currentSpeed: CGFloat = 15

    let chompActionSound: SKAction = {
        return SKAction.playSoundFileNamed("pacman_chomp", waitForCompletion: false)
    }()

    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)

        self.size = size
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: size.width / 4, startAngle: 0, endAngle: .pi, clockwise: false)
        topSemicircle = SKShapeNode(path: path)
        topSemicircle.fillColor = .yellow
        topSemicircle.zRotation = .pi / 8
        topSemicircle.strokeColor = .clear
        bottomSemicircle = SKShapeNode(path: path)
        bottomSemicircle.fillColor = .yellow
        bottomSemicircle.zRotation = 7 * .pi / 8
        bottomSemicircle.strokeColor = .clear
        self.addChild(topSemicircle)
        self.addChild(bottomSemicircle)

        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 4)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = TypeMask.pacmanCategory
        physicsBody?.collisionBitMask = TypeMask.obstacleCategory
        physicsBody?.contactTestBitMask = TypeMask.foodCategory | TypeMask.blinkyCategory | TypeMask.inkyCategory | TypeMask.clydeCategory

        name = "pacman"
    }

    func animate() {
        topSemicircle.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(toAngle: .pi / 3, duration: 0.3), SKAction.rotate(toAngle: .pi / 8, duration: 0.3)])))
        bottomSemicircle.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(toAngle: 2 * .pi / 3, duration: 0.3), SKAction.rotate(toAngle: 7 * .pi / 8, duration: 0.3)])))
    }

    func move(direction: Direction, timeDelta delta: CGFloat) -> CGPoint {
        var velocity: CGVector

        switch direction {
        case .right:
            velocity = .init(dx: 5, dy: 0)
        case .left:
            velocity = .init(dx: -5, dy: 0)
        case .up:
            velocity = .init(dx: 0, dy: 5)
        case .down:
            velocity = .init(dx: 0, dy: -5)
        }

        position.x += velocity.dx * delta * currentSpeed
        position.y += velocity.dy * delta * currentSpeed

        return position
    }

    func eat(food: Food) {
        food.run(SKAction.removeFromParent())
        run(chompActionSound)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
