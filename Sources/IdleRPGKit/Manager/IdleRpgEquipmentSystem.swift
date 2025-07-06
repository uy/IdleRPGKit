//
//  IdleRpgEquipmentSystem.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 6.07.2025.
//

public struct IdleRpgEquipmentSystem {
    private var model: IdleRpgEquipment
    public var slots: [IdleRpgEquipmentSlot]
    public var equipmentsPool: [IdleRpgEquipmentItem]
    
    public var equipmentsPoolCount: Int { equipmentsPool.count }
    
    public init(
        equipment model: IdleRpgEquipment
    ) {
        self.model = model
        self.slots = model.equipmentSlot
        self.equipmentsPool = model.equipments
    }
    
    public func equipmentsFor(
        slot: String
    ) -> [IdleRpgEquipmentItem] {
        return equipmentsPool.filter({ $0.slotKey == slot })
    }
}
