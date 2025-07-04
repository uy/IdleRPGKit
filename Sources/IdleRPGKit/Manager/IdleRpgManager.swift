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
    @Published private var givenAttributePoints: [IdleRpgGivenAttributePoint] = []
    
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
        var expToNextLevel = xpToNextLevel()
        if amount <= expToNextLevel {
            let newExperience = gameProgress.character.currentExperience + amount
            
            if newExperience >= expToNextLevel {
                gameProgress.character.level += 1
                gameProgress.character.currentExperience = newExperience - expToNextLevel
                levelUp()
            } else {
                gameProgress.character.currentExperience += amount
            }
        } else {
            var expToGive = amount
            
            while expToGive > 0 {
                expToNextLevel = xpToNextLevel()
                
                gameProgress.character.level += 1
                levelUp()
                
                let diff = expToGive - expToNextLevel
                if diff < xpToNextLevel() {
                    gameProgress.character.currentExperience = diff
                    expToGive = 0
                } else {
                    expToGive = diff
                }
            }
        }
    }
    
    private func levelUp() {
        gameProgress.character.freeAttributePoints += levelingSystem.attributePointsPerLevel
    }
    
    public func giveAttribute(to key: String) {
        if let index = givenAttributePoints.firstIndex(where: { $0.key == key }) {
            givenAttributePoints[index].value += 1
        } else {
            givenAttributePoints.append(IdleRpgGivenAttributePoint(key: key, value: 1))
        }
        
        gameProgress.character.freeAttributePoints -= 1
    }
    
    public func removeAttribute(from key: String) {
        guard let index = givenAttributePoints.firstIndex(where: { $0.key == key }) else { return }

        if givenAttributePoints[index].value > 1 {
            givenAttributePoints[index].value -= 1
        } else {
            givenAttributePoints.remove(at: index)
        }
        
        gameProgress.character.freeAttributePoints += 1
    }
    
    public func givenAttributePoint(for key: String) -> Int? {
        return givenAttributePoints.first(where: { $0.key == key })?.value
    }
    
    public func discardGivenAttributePoints() {
        guard !givenAttributePoints.isEmpty else { return }
        gameProgress.character.freeAttributePoints = givenAttributePoints.count
        givenAttributePoints.removeAll()
    }
    
    public func saveGivenAttributePoints() {
        guard !givenAttributePoints.isEmpty else { return }
        givenAttributePoints.forEach { givenAttributePoint in
            if let index = gameProgress.character.attributes.firstIndex(where: { $0.key == givenAttributePoint.key }) {
                gameProgress.character.attributes[index].attribute += givenAttributePoint.value
            }
        }
        givenAttributePoints.removeAll()
    }
}
