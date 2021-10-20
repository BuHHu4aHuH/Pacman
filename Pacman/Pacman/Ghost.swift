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
        case gost1 = 8
        case gost2 = 16
        case gost3 = 32
        case gost4 = 64
    }

    private let type: GhostType

    init(type: GhostType, size: CGSize) {
        self.type = type
        super.init(texture: SKTexture(imageNamed: "ghost"), color: .clear, size: size)

        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false

        switch type {
        case .gost1:
            physicsBody?.categoryBitMask = TypeMask.gost1Category
        case .gost2:
            physicsBody?.categoryBitMask = TypeMask.gost2Category
        case .gost3:
            physicsBody?.categoryBitMask = TypeMask.gost3Category
        case .gost4:
            physicsBody?.categoryBitMask = TypeMask.gost4Category
        }

        physicsBody?.collisionBitMask = TypeMask.obstacleCategory
        physicsBody?.contactTestBitMask = TypeMask.pacmanCategory

        name = "ghost"
    }

    func move(map: Map, to: Point) {
        let oldJ = Int(((position.x + parent!.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
        let oldI = Int(((position.y + parent!.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven))

        map.map[map.map.count - oldI - 1][oldJ] = (map.map[map.map.count - oldI - 1][oldJ] & (~type.rawValue))

        let path = UCS().calculatePath(map: map.map, from: Point(i: map.map.count - oldI - 1, j: oldJ), to: to)
        guard let point = path.first else { return }
        let i = map.map.count - point.i - 1
        let j = point.j

        map.map[map.map.count - i - 1][j] = map.map[map.map.count - i - 1][j] | type.rawValue

        let newPosition = CGPoint(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - parent!.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - parent!.frame.height / 2)

        run(SKAction.move(to: newPosition, duration: 0.5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
