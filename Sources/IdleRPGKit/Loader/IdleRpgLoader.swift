//
//  IdleRpgLoader.swift
//  Text-Based-Idle-Game-Demo
//
//  Created by Utku Yeğen on 25.06.2025.
//

import Foundation

public class IdleRpgLoader {
    public static func loadExampleGameData() -> IdleRPGBaseModel? {
        return loadGameData(
            from: "example_idle_rpg",
            isExample: true
        )
    }
    
    public static func loadGameData(
        from filename: String,
        isExample: Bool = false
    ) -> IdleRPGBaseModel? {
        guard
            let url = isExample
                ? Bundle.module.url(
                    forResource: filename,
                    withExtension: "json"
                )
                : Bundle.main.url(
                    forResource: filename,
                    withExtension: "json"
                )
        else {
            print("Couldn't find file: \(filename).json")
            return nil
        }

        do {
            let data = try Data(
                contentsOf: url
            )
            let decoder = JSONDecoder()
            let gameData = try decoder.decode(
                IdleRPGBaseModel.self,
                from: data
            )
            return gameData
        } catch {
            print("JSON load or read error: \(error)")
            return nil
        }
    }
}
