//
//  IdleRPGCharacterProgressAttributeModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 3.07.2025.
//

public struct IdleRPGCharacterProgressAttributeModel: Codable, Hashable {
    public let key: String
    public let attribute: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    public static func == (lhs: IdleRPGCharacterProgressAttributeModel, rhs: IdleRPGCharacterProgressAttributeModel) -> Bool {
        return lhs.key == rhs.key
    }
}
