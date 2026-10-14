//
//  IdleRpgAchievementSystem.swift
//  IdleRPGKit
//

public struct IdleRpgAchievementSystem {
    private let model: IdleRpgAchievementCatalog

    public var achievements: [IdleRpgAchievement] { model.catalog }

    public init(achievements model: IdleRpgAchievementCatalog) {
        self.model = model
    }

    public func progress(
        for achievement: IdleRpgAchievement,
        level: Int,
        totalBattlesWon: Int,
        totalItemsCrafted: Int
    ) -> Int {
        switch achievement.objectiveKind {
        case .reachLevel: return level
        case .winBattles: return totalBattlesWon
        case .craftItems: return totalItemsCrafted
        }
    }

    public func isComplete(
        _ achievement: IdleRpgAchievement,
        level: Int,
        totalBattlesWon: Int,
        totalItemsCrafted: Int
    ) -> Bool {
        progress(for: achievement, level: level, totalBattlesWon: totalBattlesWon, totalItemsCrafted: totalItemsCrafted) >= achievement.targetValue
    }
}
