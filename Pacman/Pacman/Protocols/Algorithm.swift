//
//  Algorithm.swift
//  Pacman
//
//  Created by Maksim Shershun on 28.09.2021.
//

import Foundation

protocol Algorithm {
    var name: String { get }

    func calculatePath(map: [[UInt32]], from: Point, to: Point) -> [Point]
}
