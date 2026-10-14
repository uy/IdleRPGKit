//
//  IdleRpgFactionSystem.swift
//  IdleRPGKit
//

public struct IdleRpgFactionSystem {
    private let model: IdleRpgFactionCatalog
    private let config: IdleRPGFactionConfigModel

    public var factions: [IdleRpgFaction] { model.catalog }
    public var reputationPerContribution: Int { config.reputationPerContribution }

    public init(factions model: IdleRpgFactionCatalog, config: IdleRPGFactionConfigModel) {
        self.model = model
        self.config = config
    }

    public func rivalFaction(of faction: IdleRpgFaction) -> IdleRpgFaction? {
        guard let rivalFactionId = faction.rivalFactionId else { return nil }
        return factions.first(where: { $0.id == rivalFactionId })
    }
}
