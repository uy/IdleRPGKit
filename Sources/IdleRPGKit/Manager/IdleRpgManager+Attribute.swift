//
//  IdleRpgManager+Attribute.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 5.07.2025.
//

extension IdleRpgManager {
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
        gameProgress.character.freeAttributePoints += givenAttributePoints.reduce(0) { $0 + $1.value }
        givenAttributePoints.removeAll()
        IdleRpgUserDefaults.setGivenAttributePoints(givenAttributePoints)
    }

    public func saveGivenAttributePoints() {
        guard !givenAttributePoints.isEmpty else { return }
        givenAttributePoints.forEach { givenAttributePoint in
            if let index = gameProgress.character.attributes.firstIndex(where: { $0.key == givenAttributePoint.key }) {
                gameProgress.character.attributes[index].attribute += givenAttributePoint.value
            }
        }
        givenAttributePoints.removeAll()
        IdleRpgUserDefaults.setGivenAttributePoints(givenAttributePoints)
    }
}
