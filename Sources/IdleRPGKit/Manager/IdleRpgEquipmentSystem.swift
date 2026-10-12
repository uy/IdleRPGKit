//
//  IdleRpgEquipmentSystem.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 6.07.2025.
//

import Foundation

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

    public func rollBonuses(
        for item: IdleRpgEquipmentItem
    ) -> [IdleRpgAttributeBonus] {
        let multiplierRange = (model.rarityBonusMultipliers ?? .defaultMultipliers).range(for: item.rarity)
        return item.baseBonuses.map { baseBonus in
            let multiplier = Double.random(in: multiplierRange.min...multiplierRange.max)
            let rolledValue = max(1, Int((Double(baseBonus.bonus) * multiplier).rounded()))
            return IdleRpgAttributeBonus(attributeKey: baseBonus.attributeKey, bonus: rolledValue)
        }
    }

    public func generateOwnedItem(
        templateId: String
    ) -> IdleRpgOwnedEquipmentItem? {
        guard let template = equipmentsPool.first(where: { $0.id == templateId }) else {
            return nil
        }

        return IdleRpgOwnedEquipmentItem(
            templateId: template.id,
            rolledBonuses: rollBonuses(for: template)
        )
    }
}
