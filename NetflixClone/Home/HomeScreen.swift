//
//  ContentView.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/16/23.
//

import SwiftUI

let originalFilters = [
    Filter(title: "TV Shows"),
    Filter(title: "Movies")
]

struct HomeScreen: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var yPos: Double = 0.0
    @State private var showFilters: Bool = true
    @Binding var showCategoryList: Bool
    @Binding var currentSelectedMedia: String?
    
    @State private var backgroundColor: Color = .clear
    @State private var showsSelected: Bool = false
    
    @Binding var filters: [Filter]
    let mediaAnimation: Namespace.ID
    
    let mediaSelected: (String) -> Void
    
    var body: some View {
//        NavigationView {
            ZStack(alignment: .top) {
                GradientBackground(backgroundColor: $backgroundColor, yPos: $yPos)
                    .edgesIgnoringSafeArea(.all)
                
                HomeContentList(
                    backgroundColor: $backgroundColor,
                    showsSelected: $showsSelected,
                    showFilters: $showFilters,
                    filters: $filters,
                    yPos: $yPos,
                    mediaAnimation: mediaAnimation,
                    mediaSelected: mediaSelected
                )
                
                HomeNavBar(
                    showFilters: $showFilters,
                    filters: $filters,
                    showCategoryList: $showCategoryList,
                    yPos: $yPos
                )
//                .padding(.top, 70)
            }
//            .navigationBarHidden(true)
            .tint(.white)
            .edgesIgnoringSafeArea(.bottom)
//        }
    }
}

struct HomeContentList: View {
    
    @ObservedObject private var motionManager = MotionManager()
    @State private var prevScrollValue: Double = 0.0
    
    private let avatar = UIImage(named: "avatar")
    private let seventiesShow = UIImage(named: "70sShow")
    
    @Binding var backgroundColor: Color
    @Binding var showsSelected: Bool
    @Binding var showFilters: Bool
    @Binding var filters: [Filter]
    @Binding var yPos: Double
    
    let mediaAnimation: Namespace.ID
    let mediaSelected: (String) -> Void
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 128)
            VStack {
                Image(uiImage: showsSelected ? seventiesShow! : avatar!)
                    .resizable()
                    .frame(height: 500)
                    .cornerRadius(12)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                    .padding(24)
                    .shadow(color: .black.opacity(0.15), radius: 4)
                    .modifier(ParallaxMotionModifier(manager: motionManager, magnitude: 16))
                
                MovieHStack(
                    title: "Released in the Past Year",
                    mediaAnimation: mediaAnimation,
                    onItemSelected: mediaSelected)
                
                MovieHStack(
                    title: "TV Shows",
                    mediaAnimation: mediaAnimation,
                    onItemSelected: mediaSelected
                )
                
                MovieHStack(
                    title: "Trending Now",
                    mediaAnimation: mediaAnimation,
                    onItemSelected: mediaSelected
                )
                
                MovieHStack(
                    title: "New Releases",
                    mediaAnimation: mediaAnimation,
                    onItemSelected: mediaSelected)
                
                MovieHStack(
                    title: "Comedies",
                    mediaAnimation: mediaAnimation,
                    onItemSelected: mediaSelected
                )
                
                MovieHStack(
                    title: "Test 1",
                    mediaAnimation: mediaAnimation,
                    onItemSelected: mediaSelected
                )
                
                MovieHStack(
                    title: "Test 2",
                    mediaAnimation: mediaAnimation,
                    onItemSelected: mediaSelected
                )
                
                MovieHStack(
                    title: "Test 3",
                    mediaAnimation: mediaAnimation,
                    onItemSelected: mediaSelected
                )
                
                Spacer().frame(height: 72)
            }
            .background(
                GeometryReader { proxy in
                    let offset = proxy.frame(in: .named("scroll"))
                    Color.clear.preference(key: ViewOffsetKey.self, value: offset)
                }
            )
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ViewOffsetKey.self) { value in
            yPos = value.minY
            
            guard yPos <= 105 else { return }
            if prevScrollValue > value.midY {
                withAnimation {
                    if showFilters {
                        showFilters = false
                    }
                }
            } else if prevScrollValue < value.midY {
                withAnimation {
                    if !showFilters {
                        showFilters = true
                    }
                }
            }
            prevScrollValue = value.midY
        }
        .onChange(of: filters) { filters in
            if filters.count == 1, filters.contains(where: { $0.title == "TV Shows" }) {
                showsSelected = true
                let uiColor = seventiesShow?.averageColor ?? .black
                backgroundColor = Color(uiColor)
            } else {
                showsSelected = false
                let uiColor = avatar?.averageColor ?? .black
                backgroundColor = Color(uiColor)
            }
        }
        .onAppear {
            let uiColor = avatar?.averageColor ?? .black
            backgroundColor = Color(uiColor)
        }
        .animation(.easeInOut(duration: 1), value: backgroundColor)
        .animation(.easeInOut(duration: 0.5), value: showsSelected)
    }
}

struct GradientBackground: View {
    
    @Binding var backgroundColor: Color
    @Binding var yPos: Double
    
    var body: some View {
        Color.black.edgesIgnoringSafeArea(.all)
        
        LinearGradient(
            colors: [backgroundColor.opacity(
                gradientScale(
                    inMin: 70,
                    inMax: -520,
                    outMin: 0.9,
                    outMax: 0.0,
                    value: yPos
                )
            ), .black],
            startPoint: UnitPoint(x: 0.5, y: 0.75), endPoint: .bottom
        )
    }
    
    func gradientScale(
        inMin: Double,
        inMax: Double,
        outMin: Double,
        outMax: Double,
        value: Double
    ) -> Double {
        outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin)
    }
}

struct MovieHStack: View {
    let title: String
    let mediaAnimation: Namespace.ID
    let onItemSelected: (String) -> Void
    
    @State private var isHidden = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0 ..< 15) { item in
                        Button(action: {
                            onItemSelected("media\(title)-\(item)")
                        }) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.35))
                                .matchedGeometryEffect(
                                    id: "media\(title)-\(item)", in: mediaAnimation
                                )
                                .frame(width: 106, height: 156)
                        }
                        .buttonStyle(CardScaleButtonStyle())
                    }
                }
            }
        }
        .padding(10)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreen(
//            showCategoryList: .constant(false),
//            filters: .constant([]),
//            mediaAnimation: mediaAnimation,
//            mediaSelected: { _ in }
//        )
//    }
//}
