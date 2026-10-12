//
//  IdleRpgManager.swift
//  Text-Based-Idle-Game-Demo
//
//  Created by Utku Yeğen on 25.06.2025.
//

import Foundation
import Combine

public class IdleRpgManager: ObservableObject {
    private var baseModel: IdleRPGBaseModel
    
    private var cancellables = Set<AnyCancellable>()
    @Published public var gameProgress: IdleRPGGameProgressModel
    @Published public var level: Int = 1
    @Published public var currentXP: Int = 0
    @Published public var freeAttributePoints: Int = 0
    @Published public var givenAttributePoints: [IdleRpgGivenAttributePoint] = []
    
    public var levelingSystem: IdleRpgLevelingSystem!
    public var equipmentSystem: IdleRpgEquipmentSystem!
    public var idleMechanicsSystem: IdleRpgIdleMechanicsSystem!
    public var inventorySystem: IdleRpgInventorySystem!
    public var enemySystem: IdleRpgEnemySystem!
    public var battleSystem: IdleRpgBattleSystem!

    let idleProgressEventSubject = PassthroughSubject<IdleRpgIdleProgressEvent, Never>()
    public var idleProgressEventPublisher: AnyPublisher<IdleRpgIdleProgressEvent, Never> {
        idleProgressEventSubject.eraseToAnyPublisher()
    }

    public init(
        baseModel: IdleRPGBaseModel,
        race: IdleRPGRaceModel,
        clas: IdleRPGClasModel
    ) {
        self.baseModel = baseModel
        
        if let storedProgress = IdleRpgUserDefaults.getGameProgress() {
            gameProgress = storedProgress
        } else {
            gameProgress = .init(
                character: .init(
                    attributes: baseModel.character.attributes,
                    freeAttributePoints: 0,
                    race: race,
                    clas: clas,
                    level: 1,
                    currentExperience: 0
                )
            )
            
            IdleRpgUserDefaults.setGameProgress(gameProgress)
        }
        level = gameProgress.character.level
        currentXP = gameProgress.character.currentExperience
        freeAttributePoints = gameProgress.character.freeAttributePoints

        if let storedGivenAttributePoints = IdleRpgUserDefaults.getGivenAttributePoints() {
            givenAttributePoints = storedGivenAttributePoints
        }
        
        levelingSystem = .init(
            leveling: baseModel.leveling,
            attributePointsPerLevel: baseModel.leveling.attributePointsPerLevel
        )
        equipmentSystem = .init(
            equipment: baseModel.equipment
        )
        idleMechanicsSystem = .init(
            idleMechanics: baseModel.idleMechanics
        )
        inventorySystem = .init(
            inventory: baseModel.inventory
        )
        enemySystem = .init(
            enemies: baseModel.enemies
        )
        battleSystem = .init(
            battle: baseModel.battle
        )

        gameProgress.character.$level
            .receive(on: RunLoop.main)
            .assign(to: \.level, on: self)
            .store(in: &cancellables)
        gameProgress.character.$currentExperience
            .receive(on: RunLoop.main)
            .assign(to: \.currentXP, on: self)
            .store(in: &cancellables)
        gameProgress.character.$freeAttributePoints
            .receive(on: RunLoop.main)
            .assign(to: \.freeAttributePoints, on: self)
            .store(in: &cancellables)

        // Forwards any other nested `character` change (e.g. ownedItems, equippedInstanceIds)
        // to this object's own objectWillChange, so SwiftUI views observing `IdleRpgManager`
        // re-render even for fields that aren't individually mirrored above.
        gameProgress.character.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    public func saveProgress() {
        IdleRpgUserDefaults.setGameProgress(gameProgress)
        IdleRpgUserDefaults.setGivenAttributePoints(givenAttributePoints)
    }
}
