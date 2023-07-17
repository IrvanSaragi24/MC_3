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
}

struct Player: Identifiable {
    let id = UUID()
    let name: String
    let role: Role
}
