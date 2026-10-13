//
//  IdleRpgCraftingSystem.swift
//  IdleRPGKit
//

public struct IdleRpgCraftingSystem {
    private let materialsModel: IdleRpgCraftingMaterialCatalog
    private let recipesModel: IdleRpgCraftingRecipeCatalog

    public var materials: [IdleRpgCraftingMaterial] { materialsModel.catalog }
    public var recipes: [IdleRpgCraftingRecipe] { recipesModel.catalog }

    public init(
        materials: IdleRpgCraftingMaterialCatalog,
        recipes: IdleRpgCraftingRecipeCatalog
    ) {
        self.materialsModel = materials
        self.recipesModel = recipes
    }

    public func canCraft(_ recipe: IdleRpgCraftingRecipe, owned: [String: Int]) -> Bool {
        recipe.requiredMaterials.allSatisfy { requirement in
            (owned[requirement.materialId] ?? 0) >= requirement.quantity
        }
    }
}
