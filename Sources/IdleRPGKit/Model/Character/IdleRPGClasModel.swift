//
//  IdleRPGClasModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

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
