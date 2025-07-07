//
//  IdleRpgInventoryItem.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 7.07.2025.
//

import Foundation

public struct IdleRpgInventoryItem: Identifiable, Hashable, Codable {
    public let id: UUID
    public let baseItemId: String         // Referans olarak JSON'daki item ID
    public var quantity: Int              // Belki 1'den fazla olabilir (örn: potion)
    public var isEquipped: Bool           // Eğer bu item takılıysa
    public var customProperties: [String: Double]? // RNG bonuslar için ileride

    public init(
        baseItemId: String,
        quantity: Int = 1,
        isEquipped: Bool = false,
        customProperties: [String: Double]? = nil
    ) {
        self.id = UUID()
        self.baseItemId = baseItemId
        self.quantity = quantity
        self.isEquipped = isEquipped
        self.customProperties = customProperties
    }
}
