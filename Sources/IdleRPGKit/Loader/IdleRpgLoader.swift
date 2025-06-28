//
//  IdleRpgLoader.swift
//  Text-Based-Idle-Game-Demo
//
//  Created by Utku Yeğen on 25.06.2025.
//

import Foundation

public class IdleRpgLoader {
    public static func loadExampleGameData() -> IdleRPGBaseModel? {
        guard
            let url = Bundle.module.url(
                forResource: "example_idle_rpg",
                withExtension: "json"
            )
        else {
            return nil
        }
        
        return load(file: url)
    }
    
    public static func loadGameData(
        from filename: String
    ) -> IdleRPGBaseModel? {
        guard
            let url = Bundle.main.url(
                forResource: filename,
                withExtension: "json"
            )
        else {
            print("Couldn't find file: \(filename).json")
            return nil
        }
        
        return load(file: url)
    }
    
    static func load(file from: URL) -> IdleRPGBaseModel? {
        do {
            let data = try Data(
                contentsOf: from
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
