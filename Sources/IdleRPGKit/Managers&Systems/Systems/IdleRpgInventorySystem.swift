//
//  IdleRpgInventorySystem.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 7.07.2025.
//

import Foundation

public struct IdleRpgInventorySystem {
    private(set) var items: [IdleRpgInventoryItem]
    
    public var itemCount: Int {
        items.count
    }

    public init(
        items: [IdleRpgInventoryItem] = []
    ) {
        self.items = items
    }

    public func items(
        forSlot slotKey: String,
        from equipmentPool: [IdleRpgEquipmentItem]
    ) -> [IdleRpgInventoryItem] {
        items.filter { inventoryItem in
            equipmentPool.first(where: { $0.id == inventoryItem.baseItemId })?.slotKey == slotKey
        }
    }

    public mutating func addItem(
        _ item: IdleRpgInventoryItem
    ) {
        items.append(item)
    }

    public mutating func removeItem(
        id: UUID
    ) {
        items.removeAll { $0.id == id }
    }
}
