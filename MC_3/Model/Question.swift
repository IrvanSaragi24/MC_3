//
//  Question.swift
//  RecordAndClassify
//
//  Created by Hanifah BN on 23/07/23.
//

import Foundation

struct Question: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case text
    }
    
    var id = UUID()
    var text: String
}
