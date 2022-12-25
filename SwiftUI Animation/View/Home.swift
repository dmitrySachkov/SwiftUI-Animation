//
//  Home.swift
//  SwiftUI Animation
//
//  Created by Dmitry Sachkov on 24.12.2022.
//

import SwiftUI

struct Home: View {
    
    @State var dragOffset: CGSize = .zero
    @State var startAnimation = false
    @State var type = "Single"
    
    var body: some View {
        // MARK: Meta Ball Animation
        VStack {
            Text("MetaBall Annimation")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 25)
            
            Picker(selection: $type) {
                Text("Single")
                    .tag("Single")
                
                Text("Clubbed")
                    .tag("Clubbed")
            } label: {
                
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)

            if type == "Single" {
                singleMetaBall()
            } else {
                clubbedView()
            }
        }
    }
    
    @ViewBuilder
    func clubbedView() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [.blue, .green, .yellow, .red, .purple], startPoint: .top, endPoint: .bottom))
            .mask {
                TimelineView(.animation(minimumInterval: 3.6, paused: false)) { _ in
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.5, color: .yellow))
                        context.addFilter(.blur(radius: 30))
                        context.drawLayer { ctx in
                            for index in 1...15 {
                                if let resolvedView = context.resolveSymbol(id: index) {
                                    ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                }
                            }
                        }
                    } symbols: {
                        ForEach(1...15, id: \.self) { item in
                            let offset = (startAnimation ? CGSize(width: .random(in: -180...180), height: .random(in: -240...240)) : .zero)
                            clubbedRoundedRectangle(offset: offset)
                                .tag(item)
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                startAnimation.toggle()
            }
    }
    
    @ViewBuilder
    func clubbedRoundedRectangle(offset: CGSize) -> some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(.white)
            .frame(width: 120, height: 120)
            .offset(offset)
            .animation(.easeInOut(duration: 4), value: offset)
    }
    
    @ViewBuilder
    func singleMetaBall() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [.blue, .green, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask {
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .green))
                    context.addFilter(.blur(radius: 30))
                    context.drawLayer { ctx in
                        for index in [1,2] {
                            if let resolvedView = context.resolveSymbol(id: index) {
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                            }
                        }
                    }
                } symbols: {
                    Ball()
                        .tag(1)
                    Ball(offset: dragOffset)
                        .tag(2)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            dragOffset = .zero
                        }
                    }
            )
    }
    
    @ViewBuilder
    func Ball(offset: CGSize = .zero) -> some View {
        Circle()
            .fill(.yellow)
            .frame(width: 150, height: 150)
            .offset(offset)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
