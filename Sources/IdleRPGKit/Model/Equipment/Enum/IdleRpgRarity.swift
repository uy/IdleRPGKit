//
//  IdleRpgRarity.swift
//  IdleRPGKit
//
//  Created by Utku Yeğen on 6.07.2025.
//

import SwiftUI

public enum IdleRpgRarity: String, Codable {
    case common
    case uncommon
    case rare
    case epic
    case legendary
    
    public var color: Color {
        switch self {
        case .common:
            return Color.gray
        case .uncommon:
            return Color.green
        case .rare:
            return Color.blue
        case .epic:
            return Color.purple
        case .legendary:
            return Color.orange
        }
    }
    
    public var textColor: Color {
        switch self {
        case .common:
            return Color.black
        case .uncommon:
            return Color.black
        case .rare, .epic, .legendary:
            return Color.white
        }
    }
}
