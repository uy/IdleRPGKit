//
//  IdleRpgBattleResult.swift
//  IdleRPGKit
//

public struct IdleRpgBattleResult {
    public let enemyId: String
    public let won: Bool
    public let rounds: Int
    public let earnedXp: Int
    public let droppedItem: IdleRpgOwnedEquipmentItem?
}
