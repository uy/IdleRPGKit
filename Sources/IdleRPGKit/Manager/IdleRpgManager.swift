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
    
    private var levelingSystem: IdleRpgLevelingSystem!
    
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
        
        levelingSystem = .init(
            leveling: baseModel.leveling,
            attributePointsPerLevel: baseModel.leveling.attributePointsPerLevel
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
    }
    
    public func currentXp() -> Int {
        return gameProgress.character.currentExperience
    }
    
    public func xpToNextLevel() -> Int {
        return levelingSystem.xpToNextLevel(gameProgress.character.level)
    }
    
    public func gainXp(_ amount: Int) {
        let newExperience = gameProgress.character.currentExperience + amount
        let xpToNextLevel = xpToNextLevel()
        
        if newExperience >= xpToNextLevel {
            gameProgress.character.level += 1
            gameProgress.character.currentExperience = newExperience - xpToNextLevel
            levelUp()
        } else {
            gameProgress.character.currentExperience += amount
        }
    }
    
    private func levelUp() {
        gameProgress.character.freeAttributePoints += levelingSystem.attributePointsPerLevel
    }
}
