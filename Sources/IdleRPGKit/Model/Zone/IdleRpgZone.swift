//
//  IdleRpgZone.swift
//  IdleRPGKit
//

public struct IdleRpgZone: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let requiredLevel: Int
    public let enemyIds: [String]
}
