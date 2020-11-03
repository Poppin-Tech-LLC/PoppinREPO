//
//  MapView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/14/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import SwiftUI
import MapKit

// Map Content View:

struct MapContentView: View {
    
    @State private var filtersAreShowing = false
    @Binding var draggedOffset: CGSize
    @Binding var menuIsShowing: Bool
    @Binding var activityIsShowing: Bool
    
    private var filtersDim: Double = 1.0
    private var menuDim: Double = 0.0
    private var activityDim: Double = 0.0
    
    private var menuButtonOpacity: Double = 1.0
    private var activityButtonOpacity: Double = 1.0
    
    init(draggedOffset: Binding<CGSize>, menuIsShowing: Binding<Bool>, activityIsShowing: Binding<Bool>) {
        
        self._menuIsShowing = menuIsShowing
        self._activityIsShowing = activityIsShowing
        self._draggedOffset = draggedOffset
        
        menuDim = 1 - Double(-self.draggedOffset.width/MenuView.menuWidth)
        
        activityDim = 1 - Double(self.draggedOffset.width/ActivityView.activityWidth)
        
        menuButtonOpacity = 1 - menuDim
        
        activityButtonOpacity = 1 - activityDim
        
    }
    
    var body: some View {
        
        ZStack {
            
            MapUI()
                .edgesIgnoringSafeArea(.all)
                .disabled(menuIsShowing || filtersAreShowing || activityIsShowing)
                .overlay(
                    
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                        .allowsHitTesting(menuIsShowing || filtersAreShowing || activityIsShowing)
                        .opacity(filtersAreShowing ? filtersDim : menuIsShowing ? menuDim : activityIsShowing ? activityDim : 0.0)
                        .gesture(TapGesture(count: 1)
                            
                                .onEnded { value in
                                    
                                    if self.menuIsShowing { self.menuIsShowing.toggle() }
                                    if self.filtersAreShowing { self.filtersAreShowing.toggle() }
                                    if self.activityIsShowing { self.activityIsShowing.toggle() }
                                    
                                }
                        
                            )
                    
                )
            
            VStack {
                
                HStack(alignment: .top, spacing: .width(percent: 3.0)) {
                    
                    Button(action: {
                        
                        withAnimation {
                            
                            if self.filtersAreShowing { self.filtersAreShowing.toggle() }
                            self.menuIsShowing.toggle()
                            
                        }
                        
                    }) {
                        Image(systemSymbol: .personFill)
                            .font(Font.custom("Octarine-Bold", size: .width(percent: 5.0)).weight(.bold))
                            .padding(.width(percent: 3.0))
                            .foregroundColor(Color(UIColor.mainDARKPURPLE))
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .buttonStyle(BouncyButtonStyle())
                    .opacity(menuIsShowing ? menuButtonOpacity : 1.0)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4.0, x: 0.0, y: 1.0)
                    
                    Button(action: {
                        // Future Action
                    }) {
                        HStack {
                            Image(systemSymbol: .magnifyingglass)
                            Text("Search...")
                            Spacer()
                        }.font(Font.custom("Octarine-Bold", size: .width(percent: 4.0)).weight(.bold))
                            .padding(.width(percent: 2.5))
                            .foregroundColor(Color.white)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(.width(percent: 3.0))
                    }
                    
                    VStack(spacing: .width(percent: 3.0)) {
                        
                        Button(action: {
                            
                            withAnimation {
                                
                                if self.filtersAreShowing { self.filtersAreShowing.toggle() }
                                self.activityIsShowing.toggle()
                                
                            }
                            
                        }) {
                            Image(systemSymbol: .flameFill)
                                .font(Font.custom("Octarine-Bold", size: .width(percent: 5.0)).weight(.bold))
                                .padding(.width(percent: 3.0))
                                .foregroundColor(Color(UIColor.mainDARKPURPLE))
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .buttonStyle(BouncyButtonStyle())
                        .shadow(color: Color.gray.opacity(0.4), radius: 4.0, x: 0.0, y: 1.0)
                        .opacity(activityIsShowing ? activityButtonOpacity : 1.0)
                        
                        if filtersAreShowing {
                        
                            FiltersViewUI(filtersAreShowing: $filtersAreShowing)
                            
                        }
                        
                        Button(action: {
                            withAnimation {
                                self.filtersAreShowing.toggle()
                            }
                        }) {
                            
                            Image(systemSymbol: .chevronDown)
                                .font(Font.custom("Octarine-Bold", size: .width(percent: 3.0)).weight(.bold))
                                .frame(width: .width(percent: 6.5), height: .width(percent: 6.5), alignment: .center)
                                .rotationEffect(.degrees(self.filtersAreShowing ? 180 : 0))
                                .foregroundColor(Color(UIColor.mainDARKPURPLE))
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .buttonStyle(BouncyButtonStyle())
                        .shadow(color: Color.gray.opacity(0.4), radius: 4.0, x: 0.0, y: 1.0)
                        .opacity(activityIsShowing ? activityButtonOpacity : 1.0)
                        
                    }
                    
                }
                .padding(.zero)
                
                Spacer()
                
                Button(action: {
                    // Future Action
                }) {
                    Image(systemSymbol: .plus)
                        .font(Font.custom("Octarine-Bold", size: .width(percent: 8.0)).weight(.bold))
                        .padding(.width(percent: 4.7))
                        .foregroundColor(Color(UIColor.mainDARKPURPLE))
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .buttonStyle(BouncyButtonStyle())
                .shadow(color: Color.gray.opacity(0.4), radius: 4.0, x: 0.0, y: 1.0)
                
            }
            .padding(.width(percent: 4.5))
            
        }
        
    }
    
}

// Map View:

struct MapUI: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
}

// Top View:

struct FiltersViewUI: View {
    
    @Binding var filtersAreShowing: Bool
    @State private var filtersState: [Bool] = [Bool](repeating: true, count: EventCategory.allCases.count)
    
    var body: some View {
        
        VStack(spacing: .width(percent: 3.5)) {
            
            Text("Filters")
                .foregroundColor(Color(UIColor.mainDARKPURPLE))
                .font(Font.custom("Octarine-Bold", size: .width(percent: 3.5)))
            
            ForEach(self.filtersState.indices) { i in
                
                Button(action: {
                    
                    self.filtersState[i].toggle()
                    
                }) {
                    
                    if self.filtersState[i] {
                        
                        Image(systemSymbol: .checkmark)
                            .font(Font.custom("Octarine-Bold", size: .width(percent: 3.0)).weight(.heavy))
                            .frame(width: .width(percent: 6.5), height: .width(percent: 6.5), alignment: .center)
                            .foregroundColor(.white)
                            .background(Color(EventCategory.allCases[i].getGradientColors()[1]))
                            .clipShape(Circle())
                        
                    } else {
                        
                        Color(EventCategory.allCases[i].getGradientColors()[1]).opacity(0.85)
                            .frame(width: .width(percent: 6.5), height: .width(percent: 6.5), alignment: .center)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    
                }
                .animation(Animation.spring().speed(2.5))
                
            }
            
        }
        .padding(EdgeInsets(top: .width(percent: 3.5), leading: .width(percent: 2.3), bottom: .width(percent: 3.5), trailing: .width(percent: 2.3)))
        .background(Color.white)
        .cornerRadius(.width(percent: 3.0))
        .shadow(color: Color.gray.opacity(0.4), radius: 4.0, x: 0.0, y: 1.0)
        .transition(.scale)
        
    }
    
}

// Bouncy Button

struct BouncyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.90 : 1)
            .scaleEffect(configuration.isPressed ? 0.90: 1)
            .animation(Animation.spring().speed(2.0))
    }
    
}
