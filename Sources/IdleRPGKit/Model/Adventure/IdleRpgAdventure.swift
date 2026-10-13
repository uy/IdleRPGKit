//
//  IdleRpgAdventure.swift
//  IdleRPGKit
//

public struct IdleRpgAdventure: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let durationSeconds: Int
    public let enemyId: String
}
