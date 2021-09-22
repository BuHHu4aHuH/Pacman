//
//  Ghost.swift
//  Pacman
//
//  Created by Maksim Shershun on 22.09.2021.
//

import Foundation
import SpriteKit

class Ghost: SKSpriteNode {
    enum GhostType: UInt32 {
        case blinky = 8
        case pinky = 16
        case inky = 32
        case clyde = 64
    }

    private let type: GhostType

    init(type: GhostType, size: CGSize) {
        self.type = type
        super.init(texture: SKTexture(imageNamed: "ghost"), color: .clear, size: size)

        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false

        switch type {
        case .blinky:
            physicsBody?.categoryBitMask = TypeMask.blinkyCategory
        case .pinky:
            physicsBody?.categoryBitMask = TypeMask.pinkyCategory
        case .inky:
            physicsBody?.categoryBitMask = TypeMask.inkyCategory
        case .clyde:
            physicsBody?.categoryBitMask = TypeMask.clydeCategory
        }

        physicsBody?.collisionBitMask = TypeMask.obstacleCategory
        physicsBody?.contactTestBitMask = TypeMask.pacmanCategory

        name = "ghost"
    }

    func move(map: Map) {
        let randomDirection = Direction(rawValue: Int.random(in: 0...3))!

        let oldJ = Int(((position.x + parent!.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
        let oldI = Int(((position.y + parent!.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven))

        map.map[map.map.count - oldI - 1][oldJ] = (map.map[map.map.count - oldI - 1][oldJ] & (~type.rawValue))

        var i: Int = 0
        var j: Int = 0

        var isOk = true

        if randomDirection == .up {
            if oldI < map.map.count - 1 {
                i = oldI + 1
                j = oldJ
            } else {
                isOk = false
            }
        } else if randomDirection == .down {
            if oldI > 0 {
                i = oldI - 1
                j = oldJ
            } else {
                isOk = false
            }
        } else if randomDirection == .left {
            if oldJ > 0 {
                i = oldI
                j = oldJ - 1
            } else {
                isOk = false
            }
        } else if randomDirection == .right {
            if oldJ < map.map[0].count - 1 {
                i = oldI
                j = oldJ + 1
            } else {
                isOk = false
            }
        }

        guard isOk && (map.map[map.map.count - i - 1][j] & TypeMask.obstacleCategory == 0) else {
            move(map: map)
            return
        }

        map.map[map.map.count - i - 1][j] = map.map[map.map.count - i - 1][j] | type.rawValue

        let newPosition = CGPoint(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - parent!.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - parent!.frame.height / 2)

        run(SKAction.sequence([
            SKAction.move(to: newPosition, duration: 0.5),
            SKAction.run { [weak self] in
                self?.move(map: map)
            }
        ]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
