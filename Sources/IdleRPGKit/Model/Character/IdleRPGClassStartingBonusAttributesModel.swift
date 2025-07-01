//
//  IdleRPGClassStartingBonusAttributesModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//


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
