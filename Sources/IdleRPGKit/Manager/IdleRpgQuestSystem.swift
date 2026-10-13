//
//  IdleRpgQuestSystem.swift
//  IdleRPGKit
//

public struct IdleRpgQuestSystem {
    private let model: IdleRpgQuestCatalog

    public init(quests model: IdleRpgQuestCatalog) {
        self.model = model
    }

    public var quests: [IdleRpgQuest] { model.catalog }

    public func progress(
        for quest: IdleRpgQuest,
        totalBattlesWon: Int,
        level: Int
    ) -> Int {
        switch quest.objectiveKind {
        case .winBattles: return totalBattlesWon
        case .reachLevel: return level
        }
    }

    public func isComplete(
        _ quest: IdleRpgQuest,
        totalBattlesWon: Int,
        level: Int
    ) -> Bool {
        progress(for: quest, totalBattlesWon: totalBattlesWon, level: level) >= quest.targetValue
    }
}
