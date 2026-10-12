//
//  IdleRpgGivenAttributePoint.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 3.07.2025.
//

import Foundation

public struct IdleRpgGivenAttributePoint: Identifiable, Codable {
    public let id = UUID()
    let key: String
    var value: Int
}
