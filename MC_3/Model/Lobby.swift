//
//  Lobby.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 18/07/23.
//

import Foundation

struct Lobby: Identifiable {
    let id = UUID()
    var name: String
    var silentDuration: Int
    var numberOfQuestion: Int
    var question: String?
    
    init(name: String, silentDuration: Int, numberOfQuestion: Int) {
        self.name = name
        self.silentDuration = silentDuration
        self.numberOfQuestion = numberOfQuestion
    }
}
