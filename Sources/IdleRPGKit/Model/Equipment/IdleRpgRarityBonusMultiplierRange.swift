//
//  IdleRpgRarityBonusMultiplierRange.swift
//  IdleRPGKit
//

public struct IdleRpgRarityBonusMultiplierRange: Codable, Sendable {
    public let min: Double
    public let max: Double

    public init(min: Double, max: Double) {
        self.min = min
        self.max = max
    }
}
