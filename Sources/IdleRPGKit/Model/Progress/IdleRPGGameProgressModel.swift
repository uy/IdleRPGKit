//
//  IdleRPGGameProgressModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

import Combine

public class IdleRPGGameProgressModel: ObservableObject, Codable {
    public var character: IdleRPGCharacterProgressModel
    public var inventoryItems: [IdleRpgInventoryItem]

    enum CodingKeys: CodingKey {
        case character
        case inventoryItems
    }

    public init(
        character: IdleRPGCharacterProgressModel,
        inventoryItems: [IdleRpgInventoryItem]
    ) {
        self.character = character
        self.inventoryItems = inventoryItems
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.character = try container.decode(IdleRPGCharacterProgressModel.self, forKey: .character)
        self.inventoryItems = try container.decode([IdleRpgInventoryItem].self, forKey: .inventoryItems)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(character, forKey: .character)
        try container.encode(inventoryItems, forKey: .inventoryItems)
    }
}
