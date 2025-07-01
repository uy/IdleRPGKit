//
//  IdleRPGCharacterModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

public struct IdleRPGCharacterModel: Codable {
    public let races: [IdleRPGRaceModel]
    public let clases: [IdleRPGClasModel]
    public let attributes: [IdleRPGCharacterAttributeModel]
}
