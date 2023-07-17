//
//  ViewModel.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import Foundation

class DataApp: ObservableObject {
    @Published var nama: String = "" // Provide an initializer or default value
    @Published var dataModels: [DataModel] = [
        DataModel(title: "Aku berjanji tidak phubbing"),
//        DataModel(title: "Aku berjanji tidak phubbing2"),
//        DataModel(title: "Aku berjanji tidak phubbing3"),
//        DataModel(title: "Aku berjanji tidak phubbing4")
    ]
}

struct DataModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}


