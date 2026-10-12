//
//  IdleRpgOwnedEquipmentItem.swift
//  IdleRPGKit
//

import Foundation

public struct IdleRpgOwnedEquipmentItem: Codable, Identifiable, Hashable {
    public let instanceId: UUID
    public let templateId: String
    public let rolledBonuses: [IdleRpgAttributeBonus]

    public var id: UUID { instanceId }

    public init(
        instanceId: UUID = UUID(),
        templateId: String,
        rolledBonuses: [IdleRpgAttributeBonus]
    ) {
        self.instanceId = instanceId
        self.templateId = templateId
        self.rolledBonuses = rolledBonuses
    }
}
