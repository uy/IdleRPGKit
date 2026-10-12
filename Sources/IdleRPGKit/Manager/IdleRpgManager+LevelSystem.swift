//
//  IdleRpgManager+Experience.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 5.07.2025.
//

extension IdleRpgManager {
    public func currentXp() -> Int {
        return gameProgress.character.currentExperience
    }
    
    public func xpToNextLevel() -> Int {
        return levelingSystem.xpToNextLevel(gameProgress.character.level)
    }
    
    public func gainXp(_ amount: Int) {
        var totalExperience = gameProgress.character.currentExperience + amount
        var requiredExperience = xpToNextLevel()

        while totalExperience >= requiredExperience {
            totalExperience -= requiredExperience
            gameProgress.character.level += 1
            levelUp()
            requiredExperience = xpToNextLevel()
        }

        gameProgress.character.currentExperience = totalExperience
    }
    
    private func levelUp() {
        gameProgress.character.freeAttributePoints += levelingSystem.attributePointsPerLevel
    }
}
