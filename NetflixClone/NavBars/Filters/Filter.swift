//
//  Filter.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/21/23.
//

import Foundation

struct Filter: Identifiable, Equatable {
    var id: UUID = UUID()
    var title: String
    var selected: Bool
    let isDropdown: Bool
    
    init(
        title: String,
        selected: Bool = false,
        isDropdown: Bool = false
    ) {
        self.title = title
        self.selected = selected
        self.isDropdown = isDropdown
    }
}
