//
//  IdleRpgLevelingSystem.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 30.06.2025.
//

import Foundation

struct IdleRpgLevelingSystem {
    private var formulaParameters: IdleRPGLevelingFormulaParameters
    
    init(
        leveling model: IdleRPGLevelingModel
    ) {
        self.formulaParameters = model.formulaParameters
    }
    
    func xpToNextLevel(_ level: Int) -> Int {
        return formulaParameters.baseExperience * Int((pow(Double(level), formulaParameters.baseOfMultiplier)))
    }
}
