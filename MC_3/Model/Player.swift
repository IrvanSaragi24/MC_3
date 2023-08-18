//
//  Player.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 17/07/23.
//

import Foundation

class PlayerData: ObservableObject {
    @Published var mainPlayer: Player
    @Published var playerList: [Player] = []

    init(mainPlayer: Player, playerList: [Player]) {
        self.mainPlayer = mainPlayer
        self.playerList = playerList
    }
}

struct Player: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var lobbyRole: LobbyRole
    var gameRole: GameRole
}
