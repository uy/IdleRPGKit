//
//  IdleRpgEquipmentSlot.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 5.07.2025.
//

import SwiftUI

public struct IdleRpgEquipmentSlot: Codable, Hashable, Identifiable {
    public let key: String
    public let labelKey: String

    public var id: String { key }

    public var localizedLabel: LocalizedStringKey {
        LocalizedStringKey(labelKey)
    }
}
