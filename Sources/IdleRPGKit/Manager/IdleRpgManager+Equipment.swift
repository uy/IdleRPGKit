//
//  IdleRpgManager+Equipment.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 6.07.2025.
//

import Foundation

extension IdleRpgManager {
    public func getEquipmentSlots() -> [IdleRpgEquipmentSlot] {
        return equipmentSystem.slots
    }

    public func ownedItems(for slotKey: String) -> [IdleRpgOwnedEquipmentItem] {
        return gameProgress.character.ownedItems.filter { ownedItem in
            template(for: ownedItem)?.slotKey == slotKey
        }
    }

    public func template(for ownedItem: IdleRpgOwnedEquipmentItem) -> IdleRpgEquipmentItem? {
        return equipmentSystem.equipmentsPool.first(where: { $0.id == ownedItem.templateId })
    }

    public func equippedOwnedItem(for slotKey: String) -> IdleRpgOwnedEquipmentItem? {
        guard let instanceId = gameProgress.character.equippedInstanceIds[slotKey] else { return nil }
        return gameProgress.character.ownedItems.first(where: { $0.instanceId == instanceId })
    }

    public func equip(_ ownedItem: IdleRpgOwnedEquipmentItem) {
        guard let slotKey = template(for: ownedItem)?.slotKey else { return }
        gameProgress.character.equippedInstanceIds[slotKey] = ownedItem.instanceId
        saveProgress()
    }

    public func unequip(slotKey: String) {
        gameProgress.character.equippedInstanceIds.removeValue(forKey: slotKey)
        saveProgress()
    }

    @discardableResult
    public func generateRandomOwnedItem(for slotKey: String) -> Bool {
        guard !isInventoryFull,
              let template = equipmentSystem.equipmentsFor(slot: slotKey).randomElement(),
              let ownedItem = equipmentSystem.generateOwnedItem(templateId: template.id)
        else { return false }

        gameProgress.character.ownedItems.append(ownedItem)
        saveProgress()
        return true
    }

    public func equipmentBonus(for attributeKey: String) -> Int {
        return gameProgress.character.equippedInstanceIds.values
            .compactMap { instanceId in
                gameProgress.character.ownedItems.first(where: { $0.instanceId == instanceId })
            }
            .flatMap { $0.rolledBonuses }
            .filter { $0.attributeKey == attributeKey }
            .reduce(0) { $0 + $1.bonus }
    }
}
