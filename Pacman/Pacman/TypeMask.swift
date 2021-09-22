//
//  TypeMask.swift
//  Pacman
//
//  Created by Maksim Shershun on 22.09.2021.
//

import Foundation

struct TypeMask {
    static let pacmanCategory: UInt32 = 1 << 0
    static let foodCategory: UInt32 = 1 << 1
    static let obstacleCategory: UInt32 = 1 << 2
    static let blinkyCategory: UInt32 = 1 << 3
    static let pinkyCategory: UInt32 = 1 << 4
    static let inkyCategory: UInt32 = 1 << 5
    static let clydeCategory: UInt32 = 1 << 6
}
