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
        enemyStats: IdleRpgEnemyStats,
        inflicts: IdleRpgStatusEffect? = nil
    ) -> IdleRpgBattleOutcome {
        var characterHP = characterHealth
        var enemyHP = enemyStats.health
        var rounds = 0
        var effectRoundsRemaining = inflicts?.durationRounds ?? 0
        let baseCharacterDamage = max(1, characterAttackDamage - enemyStats.defense)
        let baseEnemyDamage = max(1, enemyStats.attackDamage - characterDefense)

        while characterHP > 0 && enemyHP > 0 {
            rounds += 1
            let effectActive = effectRoundsRemaining > 0

            let characterDamageThisRound: Int
            if let inflicts, effectActive, inflicts.kind == .attackReduction {
                characterDamageThisRound = max(1, baseCharacterDamage - inflicts.magnitude)
            } else {
                characterDamageThisRound = baseCharacterDamage
            }
            enemyHP -= characterDamageThisRound
            if enemyHP <= 0 { break }

            characterHP -= baseEnemyDamage
            if let inflicts, effectActive, inflicts.kind == .damageOverTime {
                // character may already be dead from the base hit above — this DOT tick is inert in that case, harmless
                characterHP -= inflicts.magnitude
            }
            if effectActive {
                effectRoundsRemaining -= 1
            }
            if characterHP <= 0 { break }
        }

        return IdleRpgBattleOutcome(won: enemyHP <= 0, rounds: rounds, appliedEffectName: inflicts?.name)
    }
}
