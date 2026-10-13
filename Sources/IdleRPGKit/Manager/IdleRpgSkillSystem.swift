//
//  IdleRpgSkillSystem.swift
//  IdleRPGKit
//

public struct IdleRpgSkillSystem {
    private let model: IdleRpgSkillCatalog

    public init(skills model: IdleRpgSkillCatalog) {
        self.model = model
    }

    public var skills: [IdleRpgSkill] { model.catalog }

    public func passiveBonus(for attributeKey: String, atLevel level: Int) -> Int {
        skills
            .filter { $0.attributeKey == attributeKey }
            .reduce(0) { $0 + Int((Double(level) * $1.bonusPerLevel).rounded()) }
    }
}
