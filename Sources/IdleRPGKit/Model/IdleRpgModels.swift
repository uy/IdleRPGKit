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
    public let idleMechanics: IdleRPGIdleMechanicsModel
    public let inventory: IdleRPGInventoryModel
    public let enemies: IdleRpgEnemyCatalog
    public let battle: IdleRPGBattleFormulaModel
    public let skills: IdleRpgSkillCatalog
    public let adventures: IdleRpgAdventureCatalog
    public let quests: IdleRpgQuestCatalog
    public let craftingMaterials: IdleRpgCraftingMaterialCatalog
    public let craftingRecipes: IdleRpgCraftingRecipeCatalog
    public let zones: IdleRpgZoneCatalog
}
