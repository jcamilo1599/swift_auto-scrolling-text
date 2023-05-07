//
//  ContentView.swift
//  AutoScrollingText
//
//  Created by Juan Camilo Marín Ochoa on 7/05/23.
//

import SwiftUI

struct ContentView: View {
    private let title: String
    
    @State private var showText: Bool = true
    @State private var runAnimation: Bool = false
    
    // Posición actual del scroll
    @State private var scrollPosition: CGFloat = 0.0
    
    // Tamaño de desplazamiento (del scroll) del contenedor
    @State private var scrollViewContentSize: CGSize = .zero
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: true) {
                Text(title)
                    .lineLimit(1)
                    .offset(x: self.scrollPosition)
                    .opacity(showText ? 1 : 0)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(
                        GeometryReader { innerGeometry in
                            Color.clear
                                .preference(key: ScrollViewSizeKey.self, value: innerGeometry.size)
                        }
                    )
                    .onPreferenceChange(ScrollViewSizeKey.self) { size in
                        scrollViewContentSize = size
                    }
            }
            .coordinateSpace(name: "scroll")
            .disabled(true) // deshabilita el desplazamiento manual del usuario
            .onAppear {
                var timer: Timer?
                
                timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                    withAnimation {
                        if scrollPosition < -scrollViewContentSize.width {
                            showText = false
                            runAnimation = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                scrollPosition = 0.0
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showText = true
                                    }
                                }
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    runAnimation = true
                                }
                            }
                        } else {
                            if runAnimation {
                                scrollPosition -= 1
                            }
                        }
                    }
                }
                
                RunLoop.current.add(timer!, forMode: .common)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    runAnimation = true
                }
            }
        }
    }
}

struct ScrollViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ScrollViewOffsetKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(title: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
    }
}
