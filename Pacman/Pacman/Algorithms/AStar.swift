//
//  AStar.swift
//  Pacman
//
//  Created by Maksim Shershun on 20.10.2021.
//

import Foundation

class AStar: Algorithm {
    var name: String = "A*"

    struct Node: Comparable {
        var point: Point
        var g: Int
        var h: Int
        var f: Int {
            g + h
        }

        static func < (lhs: AStar.Node, rhs: AStar.Node) -> Bool {
            lhs.f < rhs.f
        }
    }

    func dist(_ x: Point, _ y: Point) -> Int {
        abs(x.i - y.i) + abs(x.j - y.j)
    }

    func calculatePath(map: [[UInt32]], from: Point, to: Point) -> [Point] {
        var points = [Point]()

        var path = [Point: Point]()

        var queue = PriorityQueue<Node>(order: { $0.f > $1.f })
        queue.push(Node(point: from, g: 0, h: dist(from, to)))

        var visited = Set<Point>()

        while !queue.isEmpty {
            let currentNode = queue.pop()!
            visited.insert(currentNode.point)
            if currentNode.point == to {
                break
            }

            Map.getNeighbors(map: map, point: currentNode.point).forEach { neighbor in
                guard map[neighbor.i][neighbor.j] & TypeMask.obstacleCategory == 0 else { return }
                let score = currentNode.g + 1
                if let neighborNode = queue.first(where: { $0.point == neighbor }) {
                    if score < neighborNode.g {
                        path[neighbor] = currentNode.point
                        var newNode = neighborNode
                        newNode.g = score
                        queue.remove(neighborNode)
                        queue.push(newNode)
                    }
                } else if !visited.contains(neighbor) {
                    path[neighbor] = currentNode.point
                    queue.push(Node(point: neighbor, g: score, h: dist(neighbor, to)))
                }
            }
        }

        var currentPoint = to
        while path[currentPoint] != nil {
            points.append(currentPoint)
            currentPoint = path[currentPoint]!
        }

        return points.reversed()
    }
}
