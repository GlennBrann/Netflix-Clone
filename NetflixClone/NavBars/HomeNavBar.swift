//
//  HomeNavBar.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/21/23.
//

import SwiftUI

struct HomeNavBar: View {
    @Binding var showFilters: Bool
    @Binding var filters: [Filter]
    @Binding var showCategoryList: Bool
    @Binding var yPos: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("For Glenn")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                HStack(spacing: 18) {
                    Button(action: {}) {
                        Image(systemName: "airplayvideo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
                    
                    Button(action: {}) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.orange)
                            .frame(width: 22, height: 22)
                    }
                }
                .foregroundColor(.white)
            }
            .padding(.horizontal, !showFilters ? 16 : 12)
            .padding(.bottom, 2)
            
            if showFilters {
                FilterView(
                    filters: $filters,
                    showCategoryList: $showCategoryList
                )
                .padding(.bottom, 4)
                .transition(
                    .move(edge: .top)
                    .combined(with: .opacity)
                    .combined(with: .scale(scale: 0.9, anchor: .top))
                )
            }
        }
        .padding(8)
        .padding(.top, 70)
        .background(
            yPos <= 0 ? navBarBackground.transition(.opacity).edgesIgnoringSafeArea(.top) : nil
        )
        .frame(height: showFilters ? 120 : 72)
        .animation(.easeInOut(duration: 0.7), value: yPos)
        .animation(.easeOut(duration: 0.3), value: showFilters)
    }
    
    var navBarBackground: some View {
        Blur(style: .systemUltraThinMaterialDark)
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 6)
    }
}

struct HomeNavBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavBar(
            showFilters: .constant(false),
            filters: .constant([]),
            showCategoryList: .constant(false),
            yPos: .constant(0)
        )
    }
}
