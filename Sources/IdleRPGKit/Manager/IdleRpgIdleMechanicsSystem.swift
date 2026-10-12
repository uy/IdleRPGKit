//
//  IdleRpgIdleMechanicsSystem.swift
//  IdleRPGKit
//

import Foundation

public struct IdleRpgIdleMechanicsSystem {
    private let model: IdleRPGIdleMechanicsModel

    public init(idleMechanics model: IdleRPGIdleMechanicsModel) {
        self.model = model
    }

    public func progress(
        since lastSeenDate: Date,
        now: Date = Date()
    ) -> IdleRpgIdleProgressEvent {
        let elapsed = now.timeIntervalSince(lastSeenDate)
        let cappedElapsed = max(0, min(elapsed, Double(model.maxOfflineSeconds)))
        let earnedXp = Int(cappedElapsed * model.xpPerSecond)
        return IdleRpgIdleProgressEvent(earnedXp: earnedXp, elapsedSeconds: cappedElapsed)
    }
}
