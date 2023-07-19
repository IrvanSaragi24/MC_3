//
//  Player.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 17/07/23.
//

import Foundation

enum Role: CaseIterable {
    case host
    case guest
    case noRole
}

class PlayerData: ObservableObject {
    @Published var mainPlayer: Player
    @Published var playerList: [Player] = []
    
    init(mainPlayer: Player, playerList: [Player]) {
        self.mainPlayer = mainPlayer
        self.playerList = playerList
    }
}

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var role: Role
}
