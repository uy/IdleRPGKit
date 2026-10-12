//
//  IdleRpgStatusEffect.swift
//  IdleRPGKit
//

public struct IdleRpgStatusEffect: Codable, Hashable {
    public let id: String
    public let name: String
    public let kind: IdleRpgStatusEffectKind
    public let magnitude: Int
    public let durationRounds: Int
}
