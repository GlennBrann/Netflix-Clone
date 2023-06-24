//
//  CategoryList.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/18/23.
//

import Foundation
import SwiftUI

struct CategoryList: View {
    
    @State private var categories: [(String, Bool)] = [
        ("My List", false),
        ("Available for Download", false),
        ("Action", false),
        ("Anime", false),
        ("Black Stories", false),
        ("Comedies", false),
        ("Crime", false),
        ("Critically Acclaimed", false),
        ("Documentaries", false),
        ("Dramas", false),
        ("Fantasy", false),
        ("Fitness", false),
        ("Horror", false),
        ("Independent", false),
        ("International", false),
        ("Kids & Family", false),
        ("LGBTQ", false),
        ("Mustic & Musicals", false),
        ("Reality", false),
        ("Romance", false),
        ("Sci-Fi", false),
        ("Stand-Up", false),
        ("Thrillers", false),
        ("Audio Description", false)
    ]
    
    let onSelection: (String) -> Void
    let onClose: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 40) {
                Spacer().frame(height: 44)
                ForEach($categories, id: \.0) { category in
                    let selected = category.1.wrappedValue
                    Text(category.0.wrappedValue)
                        .font(
                            .system(size: selected ? 22 : 18, weight: selected ? .bold : .medium)
                        )
                        .foregroundColor(selected ? .white : .white.opacity(0.8))
                        .onTapGesture {
                            category.1.wrappedValue = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onSelection(category.0.wrappedValue)
                            }
                        }
                }
                Spacer().frame(height: 150)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .background(Blur(style: .systemUltraThinMaterialDark).edgesIgnoringSafeArea(.all))
        .overlay(
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                .frame(height: 100),
            alignment: .bottom
        )
        .overlay(closeButton, alignment: .bottom)
    }
    
    var closeButton: some View {
        Button(action: onClose) {
            Circle().fill(.white)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                )
        }
        .buttonStyle(.plain)
        .padding(44)
    }
}
