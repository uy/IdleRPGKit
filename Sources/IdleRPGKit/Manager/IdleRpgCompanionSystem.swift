//
//  IdleRpgCompanionSystem.swift
//  IdleRPGKit
//

public struct IdleRpgCompanionSystem {
    private let model: IdleRpgCompanionCatalog

    public var companions: [IdleRpgCompanion] { model.catalog }

    public init(companions model: IdleRpgCompanionCatalog) {
        self.model = model
    }

    public func isUnlocked(_ companion: IdleRpgCompanion, atLevel level: Int) -> Bool {
        level >= companion.unlockLevel
    }
}
