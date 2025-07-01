//
//  IdleRPGCharacterAttributeModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

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
