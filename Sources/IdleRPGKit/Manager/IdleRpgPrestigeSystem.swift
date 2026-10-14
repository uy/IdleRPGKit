//
//  IdleRpgPrestigeSystem.swift
//  IdleRPGKit
//

public struct IdleRpgPrestigeSystem {
    private let model: IdleRPGPrestigeModel

    public var requiredLevel: Int { model.requiredLevel }

    public init(prestige model: IdleRPGPrestigeModel) {
        self.model = model
    }

    public func isEligible(atLevel level: Int) -> Bool {
        level >= model.requiredLevel
    }

    public func bonus(forPrestigeCount count: Int) -> Int {
        count * model.bonusPerPrestige
    }
}
