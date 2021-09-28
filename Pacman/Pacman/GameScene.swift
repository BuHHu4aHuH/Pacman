//
//  GameScene.swift
//  Pacman
//
//  Created by Maksim Shershun on 15.09.2021.
//

import SpriteKit
import GameplayKit

struct Point: Hashable, Equatable {
    let i: Int
    let j: Int
}

class GameScene: SKScene {

    private var pacman: PacMan!
    private var gameField: SKShapeNode!
    private var scoreLabel: SKLabelNode!
    private var changeAlgorithmLabel: SKLabelNode!
    private var searchLabel: SKLabelNode!
    private var score: Int

    private var algoLabel: SKLabelNode!
    private var timeLabel: SKLabelNode!

    private var lastUpdateTime: TimeInterval = 0
    private var dt: CGFloat = 0
    private var allDt: CGFloat = 0

    private var moveAmtX: CGFloat = 0
    private var moveAmtY: CGFloat = 0
    private let minimum_detect_distance: CGFloat = 50
    private var initialTouch: CGPoint = .zero

    let map: Map

    private var isSearching: Bool = false
    private let algorithms: [Algorithm] = [DFS(), BFS(), UCS()]
    private var currentAlgorithmIndex = 2

    init(size: CGSize, map: Map, score: Int = 0) {
        self.map = map
        self.score = score
        super.init(size: size)
    }

    override func didMove(to view: SKView) {
        pacman = PacMan(size: CGSize(width: 20, height: 20))

        gameField = SKShapeNode(rectOf: CGSize(width: 45, height: 15))
        gameField.fillColor = .black
        gameField.strokeColor = .clear
        gameField.position = CGPoint(x: 40, y: 100)
        addChild(gameField)

        scoreLabel = SKLabelNode(text: "Score: \(0)")
        scoreLabel.color = .white
        scoreLabel.position = CGPoint(x: 200, y: size.height - 40)
        scoreLabel.fontSize = 16
        addChild(scoreLabel)

        algoLabel = SKLabelNode(text: "\(algorithms[currentAlgorithmIndex].name)")
        algoLabel.color = .white
        algoLabel.position = CGPoint(x: 50, y: size.height - 40)
        algoLabel.fontSize = 16
        addChild(algoLabel)

        timeLabel = SKLabelNode(text: "\(allDt)")
        timeLabel.color = .white
        timeLabel.position = CGPoint(x: 100, y: size.height - 40)
        timeLabel.fontSize = 13
        addChild(timeLabel)

        changeAlgorithmLabel = SKLabelNode(text: "Change algorithm")
        changeAlgorithmLabel.name = "change_algorithm"
        changeAlgorithmLabel.color = .white
        changeAlgorithmLabel.fontName = "AvenirNext-Bold"
        changeAlgorithmLabel.fontSize = 17
        changeAlgorithmLabel.position = CGPoint(x: 200, y: 20)
        addChild(changeAlgorithmLabel)

        searchLabel = SKLabelNode(text: "Search")
        searchLabel.name = "search"
        searchLabel.color = .white
        searchLabel.fontName = "AvenirNext-Bold"
        searchLabel.fontSize = 17
        searchLabel.position = CGPoint(x: 80, y: 20)
        addChild(searchLabel)

        let swipeUpGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSwipeFrom))
        self.view!.addGestureRecognizer(swipeUpGestureRecognizer)

        physicsWorld.contactDelegate = self

        for (i, array) in map.map.reversed().enumerated() {
            for (j, element) in array.enumerated() {
                if element & TypeMask.obstacleCategory != 0 {
                    let obstacle = Wall(size: CGSize(width: 10, height: 10))
                    obstacle.position = .init(x: CGFloat(j) * 10 + 10 / 2 - gameField.frame.width / 2,
                                              y: CGFloat(i) * 10 + 10 / 2 - gameField.frame.height / 2)
                    gameField.addChild(obstacle)
                }

                if element & TypeMask.foodCategory != 0 {
                    let food = Food(radius: 1)
                    food.position = .init(x: CGFloat(j) * 10 + 10 / 2 - gameField.frame.width / 2,
                                          y: CGFloat(i) * 10 + 10 / 2 - gameField.frame.height / 2)
                    gameField.addChild(food)
                }

                if element & TypeMask.pacmanCategory != 0 {
                    pacman.position = .init(x: CGFloat(j) * 10 + 10 / 2 - gameField.frame.width / 2,
                                            y: CGFloat(i) * 10 + 10 / 2 - gameField.frame.height / 2)
                    pacman.zPosition = 1
                    pacman.animate()
                    gameField.addChild(pacman)
                }

                if element & TypeMask.gost1Category != 0 {
                    let ghost = Ghost(type: .gost1, size: CGSize(width: 10, height: 10))
                    ghost.position = .init(x: CGFloat(j) * 10 + 10 / 2 - gameField.frame.width / 2,
                                           y: CGFloat(i) * 10 + 10 / 2 - gameField.frame.height / 2)
                    gameField.addChild(ghost)
                    ghost.texture = SKTexture(imageNamed:"pacman-2.svg")
                    ghost.zPosition = 1
                    ghost.move(map: map)
                }

                if element & TypeMask.gost2Category != 0 {
                    let ghost = Ghost(type: .gost2, size: CGSize(width: 10, height: 10))
                    ghost.position = .init(x: CGFloat(j) * 10 + map.tileSize.width / 2 - gameField.frame.width / 2,
                                           y: CGFloat(i) * 10 + map.tileSize.height / 2 - gameField.frame.height / 2)
                    gameField.addChild(ghost)
                    ghost.texture = SKTexture(imageNamed:"pacman.svg")
                    ghost.zPosition = 1
                    ghost.move(map: map)
                }

                if element & TypeMask.gost3Category != 0 {
                    let ghost = Ghost(type: .gost3, size: CGSize(width: 10, height: 10))
                    ghost.position = .init(x: CGFloat(j) * 10 + 10 / 2 - gameField.frame.width / 2,
                                           y: CGFloat(i) * 10 + 10 / 2 - gameField.frame.height / 2)
                    gameField.addChild(ghost)
                    ghost.texture = SKTexture(imageNamed:"pacman-3.svg")
                    ghost.zPosition = 1
                    ghost.move(map: map)
                }

                if element & TypeMask.gost4Category != 0 {
                    let ghost = Ghost(type: .gost4, size: CGSize(width: 10, height: 10))
                    ghost.position = .init(x: CGFloat(j) * 10 + 10 / 2 - gameField.frame.width / 2,
                                           y: CGFloat(i) * 10 + 10 / 2 - gameField.frame.height / 2)
                    gameField.addChild(ghost)
                    ghost.texture = SKTexture(imageNamed:"pacman-4.svg")
                    ghost.zPosition = 1
                    ghost.move(map: map)
                }
            }
        }
    }

    @objc func handleSwipeFrom(_ recognizer: UITapGestureRecognizer) {
        let touchInView = recognizer.location(in: recognizer.view)
        let touch = convertPoint(fromView: touchInView)
        let nodeArray = nodes(at: touch)
        for node in nodeArray {
            if node.name == "change_algorithm" {
                guard isSearching else { return }
                currentAlgorithmIndex += 1
                if currentAlgorithmIndex >= algorithms.count {
                    currentAlgorithmIndex = 0
                }
                algoLabel.text = "\(algorithms[currentAlgorithmIndex].name)"
                search()
            } else if node.name == "search" {
                if isSearching {
                    gameField.children.filter({ $0.name == "path" }).forEach({ $0.removeFromParent() })
                    isSearching = false
                    pacman.isPaused = isSearching
                    gameField.children.filter({ $0.name == "ghost" }).forEach({ $0.isPaused = isSearching })
                    currentAlgorithmIndex = 0
                } else {
                    search()
                }
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = CGFloat(currentTime - lastUpdateTime)
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        allDt += dt

        guard !isSearching, allDt > 1 else { return }

        let previousPosition = pacman.position
        let oldJ = Int(((previousPosition.x + gameField.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
        let oldI = Int(((previousPosition.y + gameField.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven))

        let newPosition = pacman.move(direction: pacman.currentDirection, timeDelta: dt)
        let j = Int(((newPosition.x + gameField.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
        let i = Int(((newPosition.y + gameField.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven))

        if oldI >= 0 && oldI < map.map.count && oldJ >= 0 && oldI < map.map[0].count {
            map.map[map.map.count - oldI - 1][oldJ] = map.map[map.map.count - oldI - 1][oldJ] & (~(TypeMask.pacmanCategory | TypeMask.foodCategory))
        }
        if i >= 0 && i < map.map.count && j >= 0 && j < map.map[0].count {
            map.map[map.map.count - i - 1][j] = (map.map[map.map.count - oldI - 1][oldJ] | TypeMask.pacmanCategory) & (~TypeMask.foodCategory)
        }

        checkWin()
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func search() {
        gameField.children.filter({ $0.name == "path" }).forEach({ $0.removeFromParent() })
        isSearching = true
        pacman.isPaused = isSearching
        gameField.children.filter({ $0.name == "ghost" }).forEach({ $0.isPaused = isSearching })
        guard isSearching else { return }

        let pacmanJ = Int(((pacman.position.x + gameField.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
        let pacmanI = map.map.count - Int(((pacman.position.y + gameField.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven)) - 1

        var ghostsPoints = [Point]()

        gameField.children.filter({ $0.name == "ghost" }).forEach({
            let ghostJ = Int((($0.position.x + gameField.frame.width / 2 - map.tileSize.width / 2) / map.tileSize.width).rounded(.toNearestOrEven))
            let ghostI = map.map.count - Int((($0.position.y + gameField.frame.height / 2 - map.tileSize.height / 2) / map.tileSize.height).rounded(.toNearestOrEven)) - 1
            ghostsPoints.append(Point(i: ghostI, j: ghostJ))
        })

        var allTime: CFAbsoluteTime = 0

        ghostsPoints.forEach { point in
            let timer = ParkBenchTimer()
            let path = algorithms[currentAlgorithmIndex].calculatePath(map: map.map, pacmanPosition: Point(i: pacmanI, j: pacmanJ), ghostPosition: point)
            allTime += timer.stop()

            path.forEach { point in
                let node = SKSpriteNode(color: .blue, size: .init(width: 10, height: 10))
                node.position = .init(x: CGFloat(point.j) * map.tileSize.width + map.tileSize.width / 2 - gameField.frame.width / 2, y: CGFloat(map.map.count - point.i - 1) * map.tileSize.height + map.tileSize.height / 2 - gameField.frame.height / 2)
                node.zPosition = 0
                node.name = "path"
                gameField.addChild(node)
            }
        }

        timeLabel.text = String(format: "%.2fms", allTime * 1000)
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
    }

    private func checkWin() {
        if !map.map.contains(where: { $0.contains(where: { $0 & TypeMask.foodCategory != 0 }) }) {
            let nextmap = Map(map: Map.generateMap(), number: map.number + 1, tileSize: .init(width: 20, height: 20))
            let gameScene = GameScene(size: size, map: nextmap, score: score)
            gameScene.scaleMode = .aspectFill
            view?.presentScene(gameScene, transition: .fade(withDuration: 0.5))
        }
    }

    private func gameOver() {
        let highScore = UserDefaults.standard.integer(forKey: "highScore")

        if score > highScore {
            UserDefaults.standard.setValue(score, forKey: "highScore")
        }

        let scene = GameOverScene(size: size)
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: .fade(withDuration: 0.5))
    }
}

class ParkBenchTimer {
    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?

    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()

        return duration!
    }

    var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
