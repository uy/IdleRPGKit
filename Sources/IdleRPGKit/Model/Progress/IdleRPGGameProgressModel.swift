//
//  IdleRPGGameProgressModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

//public struct IdleRPGGameProgressModel: Codable {
//    public var character: IdleRPGCharacterProgressModel
//}

import Combine

public class IdleRPGGameProgressModel: ObservableObject, Codable {
    @Published public var character: IdleRPGCharacterProgressModel

    enum CodingKeys: CodingKey {
        case character
    }

    public init(character: IdleRPGCharacterProgressModel) {
        self.character = character
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.character = try container.decode(IdleRPGCharacterProgressModel.self, forKey: .character)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(character, forKey: .character)
    }
}
