//
//  Models.swift
//  Text-Based-Idle-Game-Demo
//
//  Created by Utku Yeğen on 25.06.2025.
//

import Foundation

public struct IdleRPGBaseModel: Codable {
    public let character: IdleRPGCharacterModel
    public let leveling: IdleRPGLevelingModel
    public let equipment: IdleRpgEquipment
}
