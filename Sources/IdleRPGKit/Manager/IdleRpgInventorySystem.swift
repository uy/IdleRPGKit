//
//  IdleRpgInventorySystem.swift
//  IdleRPGKit
//

public struct IdleRpgInventorySystem {
    private let model: IdleRPGInventoryModel

    public var maxSlots: Int { model.maxSlots }

    public init(inventory model: IdleRPGInventoryModel) {
        self.model = model
    }

    public func hasRoom(currentCount: Int) -> Bool {
        currentCount < maxSlots
    }
}
