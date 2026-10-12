//
//  IdleRpgUserDefaults.swift
//  Text-Based-Idle-Game-Demo
//
//  Created by Utku Yeğen on 26.06.2025.
//

import Foundation

public final class IdleRpgUserDefaults {
    private enum IdleRpgUserDefaultsKeys {
        static let selectedRace = "IdleRpg_SelectedRace"
        static let selectedClas = "IdleRpg_SelectedClas"
        static let gameProgress = "IdleRpg_GameProgress"
        static let givenAttributePoints = "IdleRpg_GivenAttributePoints"
    }
    
    public static func setSelectedRace(_ race: IdleRPGRaceModel) {
        if let encodedRace = try? JSONEncoder().encode(race) {
            UserDefaults.standard.set(
                encodedRace,
                forKey: IdleRpgUserDefaultsKeys.selectedRace
            )
        }
    }
    
    public static func getSelectedRace() -> IdleRPGRaceModel? {
        guard
            let encodedRace = UserDefaults.standard.object(
                forKey: IdleRpgUserDefaultsKeys.selectedRace
            ) as? Data,
            let selectedRace = try? JSONDecoder().decode(
                IdleRPGRaceModel.self,
                from: encodedRace
            )
        else { return nil }
        
        return selectedRace
    }
    
    public static func setSelectedClas(_ clas: IdleRPGClasModel) {
        if let encodedClas = try? JSONEncoder().encode(clas) {
            UserDefaults.standard.set(
                encodedClas,
                forKey: IdleRpgUserDefaultsKeys.selectedClas
            )
        }
    }
    
    public static func getSelectedClas() -> IdleRPGClasModel? {
        guard
            let encodedClas = UserDefaults.standard.object(
                forKey: IdleRpgUserDefaultsKeys.selectedClas
            ) as? Data,
            let selectedClas = try? JSONDecoder().decode(
                IdleRPGClasModel.self,
                from: encodedClas
            )
        else { return nil }
        
        return selectedClas
    }
    
    public static func setGameProgress(_ progress: IdleRPGGameProgressModel) {
        if let encodedProgress = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(
                encodedProgress,
                forKey: IdleRpgUserDefaultsKeys.gameProgress
            )
        }
    }
    
    public static func getGameProgress() -> IdleRPGGameProgressModel? {
        guard
            let encodedProgress = UserDefaults.standard.object(
                forKey: IdleRpgUserDefaultsKeys.gameProgress
            ) as? Data,
            let gameProgress = try? JSONDecoder().decode(
                IdleRPGGameProgressModel.self,
                from: encodedProgress
            )
        else { return nil }

        return gameProgress
    }

    public static func setGivenAttributePoints(_ points: [IdleRpgGivenAttributePoint]) {
        if let encodedPoints = try? JSONEncoder().encode(points) {
            UserDefaults.standard.set(
                encodedPoints,
                forKey: IdleRpgUserDefaultsKeys.givenAttributePoints
            )
        }
    }

    public static func getGivenAttributePoints() -> [IdleRpgGivenAttributePoint]? {
        guard
            let encodedPoints = UserDefaults.standard.object(
                forKey: IdleRpgUserDefaultsKeys.givenAttributePoints
            ) as? Data,
            let points = try? JSONDecoder().decode(
                [IdleRpgGivenAttributePoint].self,
                from: encodedPoints
            )
        else { return nil }

        return points
    }
}
