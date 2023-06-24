//
//  TabsContainer.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/21/23.
//

import SwiftUI

struct TabsContainer: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var showCategoryList: Bool = false
    @State private var filters: [Filter] = [
        Filter(title: "TV Shows"),
        Filter(title: "Movies")
    ]
    @State private var mediaSelected: String?
    @Namespace private var mediaAnimation
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            HomeScreen(
                showCategoryList: $showCategoryList,
                currentSelectedMedia: $mediaSelected,
                filters: $filters,
                mediaAnimation: mediaAnimation,
                mediaSelected: {
//                    print("GB> \($0)")
                    mediaSelected = $0
                }
            )
            .cornerRadius(mediaSelected != nil ? 8 : 0)
//            .cornerRadius(mediaSelected != nil ? 8 : 0, corners: [.topLeft, .])
            .scaleEffect(mediaSelected != nil ? 0.95 : 1)
            .edgesIgnoringSafeArea(.top)
        }
        .overlay(bottomNav, alignment: .bottom)
        .overlay(categoriesOverlay)
        .overlay(selectedMediaOverlay)
        .animation(.easeIn(duration: 0.15), value: showCategoryList)
        .animation(
            .easeInOut(duration: 0.4),
            value: mediaSelected
        )
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var selectedMediaOverlay: some View {
        mediaSelected != nil ?
        Blur(style: .systemUltraThinMaterialDark)
            .edgesIgnoringSafeArea(.all)
            .overlay(
//                RoundedRectangle(cornerRadius: 6)
//                    .fill(Color("charcoal"))
                MediaView(
                    mediaSelected: $mediaSelected,
                    mediaAnimation: mediaAnimation
                )
            )
            .onTapGesture { mediaSelected = nil }
        : nil
        
        
//        RoundedRectangle(cornerRadius: 4)
//            .fill(Color.white.opacity(0.35))
//            .edgesIgnoringSafeArea(.all)
    }
    
    struct MediaView: View {
        @Binding var mediaSelected: String?
        let mediaAnimation: Namespace.ID
        
        @State private var offset = CGSize.zero
        
        @State private var backgroundColor: Color = Color.white.opacity(0.35)
        
        var body: some View {
            if let mediaSelected {
                RoundedRectangle(cornerRadius: 6)
                    .fill(backgroundColor)
                    .matchedGeometryEffect(id: mediaSelected, in: mediaAnimation)
//                    .rotationEffect(.degrees(Double(offset.width / 5)))
                    .offset(x: offset.width, y: offset.height)
                    //.opacity(2 - Double(abs(offset.width / 50)))
                    .animation(.interactiveSpring(), value: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                                print("GB> \(offset)")
                            }
                            .onEnded { _ in
                                if abs(offset.width) > 100 || abs(offset.height) > 100 {
                                    // remove the card
                                    self.mediaSelected = nil
                                } else {
                                    offset = .zero
                                }
                            }
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            backgroundColor = Color("charcoal")
                        }
                    }
                    .animation(.easeOut(duration: 0.33), value: backgroundColor)
            }
        }
    }
    
    var categoriesOverlay: some View {
        showCategoryList ? CategoryList(
            onSelection: { category in
                showCategoryList = false
                
                var newFilters = filters.filter { $0.selected }
                newFilters = newFilters.compactMap { filter in
                    var filter = filter
                    filter.selected = false
                    return filter
                }
                newFilters.append(
                    Filter(
                        title: category,
                        selected: true
                    )
                )
                filters = newFilters
            },
            onClose: { showCategoryList = false }
        ).transition(.opacity) : nil
    }
    
    var bottomNav: some View {
        HStack(spacing: 8) {
            Spacer()
            TabButton(title: "Home", imageName: "house.fill")
            Spacer()
            TabButton(title: "New & Hot", imageName: "play.rectangle.on.rectangle")
            Spacer()
            TabButton(title: "Fast Laughs", imageName: "face.smiling")
            Spacer()
            TabButton(title: "Downloads", imageName: "arrow.down.circle")
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.bottom, 30)
        .background(Blur(style: .systemMaterialDark))
        .frame(height: 80)
    }
}

struct TabButton: View {
    let title: String
    let imageName: String
    
    var body: some View {
        Button(action: { }) {
            VStack(spacing: 4) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.caption2)
            }
            .padding(8)
        }
    }
}

struct TabsContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabsContainer()
    }
}

extension View {
    @ViewBuilder
    func scaleAndRound(_ selected: Binding<Int?>) -> some View {
        if let _ = selected.wrappedValue {
            self
                .cornerRadius(8)
                .scaleEffect(0.95)
        } else {
            self
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
