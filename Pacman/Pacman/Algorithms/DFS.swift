//
//  DFS.swift
//  Pacman
//
//  Created by Maksim Shershun on 28.09.2021.
//

import Foundation

class DFS: Algorithm {
    let name: String = "DFS"

    func calculatePath(map: [[UInt32]], from: Point, to: Point) -> [Point] {
        var points = [Point]()

        var path = [Point: Point]()

        var stack = [Point]()
        var visited = Set<Point>()

        stack.append(from)

        while !stack.isEmpty {
            let top = stack.removeFirst()
            visited.insert(top)
            if top == to {
                break
            }
            let neighbors = Map.getNeighbors(map: map, point: top)
            neighbors.forEach({
                if !visited.contains($0) && map[$0.i][$0.j] & TypeMask.obstacleCategory == 0 {
                    path[$0] = top
                    stack.insert($0, at: 0)
                }
            })
        }

        var currentPoint = to
        while path[currentPoint] != nil {
            points.append(currentPoint)
            currentPoint = path[currentPoint]!
        }

        points.append(currentPoint)

        return points
    }
}
