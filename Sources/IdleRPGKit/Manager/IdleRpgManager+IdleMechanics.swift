//
//  IdleRpgManager+IdleMechanics.swift
//  IdleRPGKit
//

import Foundation

extension IdleRpgManager {
    @discardableResult
    public func applyIdleProgress(now: Date = Date()) -> Int {
        let result = idleMechanicsSystem.progress(since: gameProgress.character.lastSeenDate, now: now)

        if result.earnedXp > 0 {
            gainXp(result.earnedXp)
            gameProgress.character.lastSeenDate = now
            saveProgress()
            idleProgressEventSubject.send(result)
        }

        return result.earnedXp
    }
}
