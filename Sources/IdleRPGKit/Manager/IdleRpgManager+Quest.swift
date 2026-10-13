//
//  IdleRpgManager+Quest.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public func questProgress(for quest: IdleRpgQuest) -> Int {
        questSystem.progress(
            for: quest,
            totalBattlesWon: gameProgress.character.totalBattlesWon,
            level: gameProgress.character.level
        )
    }

    public func isQuestComplete(_ quest: IdleRpgQuest) -> Bool {
        questSystem.isComplete(
            quest,
            totalBattlesWon: gameProgress.character.totalBattlesWon,
            level: gameProgress.character.level
        )
    }

    public func isQuestClaimed(_ quest: IdleRpgQuest) -> Bool {
        gameProgress.character.claimedQuestIds.contains(quest.id)
    }

    @discardableResult
    public func claimQuest(_ quest: IdleRpgQuest) -> Int? {
        guard isQuestComplete(quest), !isQuestClaimed(quest) else { return nil }
        gameProgress.character.claimedQuestIds.append(quest.id)
        gainXp(quest.rewardXp)
        saveProgress()
        return quest.rewardXp
    }
}
