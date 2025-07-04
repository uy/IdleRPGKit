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
        var expToNextLevel = xpToNextLevel()
        if amount <= expToNextLevel {
            let newExperience = gameProgress.character.currentExperience + amount
            
            if newExperience >= expToNextLevel {
                gameProgress.character.level += 1
                gameProgress.character.currentExperience = newExperience - expToNextLevel
                levelUp()
            } else {
                gameProgress.character.currentExperience += amount
            }
        } else {
            var expToGive = amount
            
            while expToGive > 0 {
                expToNextLevel = xpToNextLevel()
                
                gameProgress.character.level += 1
                levelUp()
                
                let diff = expToGive - expToNextLevel
                if diff < xpToNextLevel() {
                    gameProgress.character.currentExperience = diff
                    expToGive = 0
                } else {
                    expToGive = diff
                }
            }
        }
    }
    
    private func levelUp() {
        gameProgress.character.freeAttributePoints += levelingSystem.attributePointsPerLevel
    }
}
