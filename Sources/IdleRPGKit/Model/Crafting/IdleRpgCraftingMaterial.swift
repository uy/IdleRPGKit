//
//  IdleRpgCraftingMaterial.swift
//  IdleRPGKit
//

public struct IdleRpgCraftingMaterial: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let gatherAmount: Int
}
