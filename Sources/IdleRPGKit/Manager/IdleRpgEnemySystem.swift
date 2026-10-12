//
//  IdleRpgEnemySystem.swift
//  IdleRPGKit
//

public struct IdleRpgEnemySystem {
    private let model: IdleRpgEnemyCatalog

    public var enemies: [IdleRpgEnemy] { model.catalog }

    public init(enemies model: IdleRpgEnemyCatalog) {
        self.model = model
    }

    public func scaledStats(
        for enemy: IdleRpgEnemy,
        atLevel targetLevel: Int
    ) -> IdleRpgEnemyStats {
        let levelDelta = max(0, targetLevel - enemy.level)
        let multiplier = 1.0 + (Double(levelDelta) * model.scaling.statGrowthPerLevel)

        return IdleRpgEnemyStats(
            health: Int((Double(enemy.baseHealth) * multiplier).rounded()),
            attackDamage: Int((Double(enemy.baseAttackDamage) * multiplier).rounded()),
            defense: Int((Double(enemy.baseDefense) * multiplier).rounded()),
            rewardXp: Int((Double(enemy.rewardXp) * multiplier).rounded())
        )
    }
}
