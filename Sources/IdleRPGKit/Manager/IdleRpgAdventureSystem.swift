//
//  IdleRpgAdventureSystem.swift
//  IdleRPGKit
//

import Foundation

public struct IdleRpgAdventureSystem {
    private let model: IdleRpgAdventureCatalog

    public init(adventures model: IdleRpgAdventureCatalog) {
        self.model = model
    }

    public var adventures: [IdleRpgAdventure] { model.catalog }

    public func remainingSeconds(
        for adventure: IdleRpgAdventure,
        startedAt: Date,
        now: Date = Date()
    ) -> TimeInterval {
        max(0, Double(adventure.durationSeconds) - now.timeIntervalSince(startedAt))
    }

    public func isComplete(
        _ adventure: IdleRpgAdventure,
        startedAt: Date,
        now: Date = Date()
    ) -> Bool {
        remainingSeconds(for: adventure, startedAt: startedAt, now: now) <= 0
    }
}
