//
//  GameOverScene.swift
//  Pacman
//
//  Created by Maksim Shershun on 22.09.2021.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {

    private let startNode = SKSpriteNode()

    override func didMove(to view: SKView) {
        let rect = SKShapeNode(rectOf: .init(width: 200, height: 100))
        rect.strokeColor = .clear
        startNode.addChild(rect)

        let labelNode = SKLabelNode(text: "Game over!")
        labelNode.color = .white
        labelNode.verticalAlignmentMode = .center
        labelNode.fontName = "AvenirNext-Bold"
        startNode.addChild(labelNode)

        startNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(startNode)
    }
}

