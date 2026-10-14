//
//  IdleRPGCharacterProgressModel.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

import Combine
import Foundation

public class IdleRPGCharacterProgressModel: ObservableObject, Codable {
    public let race: IdleRPGRaceModel
    public let clas: IdleRPGClasModel

    @Published public var attributes: [IdleRPGCharacterProgressAttributeModel]
    @Published public var freeAttributePoints: Int
    @Published public var level: Int
    @Published public var currentExperience: Int
    @Published public var ownedItems: [IdleRpgOwnedEquipmentItem]
    @Published public var equippedInstanceIds: [String: UUID]
    @Published public var lastSeenDate: Date
    @Published public var activeAdventureId: String?
    @Published public var adventureStartedAt: Date?
    @Published public var totalBattlesWon: Int
    @Published public var claimedQuestIds: [String]
    @Published public var materialCounts: [String: Int]
    @Published public var currentZoneId: String?
    @Published public var activeCompanionId: String?
    @Published public var factionReputation: [String: Int]
    @Published public var joinedFactionId: String?
    @Published public var totalItemsCrafted: Int
    @Published public var claimedAchievementIds: [String]
    @Published public var prestigeCount: Int

    enum CodingKeys: CodingKey {
        case race, clas, level, currentExperience, attributes, freeAttributePoints, ownedItems, equippedInstanceIds, lastSeenDate, activeAdventureId, adventureStartedAt, totalBattlesWon, claimedQuestIds, materialCounts, currentZoneId, activeCompanionId, factionReputation, joinedFactionId, totalItemsCrafted, claimedAchievementIds, prestigeCount
    }

    public init(
        attributes: [IdleRPGCharacterAttributeModel],
        freeAttributePoints: Int,
        race: IdleRPGRaceModel,
        clas: IdleRPGClasModel,
        level: Int,
        currentExperience: Int,
        ownedItems: [IdleRpgOwnedEquipmentItem] = [],
        equippedInstanceIds: [String: UUID] = [:],
        lastSeenDate: Date = Date(),
        activeAdventureId: String? = nil,
        adventureStartedAt: Date? = nil,
        totalBattlesWon: Int = 0,
        claimedQuestIds: [String] = [],
        materialCounts: [String: Int] = [:],
        currentZoneId: String? = nil,
        activeCompanionId: String? = nil,
        factionReputation: [String: Int] = [:],
        joinedFactionId: String? = nil,
        totalItemsCrafted: Int = 0,
        claimedAchievementIds: [String] = [],
        prestigeCount: Int = 0
    ) {
        self.race = race
        self.clas = clas
        self.level = level
        self.currentExperience = currentExperience
        self.freeAttributePoints = freeAttributePoints
        self.ownedItems = ownedItems
        self.equippedInstanceIds = equippedInstanceIds
        self.lastSeenDate = lastSeenDate
        self.activeAdventureId = activeAdventureId
        self.adventureStartedAt = adventureStartedAt
        self.totalBattlesWon = totalBattlesWon
        self.claimedQuestIds = claimedQuestIds
        self.materialCounts = materialCounts
        self.currentZoneId = currentZoneId
        self.activeCompanionId = activeCompanionId
        self.factionReputation = factionReputation
        self.joinedFactionId = joinedFactionId
        self.totalItemsCrafted = totalItemsCrafted
        self.claimedAchievementIds = claimedAchievementIds
        self.prestigeCount = prestigeCount
        self.attributes = attributes.map { baseAttribute in
            if let startingBonusAttribute = clas.startingBonusAttributes.first(where: { $0.key == baseAttribute.key }) {
                IdleRPGCharacterProgressAttributeModel(
                    key: baseAttribute.key,
                    attribute: baseAttribute.baseScore + startingBonusAttribute.bonus
                )
            } else {
                IdleRPGCharacterProgressAttributeModel(
                    key: baseAttribute.key,
                    attribute: baseAttribute.baseScore
                )
            }
        }
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.race = try container.decode(IdleRPGRaceModel.self, forKey: .race)
        self.clas = try container.decode(IdleRPGClasModel.self, forKey: .clas)
        self.level = try container.decode(Int.self, forKey: .level)
        self.currentExperience = try container.decode(Int.self, forKey: .currentExperience)
        self.attributes = try container.decode([IdleRPGCharacterProgressAttributeModel].self, forKey: .attributes)
        self.freeAttributePoints = try container.decode(Int.self, forKey: .freeAttributePoints)
        self.ownedItems = try container.decodeIfPresent([IdleRpgOwnedEquipmentItem].self, forKey: .ownedItems) ?? []
        self.equippedInstanceIds = try container.decodeIfPresent([String: UUID].self, forKey: .equippedInstanceIds) ?? [:]
        self.lastSeenDate = try container.decodeIfPresent(Date.self, forKey: .lastSeenDate) ?? Date()
        self.activeAdventureId = try container.decodeIfPresent(String.self, forKey: .activeAdventureId) ?? nil
        self.adventureStartedAt = try container.decodeIfPresent(Date.self, forKey: .adventureStartedAt) ?? nil
        self.totalBattlesWon = try container.decodeIfPresent(Int.self, forKey: .totalBattlesWon) ?? 0
        self.claimedQuestIds = try container.decodeIfPresent([String].self, forKey: .claimedQuestIds) ?? []
        self.materialCounts = try container.decodeIfPresent([String: Int].self, forKey: .materialCounts) ?? [:]
        self.currentZoneId = try container.decodeIfPresent(String.self, forKey: .currentZoneId) ?? nil
        self.activeCompanionId = try container.decodeIfPresent(String.self, forKey: .activeCompanionId) ?? nil
        self.factionReputation = try container.decodeIfPresent([String: Int].self, forKey: .factionReputation) ?? [:]
        self.joinedFactionId = try container.decodeIfPresent(String.self, forKey: .joinedFactionId) ?? nil
        self.totalItemsCrafted = try container.decodeIfPresent(Int.self, forKey: .totalItemsCrafted) ?? 0
        self.claimedAchievementIds = try container.decodeIfPresent([String].self, forKey: .claimedAchievementIds) ?? []
        self.prestigeCount = try container.decodeIfPresent(Int.self, forKey: .prestigeCount) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(race, forKey: .race)
        try container.encode(clas, forKey: .clas)
        try container.encode(level, forKey: .level)
        try container.encode(currentExperience, forKey: .currentExperience)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(freeAttributePoints, forKey: .freeAttributePoints)
        try container.encode(ownedItems, forKey: .ownedItems)
        try container.encode(equippedInstanceIds, forKey: .equippedInstanceIds)
        try container.encode(lastSeenDate, forKey: .lastSeenDate)
        try container.encode(activeAdventureId, forKey: .activeAdventureId)
        try container.encode(adventureStartedAt, forKey: .adventureStartedAt)
        try container.encode(totalBattlesWon, forKey: .totalBattlesWon)
        try container.encode(claimedQuestIds, forKey: .claimedQuestIds)
        try container.encode(materialCounts, forKey: .materialCounts)
        try container.encode(currentZoneId, forKey: .currentZoneId)
        try container.encode(activeCompanionId, forKey: .activeCompanionId)
        try container.encode(factionReputation, forKey: .factionReputation)
        try container.encode(joinedFactionId, forKey: .joinedFactionId)
        try container.encode(totalItemsCrafted, forKey: .totalItemsCrafted)
        try container.encode(claimedAchievementIds, forKey: .claimedAchievementIds)
        try container.encode(prestigeCount, forKey: .prestigeCount)
    }
}
