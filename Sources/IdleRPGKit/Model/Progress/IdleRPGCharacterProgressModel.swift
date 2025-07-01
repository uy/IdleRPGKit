//
//  IdleRPGCharacterProgressModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

//public struct IdleRPGCharacterProgressModel: Codable {
//    public let race: IdleRPGRaceModel
//    public let clas: IdleRPGClasModel
//    public var level: Int
//    public var currentExperience: Int
//}

import Combine

public class IdleRPGCharacterProgressModel: ObservableObject, Codable {
    public let race: IdleRPGRaceModel
    public let clas: IdleRPGClasModel

    @Published public var level: Int
    @Published public var currentExperience: Int

    enum CodingKeys: CodingKey {
        case race, clas, level, currentExperience
    }

    public init(
        race: IdleRPGRaceModel,
        clas: IdleRPGClasModel,
        level: Int,
        currentExperience: Int
    ) {
        self.race = race
        self.clas = clas
        self.level = level
        self.currentExperience = currentExperience
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.race = try container.decode(IdleRPGRaceModel.self, forKey: .race)
        self.clas = try container.decode(IdleRPGClasModel.self, forKey: .clas)
        self.level = try container.decode(Int.self, forKey: .level)
        self.currentExperience = try container.decode(Int.self, forKey: .currentExperience)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(race, forKey: .race)
        try container.encode(clas, forKey: .clas)
        try container.encode(level, forKey: .level)
        try container.encode(currentExperience, forKey: .currentExperience)
    }
}
