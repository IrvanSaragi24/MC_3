//
//  Misc.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 20/07/23.
// Put all your constants and enum here

import Foundation
import SwiftUI

enum MCConstants {
    static let service = "Dra9on" // bonjour limit: 15 char
}

enum MsgCommandConstant {
    static let startListen = "START LISTEN"
    static let updateIsChoosingViewTrue = "ISCHOOSING TRUE"
    static let updateIsChoosingViewFalse = "ISCHOOSING FALSE"
    static let disconnect = "DISCONNECT FROM MY SESSION"
    static let updatePlayerTrue = "PLAYER TRUE"
    static let updatePlayerFalse = "PLAYER FALSE"
    static let updateCurrentTotalPlayer = "UPDATE TOTAL PLAYER"
    static let voteYes = "VOTE YES"
    static let voteNo = "VOTE NO"
    static let updateIsResultViewTrue = "ISRESULTVIEW TRUE"
    static let updateIsResultViewFalse = "ISRESULTVIEW FALSE"
    static let updateIsEndViewTrue = "ISENDVIEW TRUE"
    static let updateIsEndViewFalse = "ISENDVIEW FALSE"
    static let updateIsWinTrue = "ISWIN TRUE"
    static let updateIsWinFalse = "ISWIN FALSE"
    static let updateCurrentPlayer = "[PLAYER]"
    static let resetAllVarToDefault = "RESETALLVARTODEFAULT"
    static let resetGame = "RESETGAME"
}

enum LobbyRole: CaseIterable {
    case host
    case guest
    case noLobbyRole
}

enum GameRole: CaseIterable {
    case referee
    case asked
}

enum ConnectionStatus {
    case connected
    case discovered
    
    var stringValue: String {
        switch self {
        case .connected:
            return "Joined"
        case .discovered:
            return "Waiting"
        }
    }
    
    var circleColor: Color {
            switch self {
            case .connected:
                return .green
            case .discovered:
                return .red
            }
        }
    
    var BackgroundColor: Color {
            switch self {
            case .connected:
                return Color("Second")
            case .discovered:
                return Color("Background")
            }
        }
    var TextColor: Color {
            switch self {
            case .connected:
                return Color("Background")
            case .discovered:
                return Color("Second")
            }
        }
    
    var ImageButtonAdd: String {
            switch self {
            case .connected:
                return "person.fill.badge.minus"
            case .discovered:
                return "person.fill.badge.plus"
            }
        }
}

enum GameState {
    case waitingForInvitation
    case waitingToStart
    case listening
    case choosingPlayer
    case result
    case reset
}

enum VoteStatus: String {
    case yes = "Yes"
    case no = "No"
    case null = "Null"
}
