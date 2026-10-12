//
//  IdleRpgBattleSystem.swift
//  IdleRPGKit
//

public struct IdleRpgBattleSystem {
    private let model: IdleRPGBattleFormulaModel

    public init(battle model: IdleRPGBattleFormulaModel) {
        self.model = model
    }

    public func characterHealth(forConstitution constitution: Int) -> Int {
        Int((Double(constitution) * model.healthPerConstitutionPoint).rounded())
    }

    public func simulate(
        characterAttackDamage: Int,
        characterDefense: Int,
        characterHealth: Int,
        enemyStats: IdleRpgEnemyStats
    ) -> (won: Bool, rounds: Int) {
        var characterHP = characterHealth
        var enemyHP = enemyStats.health
        var rounds = 0
        let characterDamagePerRound = max(1, characterAttackDamage - enemyStats.defense)
        let enemyDamagePerRound = max(1, enemyStats.attackDamage - characterDefense)

        while characterHP > 0 && enemyHP > 0 {
            rounds += 1
            enemyHP -= characterDamagePerRound
            if enemyHP <= 0 { break }
            characterHP -= enemyDamagePerRound
        }

        return (won: enemyHP <= 0, rounds: rounds)
    }
}
