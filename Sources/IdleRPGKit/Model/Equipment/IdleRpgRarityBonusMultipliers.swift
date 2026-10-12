//
//  IdleRpgRarityBonusMultipliers.swift
//  IdleRPGKit
//

public struct IdleRpgRarityBonusMultipliers: Codable, Sendable {
    public let common: IdleRpgRarityBonusMultiplierRange
    public let uncommon: IdleRpgRarityBonusMultiplierRange
    public let rare: IdleRpgRarityBonusMultiplierRange
    public let epic: IdleRpgRarityBonusMultiplierRange
    public let legendary: IdleRpgRarityBonusMultiplierRange

    public init(
        common: IdleRpgRarityBonusMultiplierRange,
        uncommon: IdleRpgRarityBonusMultiplierRange,
        rare: IdleRpgRarityBonusMultiplierRange,
        epic: IdleRpgRarityBonusMultiplierRange,
        legendary: IdleRpgRarityBonusMultiplierRange
    ) {
        self.common = common
        self.uncommon = uncommon
        self.rare = rare
        self.epic = epic
        self.legendary = legendary
    }

    public func range(for rarity: IdleRpgRarity) -> IdleRpgRarityBonusMultiplierRange {
        switch rarity {
        case .common: return common
        case .uncommon: return uncommon
        case .rare: return rare
        case .epic: return epic
        case .legendary: return legendary
        }
    }

    public static let defaultMultipliers = IdleRpgRarityBonusMultipliers(
        common: .init(min: 0.9, max: 1.1),
        uncommon: .init(min: 1.1, max: 1.3),
        rare: .init(min: 1.3, max: 1.6),
        epic: .init(min: 1.6, max: 2.0),
        legendary: .init(min: 2.0, max: 2.5)
    )
}
