//
//  UCS.swift
//  Pacman
//
//  Created by Maksim Shershun on 28.09.2021.
//

import Foundation

class UCS: Algorithm {
    var name: String = "UCS"

    struct Node: Comparable {
        var point: Point
        var cost: Int

        static func < (lhs: UCS.Node, rhs: UCS.Node) -> Bool {
            lhs.cost < rhs.cost
        }
    }

    func calculatePath(map: [[UInt32]], pacmanPosition: Point, ghostPosition: Point) -> [Point] {
        var points = [Point]()

        var path = [Point: Point]()

        var queue = PriorityQueue<Node>(order: { $0.cost > $1.cost })
        queue.push(Node(point: pacmanPosition, cost: 0))
        var visited = Set<Point>()

        while !queue.isEmpty {
            let node = queue.pop()!

            if node.point == ghostPosition {
                break
            }

            if !visited.contains(node.point) {
                let neighbors = Map.getNeighbors(map: map, point: node.point)
                neighbors.forEach { point in
                    if !visited.contains(point) && map[point.i][point.j] & TypeMask.obstacleCategory == 0 {
                        path[point] = node.point
                        queue.push(Node(point: point, cost: node.cost + 1))
                    }
                }
            }

            visited.insert(node.point)
        }

        var currentPoint = ghostPosition
        while path[currentPoint] != nil {
            points.append(currentPoint)
            currentPoint = path[currentPoint]!
        }

        points.append(currentPoint)

        return points
    }
}
