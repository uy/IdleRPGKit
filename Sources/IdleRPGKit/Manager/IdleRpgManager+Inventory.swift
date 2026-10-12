//
//  IdleRpgManager+Inventory.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public var inventoryCapacity: Int {
        inventorySystem.maxSlots
    }

    public var isInventoryFull: Bool {
        !inventorySystem.hasRoom(currentCount: gameProgress.character.ownedItems.count)
    }

    @discardableResult
    public func discardItem(_ ownedItem: IdleRpgOwnedEquipmentItem) -> Bool {
        guard let index = gameProgress.character.ownedItems.firstIndex(where: { $0.instanceId == ownedItem.instanceId }) else {
            return false
        }

        if let slotKey = template(for: ownedItem)?.slotKey,
           equippedOwnedItem(for: slotKey)?.instanceId == ownedItem.instanceId {
            unequip(slotKey: slotKey)
        }

        gameProgress.character.ownedItems.remove(at: index)
        return true
    }
}
