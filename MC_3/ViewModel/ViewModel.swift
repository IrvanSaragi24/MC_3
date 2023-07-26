//
//  ViewModel.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import Foundation

class DataApp: ObservableObject {
    @Published var nama: String {
        didSet {
            UserDefaults.standard.set(nama, forKey: "UserName")
        }
    }
    
    @Published var dataModels: [DataModel] = [
        DataModel(title: "Aku berjanji tidak phubbing"),

    ]
    @Published var isWaiting = false
    
    init() {
        // Retrieve the saved user name from UserDefaults (if any)
        self.nama = UserDefaults.standard.string(forKey: "UserName") ?? ""
    }
}

struct DataModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}


