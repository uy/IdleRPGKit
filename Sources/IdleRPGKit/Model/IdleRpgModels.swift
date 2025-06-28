//
//  Models.swift
//  Text-Based-Idle-Game-Demo
//
//  Created by Utku Yeğen on 25.06.2025.
//

import Foundation

public struct IdleRPGBaseModel: Codable {
    public let character: IdleRPGCharacterModel
}

public struct IdleRPGCharacterModel: Codable {
    public let races: [IdleRPGRaceModel]
    public let clases: [IdleRPGClasModel]
    public let attributes: [IdleRPGCharacterAttributeModel]
}

public struct IdleRPGCharacterAttributeModel: Codable, Hashable {
    public let key: String
    public let baseScore: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    public static func == (lhs: IdleRPGCharacterAttributeModel, rhs: IdleRPGCharacterAttributeModel) -> Bool {
        return lhs.key == rhs.key
    }
}

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

public struct IdleRPGClasModel: Codable, Hashable {
    public let key: String
    public let startingBonusAttributes: [IdleRPGClassStartingBonusAttributesModel]
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    public static func == (lhs: IdleRPGClasModel, rhs: IdleRPGClasModel) -> Bool {
        return lhs.key == rhs.key
    }
}

public struct IdleRPGClassStartingBonusAttributesModel: Codable, Hashable {
    public let key: String
    public let bonus: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    public static func == (lhs: IdleRPGClassStartingBonusAttributesModel, rhs: IdleRPGClassStartingBonusAttributesModel) -> Bool {
        return lhs.key == rhs.key
    }
}

public struct IdleRPGGameProgressModel: Codable {
    public let character: IdleRPGCharacterProgressModel
}

public struct IdleRPGCharacterProgressModel: Codable {
    public let race: IdleRPGRaceModel
    public let clas: IdleRPGClasModel
    public let level: Int
}
