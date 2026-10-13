//
//  IdleRpgManager+Companion.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public func isCompanionUnlocked(_ companion: IdleRpgCompanion) -> Bool {
        companionSystem.isUnlocked(companion, atLevel: gameProgress.character.level)
    }

    public var activeCompanion: IdleRpgCompanion? {
        guard let activeCompanionId = gameProgress.character.activeCompanionId else { return nil }
        return companionSystem.companions.first(where: { $0.id == activeCompanionId })
    }

    @discardableResult
    public func setActiveCompanion(_ companion: IdleRpgCompanion?) -> Bool {
        if let companion, !isCompanionUnlocked(companion) { return false }
        gameProgress.character.activeCompanionId = companion?.id
        saveProgress()
        return true
    }

    public func companionBonus(for attributeKey: String) -> Int {
        activeCompanion?.passiveBonuses.first(where: { $0.attributeKey == attributeKey })?.bonus ?? 0
    }
}
