//
//  IdleRpgCraftingRecipe.swift
//  IdleRPGKit
//

public struct IdleRpgCraftingRecipe: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let resultTemplateId: String
    public let requiredMaterials: [IdleRpgMaterialRequirement]
}
