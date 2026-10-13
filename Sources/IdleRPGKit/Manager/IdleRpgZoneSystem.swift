//
//  IdleRpgZoneSystem.swift
//  IdleRPGKit
//

public struct IdleRpgZoneSystem {
    private let model: IdleRpgZoneCatalog

    public var zones: [IdleRpgZone] { model.catalog }

    public init(zones model: IdleRpgZoneCatalog) {
        self.model = model
    }

    public func isUnlocked(_ zone: IdleRpgZone, atLevel level: Int) -> Bool {
        level >= zone.requiredLevel
    }

    public func enemies(in zone: IdleRpgZone, from allEnemies: [IdleRpgEnemy]) -> [IdleRpgEnemy] {
        allEnemies.filter { zone.enemyIds.contains($0.id) }
    }
}
