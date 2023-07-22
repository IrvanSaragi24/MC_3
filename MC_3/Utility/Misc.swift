//
//  Misc.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 20/07/23.
// Put all your constants and enum here

import Foundation

enum MCConstants {
    static let service = "Dra9on" // bonjour limit: 15 char
}

enum LobbyRole: CaseIterable {
    case host
    case guest
    case noLobbyRole
}

enum GameRole: CaseIterable {
    case judge
    case asked
    case noGameRole
}

enum ConnectionStatus {
    case connected
    case discovered
    
    var stringValue: String {
        switch self {
        case .connected:
            return "connected"
        case .discovered:
            return "discovered"
        }
    }
}

enum GameState {
    case waitingForInvitation
    case waitingToStart
    case listening
}
