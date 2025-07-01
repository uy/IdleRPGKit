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
    
    private var xpCache: [Int: Int] = [:]
    mutating func xpToNextLevel(_ level: Int) -> Int {
        if let cached = xpCache[level] {
            return cached
        }

        let result = Int(Double(formulaParameters.baseExperience) * pow(Double(formulaParameters.baseOfMultiplier), Double(level)))
        xpCache[level] = result
        return result
    }
}
