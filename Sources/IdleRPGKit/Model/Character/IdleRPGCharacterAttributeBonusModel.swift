//
//  IdleRPGCharacterAttributeBonusModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

public struct IdleRPGCharacterAttributeBonusModel: Codable, Hashable {
    public let key: String
    public let bonusPerLevelMultiplier: Double
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    public static func == (lhs: IdleRPGCharacterAttributeBonusModel, rhs: IdleRPGCharacterAttributeBonusModel) -> Bool {
        return lhs.key == rhs.key
    }
}
