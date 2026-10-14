//
//  IdleRpgFaction.swift
//  IdleRPGKit
//

public struct IdleRpgFaction: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let rivalFactionId: String?
}
