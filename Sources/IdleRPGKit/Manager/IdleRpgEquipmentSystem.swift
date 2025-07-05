//
//  IdleRpgEquipmentSystem.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 6.07.2025.
//

public struct IdleRpgEquipmentSystem {
    private var model: IdleRpgEquipment
    public var slots: [IdleRpgEquipmentSlot]
    
    public init(
        equipment model: IdleRpgEquipment
    ) {
        self.model = model
        self.slots = model.equipmentSlot
    }
}
