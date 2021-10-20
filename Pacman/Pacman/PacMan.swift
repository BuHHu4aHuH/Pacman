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
    private let currentSpeed: CGFloat = 10

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
        physicsBody?.contactTestBitMask = TypeMask.foodCategory | TypeMask.gost1Category | TypeMask.gost3Category | TypeMask.gost4Category

        name = "pacman"
    }

    func animate() {
        topSemicircle.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(toAngle: .pi / 3, duration: 0.3), SKAction.rotate(toAngle: .pi / 8, duration: 0.3)])))
        bottomSemicircle.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(toAngle: 2 * .pi / 3, duration: 0.3), SKAction.rotate(toAngle: 7 * .pi / 8, duration: 0.3)])))
    }

    func move(map: Map, to: Point) {
        let oldJ = Int(((position.x + parent!.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
        let oldI = Int(((position.y + parent!.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven))

        map.map[map.map.count - oldI - 1][oldJ] = map.map[map.map.count - oldI - 1][oldJ] & (~(TypeMask.pacmanCategory | TypeMask.foodCategory))

        let path = AStar().calculatePath(map: map.map, from: Point(i: map.map.count - oldI - 1, j: oldJ), to: to)
        guard let point = path.first else { return }
        let i = map.map.count - point.i - 1
        let j = point.j

        if oldI > i && currentDirection != .down {
            currentDirection = .down
            run(SKAction.rotate(toAngle: -.pi / 2, duration: 0.2))
        } else if oldI < i && currentDirection != .up {
            currentDirection = .up
            run(SKAction.rotate(toAngle: .pi / 2, duration: 0.2))
        } else if oldJ > j && currentDirection != .left {
            currentDirection = .left
            run(SKAction.rotate(toAngle: .pi, duration: 0.2))
        } else if oldJ < j && currentDirection != .right {
            currentDirection = .right
            run(SKAction.rotate(toAngle: 0, duration: 0.2))
        }

        map.map[map.map.count - i - 1][j] = map.map[map.map.count - i - 1][j] | (TypeMask.pacmanCategory & ~TypeMask.foodCategory)

        let newPosition = CGPoint(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - parent!.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - parent!.frame.height / 2)

        run(SKAction.move(to: newPosition, duration: 0.5))
    }

    func eat(food: Food) {
        food.run(SKAction.removeFromParent())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
