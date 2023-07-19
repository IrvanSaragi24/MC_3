//
//  Lobby.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import Foundation

class LobbyList: ObservableObject {
    @Published var lobbies: [Lobby] = []
}

struct Lobby: Codable, Identifiable {
    var id = UUID()
    let name: String
    let date: Date
    let silentDuration: Int
    
    init(name: String, date: Date, silentDuration: Int) {
        self.name = name
        self.date = date
        self.silentDuration = silentDuration
    }
    
    func data() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
