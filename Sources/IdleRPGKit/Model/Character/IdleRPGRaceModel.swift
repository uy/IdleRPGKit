//
//  IdleRPGRaceModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

public struct IdleRPGRaceModel: Codable, Hashable {
    public let key: String
    public let experienceBonus: Double
    public let attributeBonus: [IdleRPGCharacterAttributeBonusModel]
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    public static func == (lhs: IdleRPGRaceModel, rhs: IdleRPGRaceModel) -> Bool {
        return lhs.key == rhs.key
    }
}
