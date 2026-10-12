//
//  IdleRpgEnemy.swift
//  IdleRPGKit
//

public struct IdleRpgEnemy: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let level: Int
    public let baseHealth: Int
    public let baseAttackDamage: Int
    public let baseDefense: Int
    public let rewardXp: Int
}
