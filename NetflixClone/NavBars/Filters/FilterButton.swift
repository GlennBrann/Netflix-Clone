//
//  FilterButton.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/21/23.
//

import SwiftUI

struct FilterButton: View {
    private let name: String
    private var selected: Bool
    private let hasChevron: Bool
    private let onTap: () -> Void
    
    init(
        name: String,
        selected: Bool,
        hasChevron: Bool = false,
        onTap: @escaping () -> Void
    ) {
        self.name = name
        self.selected = selected
        self.hasChevron = hasChevron
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(name)
                    .font(.system(size: 14, weight: .semibold))
                
                if hasChevron {
                    Image(systemName: "chevron.down")
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(selected ? Capsule().fill(Color.white.opacity(0.4)) : Capsule().fill(.clear))
            .foregroundColor(.white.opacity(0.85))
            .overlay(
                Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.5), value: selected)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton(name: "Test", selected: false, onTap: { })
    }
}
