//
//  ViewModel.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import Foundation

class DataApp: ObservableObject {
    @Published var nama: String = "" 
    @Published var dataModels: [DataModel] = [
        DataModel(title: "Aku berjanji tidak phubbing"),

    ]
}

struct DataModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}


