//
//  PhysicalCategory.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 22/05/23.
//

import SpriteKit

struct PhysicalCategory {
    static let Attacker: UInt32 = 0b1 // 2^0
    static let Defender: UInt32 = 0b10 // 2^1
    static let FinishField: UInt32 = 0b100 // 2^2
}
