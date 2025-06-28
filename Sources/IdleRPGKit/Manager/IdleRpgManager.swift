//
//  IdleRpgManager.swift
//  Text-Based-Idle-Game-Demo
//
//  Created by Utku Yeğen on 25.06.2025.
//

import Combine

public class IdleRpgManager: ObservableObject {
    private var baseModel: IdleRPGBaseModel
    
    @Published public var gameProgress: IdleRPGGameProgressModel
    
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
                    race: race,
                    clas: clas,
                    level: 1
                )
            )
            
            IdleRpgUserDefaults.setGameProgress(gameProgress)
        }
    }
}
