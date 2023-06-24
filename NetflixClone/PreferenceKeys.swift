//
//  PreferenceKeys.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/21/23.
//

import Foundation
import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGRect
    static var defaultValue = CGRect.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
