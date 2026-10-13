//
//  IdleRpgQuest.swift
//  IdleRPGKit
//

public struct IdleRpgQuest: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let objectiveKind: IdleRpgQuestObjectiveKind
    public let targetValue: Int
    public let rewardXp: Int
}
