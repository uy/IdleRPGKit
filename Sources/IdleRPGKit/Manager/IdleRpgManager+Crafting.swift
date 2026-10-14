//
//  IdleRpgManager+Crafting.swift
//  IdleRPGKit
//

extension IdleRpgManager {
    public func materialCount(for materialId: String) -> Int {
        gameProgress.character.materialCounts[materialId] ?? 0
    }

    public func gatherMaterial(_ material: IdleRpgCraftingMaterial) {
        gameProgress.character.materialCounts[material.id, default: 0] += material.gatherAmount
        saveProgress()
    }

    public func canCraft(_ recipe: IdleRpgCraftingRecipe) -> Bool {
        craftingSystem.canCraft(recipe, owned: gameProgress.character.materialCounts)
    }

    @discardableResult
    public func craft(_ recipe: IdleRpgCraftingRecipe) -> IdleRpgOwnedEquipmentItem? {
        guard canCraft(recipe),
              !isInventoryFull,
              let ownedItem = equipmentSystem.generateOwnedItem(templateId: recipe.resultTemplateId)
        else { return nil }

        for requirement in recipe.requiredMaterials {
            gameProgress.character.materialCounts[requirement.materialId, default: 0] -= requirement.quantity
        }
        gameProgress.character.ownedItems.append(ownedItem)
        gameProgress.character.totalItemsCrafted += 1
        saveProgress()

        return ownedItem
    }
}
