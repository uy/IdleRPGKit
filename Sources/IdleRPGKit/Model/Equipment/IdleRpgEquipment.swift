//
//  IdleRpgEquipment.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 5.07.2025.
//

public struct IdleRpgEquipment: Codable {
    public let equipmentSlot: [IdleRpgEquipmentSlot]
    public let equipments: [IdleRpgEquipmentItem]
    public let rarityBonusMultipliers: IdleRpgRarityBonusMultipliers?
}
