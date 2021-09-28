//
//  GameScene.swift
//  Pacman
//
//  Created by Maksim Shershun on 15.09.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var pacman: PacMan!
    private var spinnyNode : SKShapeNode?
    private var gameField: SKShapeNode!
    private var moveAmtX: CGFloat = 0
    private var moveAmtY: CGFloat = 0
    private let minimum_detect_distance: CGFloat = 20
    private var initialTouch: CGPoint = .zero
    private var lastUpdateTime: TimeInterval = 0
    private var score: Int = 0
    private var timeDelta: CGFloat = 0
    private var scoreLabel: SKLabelNode!
    
    let map: Map
    
    override init(size: CGSize) {
        map = Map(map: Map.levelMap1, number: 1, tileSize: CGSize(width: 6, height: 6))
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        pacman = PacMan(size: CGSize(width: 12, height: 12))
        
        gameField = SKShapeNode(rectOf: CGSize(width: map.tileSize.width * CGFloat(map.map[0].count), height: map.tileSize.height * CGFloat(map.map.count)))
        gameField.fillColor = .black
        gameField.strokeColor = .clear
        gameField.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameField)

        scoreLabel = SKLabelNode(text: "Score: \(0)")
        scoreLabel.color = .white
        scoreLabel.position = CGPoint(x: size.width - 100, y: size.height - 235)
        scoreLabel.fontSize = 16
        addChild(scoreLabel)
        
        physicsWorld.contactDelegate = self
        
        for (i, array) in map.map.reversed().enumerated() {
            for (j, element) in array.enumerated() {
                if element == 4 {
                    let wall = Wall(size: map.tileSize)
                    wall.position = .init(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - gameField.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - gameField.frame.height / 2)
                    gameField.addChild(wall)
                } else if element == 2 {
                    let food = Food(radius: 1)
                    food.position = .init(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - gameField.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - gameField.frame.height / 2)
                    gameField.addChild(food)
                } else if element == 1 {
                    pacman.position = .init(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - gameField.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - gameField.frame.height / 2)
                    pacman.animate()
                    gameField.addChild(pacman)
                } else if element == 8 {
                    let ghost = Ghost(type: .gost1, size: map.tileSize)
                    ghost.position = .init(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - gameField.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - gameField.frame.height / 2)
                    ghost.texture = SKTexture(imageNamed:"pacman-2.svg")
                    gameField.addChild(ghost)
                    ghost.move(map: map)
                } else if element == 16 {
                    let ghost = Ghost(type: .gost2, size: map.tileSize)
                    ghost.position = .init(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - gameField.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - gameField.frame.height / 2)
                    ghost.texture = SKTexture(imageNamed:"pacman.svg")
                    gameField.addChild(ghost)
                    ghost.move(map: map)
                } else if element == 32 {
                    let ghost = Ghost(type: .gost3, size: map.tileSize)
                    ghost.position = .init(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - gameField.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - gameField.frame.height / 2)
                    ghost.texture = SKTexture(imageNamed:"pacman-3.svg")
                    gameField.addChild(ghost)
                    ghost.move(map: map)
                } else if element == 64 {
                    let ghost = Ghost(type: .gost4, size: map.tileSize)
                    ghost.position = .init(x: CGFloat(j) * map.tileSize.width + map.tileSize.width / 2 - gameField.frame.width / 2, y: CGFloat(i) * map.tileSize.height + map.tileSize.height / 2 - gameField.frame.height / 2)
                    ghost.texture = SKTexture(imageNamed:"pacman-4.svg")
                    gameField.addChild(ghost)
                    ghost.move(map: map)
                }
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            initialTouch = touch.location(in: self.scene!.view)
            moveAmtY = 0
            moveAmtX = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let movingPoint: CGPoint = touch.location(in: self.scene!.view)
            moveAmtX = movingPoint.x - initialTouch.x
            moveAmtY = movingPoint.y - initialTouch.y
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if abs(moveAmtX) > minimum_detect_distance {
            if moveAmtX < 0 {
                pacman.currentDirection = .left
                pacman.run(SKAction.rotate(toAngle: .pi, duration: 0.02))
            } else {
                pacman.currentDirection = .right
                pacman.run(SKAction.rotate(toAngle: 0, duration: 0.02))
            }
        } else if abs(moveAmtY) > minimum_detect_distance {
            if moveAmtY < 0 {
                pacman.currentDirection = .up
                pacman.run(SKAction.rotate(toAngle: .pi / 2, duration: 0.02))
            } else {
                pacman.currentDirection = .down
                pacman.run(SKAction.rotate(toAngle: -.pi / 2, duration: 0.02))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        timeDelta = lastUpdateTime > 0 ? CGFloat(currentTime - lastUpdateTime) : 0
        lastUpdateTime = currentTime
        
        let previousPosition = pacman.position
        let oldJ = Int(((previousPosition.x + gameField.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
        let oldI = Int(((previousPosition.y + gameField.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven))
        
        let newPosition = pacman.move(direction: pacman.currentDirection, timeDelta: timeDelta)
        let j = Int(((newPosition.x + gameField.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
        let i = Int(((newPosition.y + gameField.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven))
        
        if oldI >= 0 && oldI < map.map.count && oldJ >= 0 && oldI < map.map[0].count {
            map.map[map.map.count - oldI - 1][oldJ] = map.map[map.map.count - oldI - 1][oldJ] & (~(TypeMask.pacmanCategory | TypeMask.foodCategory))
        }
        if i >= 0 && i < map.map.count && j >= 0 && j < map.map[0].count {
            map.map[map.map.count - i - 1][j] = (map.map[map.map.count - oldI - 1][oldJ] | TypeMask.pacmanCategory) & (~TypeMask.foodCategory)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.node?.name == "pacman" && bodyB.node?.name == "food" {
            (bodyA.node as! PacMan).eat(food: bodyB.node as! Food)
            increaseScore(by: 10)
        } else if bodyB.node?.name == "pacman" && bodyA.node?.name == "food" {
            (bodyB.node as! PacMan).eat(food: bodyA.node as! Food)
            increaseScore(by: 10)
        }
        
        if bodyA.node?.name == "pacman" && bodyB.node?.name == "ghost" {
            gameOver()
        } else if bodyA.node?.name == "ghost" && bodyB.node?.name == "pacman" {
            gameOver()
        }
    }
    
    private func increaseScore(by amount: Int) {
        score += amount
        scoreLabel.text = "Score: \(score)"
        if score == 3310 {
            gameOver()
        }
    }
    
    private func gameOver() {
        let gameScene = GameOverScene()
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: .doorsOpenVertical(withDuration: 0.5))
    }
}
