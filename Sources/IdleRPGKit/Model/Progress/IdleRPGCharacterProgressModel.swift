//
//  IdleRPGCharacterProgressModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

public struct IdleRPGCharacterProgressModel: Codable {
    public let race: IdleRPGRaceModel
    public let clas: IdleRPGClasModel
    public var level: Int
    public var currentExperience: Int
}
