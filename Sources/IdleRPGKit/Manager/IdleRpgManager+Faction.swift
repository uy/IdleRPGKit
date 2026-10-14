//
//  IdleRpgManager+Faction.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public func reputation(for faction: IdleRpgFaction) -> Int {
        gameProgress.character.factionReputation[faction.id] ?? 0
    }

    public var joinedFaction: IdleRpgFaction? {
        guard let joinedFactionId = gameProgress.character.joinedFactionId else { return nil }
        return factionSystem.factions.first(where: { $0.id == joinedFactionId })
    }

    public func joinFaction(_ faction: IdleRpgFaction?) {
        gameProgress.character.joinedFactionId = faction?.id
        saveProgress()
    }

    public func contributeToJoinedFaction() {
        guard let faction = joinedFaction else { return }
        let amount = factionSystem.reputationPerContribution

        gameProgress.character.factionReputation[faction.id, default: 0] += amount

        if let rival = factionSystem.rivalFaction(of: faction) {
            let currentRivalReputation = gameProgress.character.factionReputation[rival.id, default: 0]
            gameProgress.character.factionReputation[rival.id] = max(0, currentRivalReputation - amount)
        }

        saveProgress()
    }
}
