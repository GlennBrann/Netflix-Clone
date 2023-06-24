//
//  FilterView.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/21/23.
//

import SwiftUI

struct FilterView: View {
    
    @Binding var filters: [Filter]
    @Binding var showCategoryList: Bool
    @State private var hasSelection: Bool = false
    
    var body: some View {
        HStack(spacing: 14) {
            
            if filters.contains(where: { $0.selected }) {
                Button(action: {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                        filters = originalFilters
                        hasSelection = false
                    }
                }, label: {
                    Circle()
                        .stroke(.white.opacity(0.5), lineWidth: 1)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white.opacity(0.7))
                        )
                        .contentShape(Rectangle())
                })
                .transition(.opacity)
                .buttonStyle(ScaleButtonStyle())
            }
            
            ForEach($filters) { filter in
                FilterButton(
                    name: filter.title.wrappedValue,
                    selected: filter.selected.wrappedValue,
                    onTap: {
                        if filter.selected.wrappedValue {
                            filters = originalFilters
                            return
                        }
                        
                        filter.selected.wrappedValue = !filter.selected.wrappedValue
                        
                        filters = filters.filter { $0.selected }
                        
                        if filters.contains(where: { $0.selected }) {
                            hasSelection = true
                        } else {
                            hasSelection = false
                        }
                    }
                )
            }
            
            let titleSet = Set(filters.map { $0.title })
            let originalTitleSet = Set(originalFilters.map { $0.title })
            
            if titleSet.isSubset(of: originalTitleSet) {
                if !hasSelection {
                    FilterButton(
                        name: "Categories",
                        selected: false,
                        hasChevron: true,
                        onTap: { showCategoryList = true }
                    )
                } else {
                    FilterButton(
                        name: "All Categories",
                        selected: false,
                        hasChevron: true,
                        onTap: { showCategoryList = true }
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .animation(
            .interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5),
            value: filters
        )
        .animation(
            .interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5),
            value: hasSelection
        )
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filters: .constant([]), showCategoryList: .constant(true))
    }
}
