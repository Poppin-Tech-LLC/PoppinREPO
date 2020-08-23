//
//  MainView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/17/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State private var filtersAreShowing = false
    @State private var draggedOffset = CGSize.zero
    @State var menuIsShowing = false
    @State var activityIsShowing = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack(alignment: .center) {
                
                MapView(draggedOffset: $draggedOffset, menuIsShowing: $menuIsShowing, activityIsShowing: $activityIsShowing)
                    .offset(x: self.menuIsShowing ? MenuView.menuWidth + self.draggedOffset.width : self.activityIsShowing ? self.draggedOffset.width - ActivityView.activityWidth : 0.0)
                
                MenuView()
                    .frame(width: .width(percent: 100))
                    .offset(x: self.menuIsShowing ? (MenuView.menuWidth - .width(percent: 100)) + self.draggedOffset.width : -.width(percent: 100))
                    .disabled(!self.menuIsShowing)
                
                ActivityView()
                    .frame(width: .width(percent: 100))
                    .offset(x: self.activityIsShowing ?  (.width(percent: 100) - ActivityView.activityWidth) + self.draggedOffset.width : .width(percent: 100))
                    .disabled(!self.activityIsShowing)
                
//                if !loginState.state {
//                    
//                    LinearGradient(gradient: Gradient(colors: [Color(UIColor.poppinLIGHTGOLD), Color(UIColor.poppinDARKGOLD)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                        .edgesIgnoringSafeArea(.all)
//                    
//                    VStack {
//                        
//                        Spacer()
//                        Spacer()
//                        
//                        Image(uiImage: .poppinEventPopsicleIcon256)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: .width(percent: 33.0), height: .width(percent: 33.0))
//                        
//                        Spacer()
//                        Spacer()
//                        Spacer()
//                        
//                    }
//                    
//                }
                
            }
            .animation(.easeInOut(duration: 0.3))
            .gesture(DragGesture()
                
            .onChanged { value in
                
                if self.menuIsShowing {
                    
                    if value.translation.width <= 0 && value.translation.width >= -MenuView.menuWidth {
                        
                        self.draggedOffset = value.translation
                        
                    }
                    
                } else if self.activityIsShowing {
                    
                    if value.translation.width >= 0 && value.translation.width <= ActivityView.activityWidth {
                        
                        self.draggedOffset = value.translation
                        
                    }
                    
                }
                
            }
            .onEnded { value in
                
                if self.menuIsShowing {
                    
                    if value.translation.width < -100 {
                        
                        self.draggedOffset = .zero
                        self.menuIsShowing = false
                        
                    } else {
                        
                        self.draggedOffset = .zero
                        
                    }
                    
                } else if self.activityIsShowing {
                    
                    if value.translation.width > 100 {
                        
                        self.draggedOffset = .zero
                        self.activityIsShowing = false
                        
                    } else {
                        
                        self.draggedOffset = .zero
                        
                    }
                    
                }
                
                }
                
            )
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        
    }
    
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MainView()
        
    }
}
