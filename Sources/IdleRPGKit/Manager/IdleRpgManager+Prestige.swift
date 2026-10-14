//
//  IdleRpgManager+Prestige.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public func isPrestigeEligible() -> Bool {
        prestigeSystem.isEligible(atLevel: gameProgress.character.level)
    }

    public func prestigeBonus(for attributeKey: String) -> Int {
        prestigeSystem.bonus(forPrestigeCount: gameProgress.character.prestigeCount)
    }

    @discardableResult
    public func prestige() -> Bool {
        guard isPrestigeEligible() else { return false }

        let resetAttributes = baseModel.character.attributes.map { baseAttribute -> IdleRPGCharacterProgressAttributeModel in
            if let startingBonus = gameProgress.character.clas.startingBonusAttributes.first(where: { $0.key == baseAttribute.key }) {
                return .init(key: baseAttribute.key, attribute: baseAttribute.baseScore + startingBonus.bonus)
            }
            return .init(key: baseAttribute.key, attribute: baseAttribute.baseScore)
        }

        gameProgress.character.attributes = resetAttributes
        gameProgress.character.freeAttributePoints = 0
        gameProgress.character.level = 1
        gameProgress.character.currentExperience = 0
        gameProgress.character.ownedItems = []
        gameProgress.character.equippedInstanceIds = [:]
        gameProgress.character.activeAdventureId = nil
        gameProgress.character.adventureStartedAt = nil
        gameProgress.character.totalBattlesWon = 0
        gameProgress.character.claimedQuestIds = []
        gameProgress.character.materialCounts = [:]
        gameProgress.character.currentZoneId = nil
        gameProgress.character.activeCompanionId = nil
        gameProgress.character.factionReputation = [:]
        gameProgress.character.joinedFactionId = nil
        gameProgress.character.totalItemsCrafted = 0
        gameProgress.character.claimedAchievementIds = []
        gameProgress.character.prestigeCount += 1

        givenAttributePoints = []
        saveProgress()
        return true
    }
}
