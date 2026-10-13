//
//  IdleRpgCompanion.swift
//  IdleRPGKit
//

public struct IdleRpgCompanion: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let unlockLevel: Int
    public let passiveBonuses: [IdleRpgAttributeBonus]
}
