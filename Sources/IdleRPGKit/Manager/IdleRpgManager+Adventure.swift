//
//  IdleRpgManager+Adventure.swift
//  IdleRPGKit
//

import Foundation

extension IdleRpgManager {
    public var activeAdventure: IdleRpgAdventure? {
        guard let id = gameProgress.character.activeAdventureId else { return nil }
        return adventureSystem.adventures.first(where: { $0.id == id })
    }

    public func remainingAdventureSeconds(now: Date = Date()) -> TimeInterval? {
        guard let adventure = activeAdventure,
              let startedAt = gameProgress.character.adventureStartedAt
        else { return nil }
        return adventureSystem.remainingSeconds(for: adventure, startedAt: startedAt, now: now)
    }

    @discardableResult
    public func startAdventure(_ adventure: IdleRpgAdventure) -> Bool {
        guard activeAdventure == nil else { return false }
        gameProgress.character.activeAdventureId = adventure.id
        gameProgress.character.adventureStartedAt = Date()
        saveProgress()
        return true
    }

    @discardableResult
    public func claimAdventure(now: Date = Date()) -> IdleRpgBattleResult? {
        guard let adventure = activeAdventure,
              let startedAt = gameProgress.character.adventureStartedAt,
              adventureSystem.isComplete(adventure, startedAt: startedAt, now: now),
              let enemy = enemySystem.enemies.first(where: { $0.id == adventure.enemyId })
        else { return nil }

        gameProgress.character.activeAdventureId = nil
        gameProgress.character.adventureStartedAt = nil

        let result = fight(enemy)
        saveProgress()
        return result
    }
}
