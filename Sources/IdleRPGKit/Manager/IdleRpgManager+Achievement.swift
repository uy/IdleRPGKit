//
//  IdleRpgManager+Achievement.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public func achievementProgress(for achievement: IdleRpgAchievement) -> Int {
        achievementSystem.progress(
            for: achievement,
            level: gameProgress.character.level,
            totalBattlesWon: gameProgress.character.totalBattlesWon,
            totalItemsCrafted: gameProgress.character.totalItemsCrafted
        )
    }

    public func isAchievementComplete(_ achievement: IdleRpgAchievement) -> Bool {
        achievementSystem.isComplete(
            achievement,
            level: gameProgress.character.level,
            totalBattlesWon: gameProgress.character.totalBattlesWon,
            totalItemsCrafted: gameProgress.character.totalItemsCrafted
        )
    }

    public func isAchievementClaimed(_ achievement: IdleRpgAchievement) -> Bool {
        gameProgress.character.claimedAchievementIds.contains(achievement.id)
    }

    @discardableResult
    public func claimAchievement(_ achievement: IdleRpgAchievement) -> Int? {
        guard isAchievementComplete(achievement), !isAchievementClaimed(achievement) else { return nil }
        gameProgress.character.claimedAchievementIds.append(achievement.id)
        gameProgress.character.freeAttributePoints += achievement.rewardAttributePoints
        saveProgress()
        return achievement.rewardAttributePoints
    }
}
