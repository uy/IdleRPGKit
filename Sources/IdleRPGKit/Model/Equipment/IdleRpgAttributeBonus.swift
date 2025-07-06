//
//  IdleRpgAttributeBonus.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 6.07.2025.
//


import Foundation

public struct IdleRpgAttributeBonus: Codable, Hashable {
    public let attributeKey: String
    public let bonus: Int

    public init(attributeKey: String, bonus: Int) {
        self.attributeKey = attributeKey
        self.bonus = bonus
    }
}
