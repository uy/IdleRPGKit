//
//  IdleRpgAchievement.swift
//  IdleRPGKit
//

public struct IdleRpgAchievement: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let objectiveKind: IdleRpgAchievementObjectiveKind
    public let targetValue: Int
    public let rewardAttributePoints: Int
}
