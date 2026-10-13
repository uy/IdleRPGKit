//
//  IdleRpgManager+Zone.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public var currentZone: IdleRpgZone {
        if let currentZoneId = gameProgress.character.currentZoneId,
           let zone = zoneSystem.zones.first(where: { $0.id == currentZoneId }) {
            return zone
        }
        return zoneSystem.zones[0]
    }

    public func isZoneUnlocked(_ zone: IdleRpgZone) -> Bool {
        zoneSystem.isUnlocked(zone, atLevel: gameProgress.character.level)
    }

    @discardableResult
    public func travelTo(_ zone: IdleRpgZone) -> Bool {
        guard isZoneUnlocked(zone) else { return false }
        gameProgress.character.currentZoneId = zone.id
        saveProgress()
        return true
    }

    public func enemiesInCurrentZone() -> [IdleRpgEnemy] {
        zoneSystem.enemies(in: currentZone, from: enemySystem.enemies)
    }
}
