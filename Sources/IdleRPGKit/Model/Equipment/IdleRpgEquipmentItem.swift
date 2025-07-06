//
//  IdleRpgEquipmentItem.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 6.07.2025.
//


import Foundation

public struct IdleRpgEquipmentItem: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let slotKey: String
    public let rarity: IdleRpgRarity
    public let baseBonuses: [IdleRpgAttributeBonus]
    public let properties: [String: Double]
    public let tags: [String]?

    public init(
        id: String,
        name: String,
        slotKey: String,
        rarity: IdleRpgRarity,
        baseBonuses: [IdleRpgAttributeBonus],
        properties: [String: Double],
        tags: [String]? = nil
    ) {
        self.id = id
        self.name = name
        self.slotKey = slotKey
        self.rarity = rarity
        self.baseBonuses = baseBonuses
        self.properties = properties
        self.tags = tags
    }
}
