//
//  Map.swift
//  Pacman
//
//  Created by Maksim Shershun on 22.09.2021.
//

import Foundation
import UIKit

class Map: Equatable {
    static func == (lhs: Map, rhs: Map) -> Bool {
        lhs.number == rhs.number
    }

    var map: [[UInt32]]
    let number: Int
    let tileSize: CGSize

    init(map: [[UInt32]], number: Int, tileSize: CGSize) {
        self.map = map
        self.number = number
        self.tileSize = tileSize
    }

    static func generateMap() -> [[UInt32]] {
        var map = Array(repeating: [UInt32](repeating: 4, count: 28), count: 30)
        let i = Int.random(in: 1..<29)
        let j = Int.random(in: 1..<27)

        map[i][j] = 2
        var walls = [Point]()
        walls += getNeighbors(map: map, point: Point(i: i, j: j)).filter({ map[$0.i][$0.j] & TypeMask.obstacleCategory != 0 })

        while !walls.isEmpty {
            let currentWall = walls.randomElement()!
            if getNeighbors(map: map, point: currentWall).filter({ map[$0.i][$0.j] & TypeMask.obstacleCategory == 0 }).count == 1 {
                map[currentWall.i][currentWall.j] = 2
                walls += getNeighbors(map: map, point: currentWall).filter({ map[$0.i][$0.j] & TypeMask.obstacleCategory != 0 })
            }
            walls.remove(at: walls.firstIndex(of: currentWall)!)
        }

        var wallsToDelete = 50

        while wallsToDelete > 0 {
            let i = Int.random(in: 1 ..< 29)
            let j = Int.random(in: 1 ..< 27)
            if map[i][j] & TypeMask.obstacleCategory != 0 && getNeighbors(map: map, point: Point(i: i, j: j)).filter({ map[$0.i][$0.j] & TypeMask.obstacleCategory == 0 }).count >= 1 {
                map[i][j] = 2
                wallsToDelete -= 1
            }
        }

        var pacmanI = 0
        var pacmanJ = 0

        while map[pacmanI][pacmanJ] & TypeMask.obstacleCategory != 0 {
            pacmanI = Int.random(in: 0..<30)
            pacmanJ = Int.random(in: 0..<28)
        }

        map[pacmanI][pacmanJ] = 1

        [TypeMask.gost1Category, TypeMask.gost2Category, TypeMask.gost3Category, TypeMask.gost4Category].forEach { ghostCategory in
            var ghostI = 0
            var ghostJ = 0

            while (map[ghostI][ghostJ] & TypeMask.obstacleCategory != 0) || (map[ghostI][ghostJ] & TypeMask.pacmanCategory != 0) {
                ghostI = Int.random(in: 0..<30)
                ghostJ = Int.random(in: 0..<28)
            }

            map[ghostI][ghostJ] = TypeMask.foodCategory | ghostCategory
        }

        return map
    }

    static func getNeighbors(map: [[UInt32]], point: Point) -> [Point] {
        var neighbors = [Point]()
        let i = point.i
        let j = point.j
        if i > 1 {
            neighbors.append(Point(i: i-1, j: j))
        }
        if j > 1 {
            neighbors.append(Point(i: i, j: j-1))
        }
        if i < map.count - 2 {
            neighbors.append(Point(i: i+1, j: j))
        }
        if j < map[0].count - 2 {
            neighbors.append(Point(i: i, j: j+1))
        }
        return neighbors
    }
}
