//
//  IdleRpgManager+Skill.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public func skillBonus(for attributeKey: String) -> Int {
        skillSystem.passiveBonus(for: attributeKey, atLevel: gameProgress.character.level)
    }
}
