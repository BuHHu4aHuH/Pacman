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
        rect.fillColor = .red
        rect.strokeColor = .clear
        startNode.addChild(rect)

        let labelNode = SKLabelNode(text: "Start")
        labelNode.color = .white
        labelNode.verticalAlignmentMode = .center
        labelNode.fontName = "AvenirNext-Bold"
        startNode.addChild(labelNode)

        let highScoreLabelNode = SKLabelNode(text: "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))")
        highScoreLabelNode.color = .white
        highScoreLabelNode.verticalAlignmentMode = .center
        highScoreLabelNode.fontName = "AvenirNext-Bold"
        highScoreLabelNode.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        highScoreLabelNode.fontSize = 20
        addChild(highScoreLabelNode)

        startNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(startNode)

        run(SKAction.repeatForever(SKAction.playSoundFileNamed("pacman_beginning", waitForCompletion: true)))
    }
}

