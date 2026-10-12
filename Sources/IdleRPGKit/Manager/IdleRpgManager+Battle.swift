//
//  IdleRpgManager+Battle.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    private func attributeValue(for key: String) -> Int {
        (gameProgress.character.attributes.first(where: { $0.key == key })?.attribute ?? 0) + equipmentBonus(for: key)
    }

    public func fight(_ enemy: IdleRpgEnemy) -> IdleRpgBattleResult {
        let enemyStats = enemySystem.scaledStats(for: enemy, atLevel: gameProgress.character.level)
        let outcome = battleSystem.simulate(
            characterAttackDamage: attributeValue(for: "strength"),
            characterDefense: attributeValue(for: "constitution"),
            characterHealth: battleSystem.characterHealth(forConstitution: attributeValue(for: "constitution")),
            enemyStats: enemyStats,
            inflicts: enemy.inflicts
        )

        guard outcome.won else {
            return IdleRpgBattleResult(enemyId: enemy.id, won: false, rounds: outcome.rounds, earnedXp: 0, droppedItem: nil, inflictedEffectName: outcome.appliedEffectName)
        }

        gainXp(enemyStats.rewardXp)

        var droppedItem: IdleRpgOwnedEquipmentItem?
        if let randomSlot = equipmentSystem.slots.randomElement(),
           generateRandomOwnedItem(for: randomSlot.key) {
            droppedItem = gameProgress.character.ownedItems.last
        }

        saveProgress()

        return IdleRpgBattleResult(enemyId: enemy.id, won: true, rounds: outcome.rounds, earnedXp: enemyStats.rewardXp, droppedItem: droppedItem, inflictedEffectName: outcome.appliedEffectName)
    }
}
