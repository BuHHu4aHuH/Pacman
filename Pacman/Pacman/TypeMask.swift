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
    static let gost1Category: UInt32 = 1 << 3
    static let gost2Category: UInt32 = 1 << 4
    static let gost3Category: UInt32 = 1 << 5
    static let gost4Category: UInt32 = 1 << 6
}
