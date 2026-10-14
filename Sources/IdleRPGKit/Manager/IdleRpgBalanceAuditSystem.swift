//
//  IdleRpgBalanceAuditSystem.swift
//  IdleRPGKit
//
//  A developer-facing, read-only linter over a loaded IdleRPGBaseModel.
//  Not wired into IdleRpgManager -- construct and call `audit()` on demand
//  (e.g. from a RunCodeSnippet pass, or a #if DEBUG button), never on launch.
//

public struct IdleRpgBalanceAuditSystem {
    private let model: IdleRPGBaseModel

    public init(model: IdleRPGBaseModel) {
        self.model = model
    }

    public func audit() -> [IdleRpgBalanceWarning] {
        checkLevelingProgression()
            + checkEnemyProgression()
            + checkEquipmentRarityMultipliers()
            + checkCompanionProgression()
            + checkQuestRewardScaling()
            + checkAchievementRewardScaling()
            + checkCraftingConsistency()
            + checkReferentialIntegrity()
            + checkPrestigeGateSanity()
            + checkScalarSanity()
    }

    // MARK: - Thresholds (named constants, not derived)

    private enum Thresholds {
        static let craftingLowMaterialQuantity = 3
        static let craftingHighMaterialQuantity = 15
        static let levelRangeBuffer = 5
    }

    private struct LevelGate {
        let system: String
        let name: String
        let level: Int
    }

    private func collectLevelGates() -> [LevelGate] {
        var gates: [LevelGate] = []
        gates += model.zones.catalog.map { LevelGate(system: "Zone", name: $0.name, level: $0.requiredLevel) }
        gates += model.companions.catalog.map { LevelGate(system: "Companion", name: $0.name, level: $0.unlockLevel) }
        gates += model.quests.catalog
            .filter { $0.objectiveKind == .reachLevel }
            .map { LevelGate(system: "Quest", name: $0.name, level: $0.targetValue) }
        gates += model.achievements.catalog
            .filter { $0.objectiveKind == .reachLevel }
            .map { LevelGate(system: "Achievement", name: $0.name, level: $0.targetValue) }
        return gates
    }

    // MARK: - 1. Leveling progression

    private func checkLevelingProgression() -> [IdleRpgBalanceWarning] {
        let highestGate = collectLevelGates().map(\.level).max() ?? 1
        let maxLevel = highestGate + Thresholds.levelRangeBuffer

        var levelingSystem = IdleRpgLevelingSystem(
            leveling: model.leveling,
            attributePointsPerLevel: model.leveling.attributePointsPerLevel
        )

        var warnings: [IdleRpgBalanceWarning] = []
        var previousXp: Int?
        for level in 1...max(maxLevel, 1) {
            let xp = levelingSystem.xpToNextLevel(level)
            if let previousXp, xp < previousXp {
                warnings.append(IdleRpgBalanceWarning(
                    severity: .warning,
                    system: "Leveling",
                    message: "xpToNextLevel decreased from level \(level - 1) (\(previousXp)) to level \(level) (\(xp))"
                ))
            }
            previousXp = xp
        }
        return warnings
    }

    // MARK: - 2. Enemy progression

    private func checkEnemyProgression() -> [IdleRpgBalanceWarning] {
        let sorted = model.enemies.catalog.sorted { $0.level < $1.level }
        guard sorted.count > 1 else { return [] }

        func statWarning(_ stat: String, higher: IdleRpgEnemy, higherValue: Int, lower: IdleRpgEnemy, lowerValue: Int) -> IdleRpgBalanceWarning {
            IdleRpgBalanceWarning(
                severity: .warning,
                system: "Enemies",
                message: "\(higher.name) (level \(higher.level), \(stat) \(higherValue)) is weaker than \(lower.name) (level \(lower.level), \(stat) \(lowerValue)) despite being higher level"
            )
        }

        var warnings: [IdleRpgBalanceWarning] = []
        for i in 1..<sorted.count {
            let lower = sorted[i - 1]
            let higher = sorted[i]

            if higher.baseHealth < lower.baseHealth {
                warnings.append(statWarning("baseHealth", higher: higher, higherValue: higher.baseHealth, lower: lower, lowerValue: lower.baseHealth))
            }
            if higher.baseAttackDamage < lower.baseAttackDamage {
                warnings.append(statWarning("baseAttackDamage", higher: higher, higherValue: higher.baseAttackDamage, lower: lower, lowerValue: lower.baseAttackDamage))
            }
            if higher.baseDefense < lower.baseDefense {
                warnings.append(statWarning("baseDefense", higher: higher, higherValue: higher.baseDefense, lower: lower, lowerValue: lower.baseDefense))
            }
            if higher.rewardXp < lower.rewardXp {
                warnings.append(statWarning("rewardXp", higher: higher, higherValue: higher.rewardXp, lower: lower, lowerValue: lower.rewardXp))
            }
        }
        return warnings
    }

    // MARK: - 3. Equipment rarity multiplier ordering

    private func checkEquipmentRarityMultipliers() -> [IdleRpgBalanceWarning] {
        let multipliers = model.equipment.rarityBonusMultipliers ?? .defaultMultipliers
        let orderedRarities: [IdleRpgRarity] = [.common, .uncommon, .rare, .epic, .legendary]
        let midpoints = orderedRarities.map { rarity -> (rarity: IdleRpgRarity, midpoint: Double) in
            let range = multipliers.range(for: rarity)
            return (rarity, (range.min + range.max) / 2)
        }

        var warnings: [IdleRpgBalanceWarning] = []
        for i in 1..<midpoints.count {
            let lower = midpoints[i - 1]
            let higher = midpoints[i]
            if higher.midpoint <= lower.midpoint {
                warnings.append(IdleRpgBalanceWarning(
                    severity: .warning,
                    system: "Equipment",
                    message: "\(higher.rarity.rawValue) multiplier midpoint (\(higher.midpoint)) does not exceed \(lower.rarity.rawValue)'s (\(lower.midpoint))"
                ))
            }
        }
        return warnings
    }

    // MARK: - 4. Companion progression

    private func checkCompanionProgression() -> [IdleRpgBalanceWarning] {
        let sorted = model.companions.catalog.sorted { $0.unlockLevel < $1.unlockLevel }
        var warnings: [IdleRpgBalanceWarning] = []
        var peak: (name: String, level: Int, total: Int)?

        for companion in sorted {
            let total = companion.passiveBonuses.reduce(0) { $0 + $1.bonus }
            if let peak, total < peak.total {
                warnings.append(IdleRpgBalanceWarning(
                    severity: .warning,
                    system: "Companions",
                    message: "\(companion.name) (unlock \(companion.unlockLevel), bonus total \(total)) is weaker than \(peak.name) (unlock \(peak.level), bonus total \(peak.total)) despite unlocking later"
                ))
            }
            if peak == nil || total > peak!.total {
                peak = (companion.name, companion.unlockLevel, total)
            }
        }
        return warnings
    }

    // MARK: - 5. Quest / Achievement reward scaling

    private func checkQuestRewardScaling() -> [IdleRpgBalanceWarning] {
        let grouped = Dictionary(grouping: model.quests.catalog, by: \.objectiveKind)
        var warnings: [IdleRpgBalanceWarning] = []

        for (_, quests) in grouped {
            let sorted = quests.sorted { $0.targetValue < $1.targetValue }
            var peak: (name: String, targetValue: Int, reward: Int)?
            for quest in sorted {
                if let peak, quest.rewardXp < peak.reward {
                    warnings.append(IdleRpgBalanceWarning(
                        severity: .warning,
                        system: "Quests",
                        message: "\(quest.name) (target \(quest.targetValue), reward \(quest.rewardXp) XP) rewards less than \(peak.name) (target \(peak.targetValue), reward \(peak.reward) XP) despite a harder target"
                    ))
                }
                if peak == nil || quest.rewardXp > peak!.reward {
                    peak = (quest.name, quest.targetValue, quest.rewardXp)
                }
            }
        }
        return warnings
    }

    private func checkAchievementRewardScaling() -> [IdleRpgBalanceWarning] {
        let grouped = Dictionary(grouping: model.achievements.catalog, by: \.objectiveKind)
        var warnings: [IdleRpgBalanceWarning] = []

        for (_, achievements) in grouped {
            let sorted = achievements.sorted { $0.targetValue < $1.targetValue }
            var peak: (name: String, targetValue: Int, reward: Int)?
            for achievement in sorted {
                if let peak, achievement.rewardAttributePoints < peak.reward {
                    warnings.append(IdleRpgBalanceWarning(
                        severity: .warning,
                        system: "Achievements",
                        message: "\(achievement.name) (target \(achievement.targetValue), reward \(achievement.rewardAttributePoints) attribute points) rewards less than \(peak.name) (target \(peak.targetValue), reward \(peak.reward) attribute points) despite a harder target"
                    ))
                }
                if peak == nil || achievement.rewardAttributePoints > peak!.reward {
                    peak = (achievement.name, achievement.targetValue, achievement.rewardAttributePoints)
                }
            }
        }
        return warnings
    }

    // MARK: - 6. Crafting consistency

    private func checkCraftingConsistency() -> [IdleRpgBalanceWarning] {
        let equipmentById = Dictionary(uniqueKeysWithValues: model.equipment.equipments.map { ($0.id, $0) })
        var warnings: [IdleRpgBalanceWarning] = []

        for recipe in model.craftingRecipes.catalog {
            guard let result = equipmentById[recipe.resultTemplateId] else { continue } // dangling id: see checkReferentialIntegrity
            let totalQuantity = recipe.requiredMaterials.reduce(0) { $0 + $1.quantity }

            switch result.rarity {
            case .epic, .legendary:
                if totalQuantity < Thresholds.craftingLowMaterialQuantity {
                    warnings.append(IdleRpgBalanceWarning(
                        severity: .warning,
                        system: "Crafting",
                        message: "\(recipe.name) produces a \(result.rarity.rawValue) item (\(result.name)) for only \(totalQuantity) total material units"
                    ))
                }
            case .common, .uncommon:
                if totalQuantity >= Thresholds.craftingHighMaterialQuantity {
                    warnings.append(IdleRpgBalanceWarning(
                        severity: .warning,
                        system: "Crafting",
                        message: "\(recipe.name) requires \(totalQuantity) total material units for a \(result.rarity.rawValue) item (\(result.name))"
                    ))
                }
            case .rare:
                break
            }
        }
        return warnings
    }

    // MARK: - 7. Referential integrity

    private func checkReferentialIntegrity() -> [IdleRpgBalanceWarning] {
        var warnings: [IdleRpgBalanceWarning] = []

        let enemyIds = Set(model.enemies.catalog.map(\.id))
        let equipmentIds = Set(model.equipment.equipments.map(\.id))
        let materialIds = Set(model.craftingMaterials.catalog.map(\.id))
        let factionIds = Set(model.factions.catalog.map(\.id))
        let slotKeys = Set(model.equipment.equipmentSlot.map(\.key))

        for adventure in model.adventures.catalog where !enemyIds.contains(adventure.enemyId) {
            warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Adventures", message: "\(adventure.name) references nonexistent enemyId \"\(adventure.enemyId)\""))
        }

        for zone in model.zones.catalog {
            for enemyId in zone.enemyIds where !enemyIds.contains(enemyId) {
                warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Zones", message: "\(zone.name) references nonexistent enemyId \"\(enemyId)\""))
            }
        }

        for recipe in model.craftingRecipes.catalog {
            if !equipmentIds.contains(recipe.resultTemplateId) {
                warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Crafting", message: "\(recipe.name) references nonexistent resultTemplateId \"\(recipe.resultTemplateId)\""))
            }
            for requirement in recipe.requiredMaterials where !materialIds.contains(requirement.materialId) {
                warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Crafting", message: "\(recipe.name) references nonexistent materialId \"\(requirement.materialId)\""))
            }
        }

        for faction in model.factions.catalog {
            if let rivalFactionId = faction.rivalFactionId, !factionIds.contains(rivalFactionId) {
                warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Factions", message: "\(faction.name) references nonexistent rivalFactionId \"\(rivalFactionId)\""))
            }
        }

        for item in model.equipment.equipments where !slotKeys.contains(item.slotKey) {
            warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Equipment", message: "\(item.name) references nonexistent slotKey \"\(item.slotKey)\""))
        }

        return warnings
    }

    // MARK: - 8. Prestige gate sanity

    private func checkPrestigeGateSanity() -> [IdleRpgBalanceWarning] {
        collectLevelGates()
            .filter { $0.level > model.prestigeConfig.requiredLevel }
            .map {
                IdleRpgBalanceWarning(
                    severity: .warning,
                    system: "Prestige",
                    message: "\($0.system) \"\($0.name)\" requires level \($0.level), which exceeds prestigeConfig.requiredLevel (\(model.prestigeConfig.requiredLevel))"
                )
            }
    }

    // MARK: - 9. Scalar sanity

    private func checkScalarSanity() -> [IdleRpgBalanceWarning] {
        var warnings: [IdleRpgBalanceWarning] = []

        if model.battle.healthPerConstitutionPoint <= 0 {
            warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Battle", message: "healthPerConstitutionPoint is \(model.battle.healthPerConstitutionPoint), expected > 0"))
        }
        if model.idleMechanics.xpPerSecond <= 0 {
            warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "IdleMechanics", message: "xpPerSecond is \(model.idleMechanics.xpPerSecond), expected > 0"))
        }
        if model.idleMechanics.maxOfflineSeconds <= 0 {
            warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "IdleMechanics", message: "maxOfflineSeconds is \(model.idleMechanics.maxOfflineSeconds), expected > 0"))
        }
        if model.factionConfig.reputationPerContribution <= 0 {
            warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Factions", message: "reputationPerContribution is \(model.factionConfig.reputationPerContribution), expected > 0"))
        }
        if model.prestigeConfig.bonusPerPrestige <= 0 {
            warnings.append(IdleRpgBalanceWarning(severity: .warning, system: "Prestige", message: "bonusPerPrestige is \(model.prestigeConfig.bonusPerPrestige), expected > 0"))
        }

        return warnings
    }
}
