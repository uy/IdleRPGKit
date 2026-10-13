//
//  IdleRpgSkill.swift
//  IdleRPGKit
//

public struct IdleRpgSkill: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let attributeKey: String
    public let bonusPerLevel: Double
}
