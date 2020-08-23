//
//  MenuView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/16/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    
    let followersFont: UIFont = UIFont.dynamicFont(with: "Octarine-Light", style: .footnote)
    let followersCountFont: UIFont = UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)
    static let menuWidth: CGFloat = .width(percent: 87)
    
    var body: some View {
        
        ZStack (alignment: .trailing) {
            
            Color(UIColor.mainDARKPURPLE).edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 0.0) {
                
                VStack (alignment: .leading) {
                    
                    UserView()
                        .padding(EdgeInsets(top: 0.0, leading: .width(percent: 1.0), bottom: 0.0, trailing: .width(percent: 1.0)))
                    
                    Spacer(minLength: .width(percent: 4.0))
                    
                    HStack(spacing: .width(percent: 4.0)) {
                        
                        Button(action: {
                            // Future Action
                        }) {
                            Text("123")
                                .lineLimit(1)
                                .foregroundColor(Color(UIColor.white))
                                .font(Font(followersCountFont))
                            Text("Following")
                                .lineLimit(1)
                                .foregroundColor(Color(UIColor.white))
                                .font(Font(followersFont))
                        }
                        
                        Button(action: {
                            // Future Action
                        }) {
                            Text("1390")
                                .lineLimit(1)
                                .foregroundColor(Color(UIColor.white))
                                .font(Font(followersCountFont))
                            Text("Followers")
                                .lineLimit(1)
                                .foregroundColor(Color(UIColor.white))
                                .font(Font(followersFont))
                        }
                        
                    }
                    .padding(EdgeInsets(top: 0.0, leading: 4.0, bottom: 0.0, trailing: 4.0))
                    
                    Spacer(minLength: .width(percent: 5.0))
                    
                    BorderView()
                    
                    Spacer(minLength: 0.0)
                    
                    MenuButtons()
                    
                    Spacer()
                    
                }
                .padding(EdgeInsets(top: .width(percent: 5.0), leading: .width(percent: 7.0), bottom: .width(percent: 5.0), trailing: .width(percent: 7.0)))
                .frame(width: MenuView.menuWidth)
                
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: .width(percent: 0.5))
                    .edgesIgnoringSafeArea([.bottom, .top])
                
            }
            
        }
        
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

// User View:

struct UserView: View {

    @State private var fullName = "Manuel Martin"
    @State private var username = "@mrchoperino"
    
    let pictureFont: UIFont = UIFont.dynamicFont(with: "Octarine-Bold", style: .title1)
    let fullNameFont: UIFont = UIFont.dynamicFont(with: "Octarine-Bold", style: .headline)
    let usernameFont: UIFont = UIFont.dynamicFont(with: "Octarine-Light", style: .footnote)

    var body: some View {
        
        HStack (spacing: .width(percent: 1.5)) {
            
            VStack (alignment: .leading, spacing: .width(percent: 1.5)) {
                
                Button(action: {
                    // Future Action
                }) {
                    Text(self.fullName)
                        .lineLimit(1)
                        .foregroundColor(Color(UIColor.white))
                        .font(Font(fullNameFont))
                    
                }
                
                Button(action: {
                    // Future Action
                }) {
                    Text(self.username)
                        .lineLimit(1)
                        .foregroundColor(Color(UIColor.white))
                        .font(Font(usernameFont))
                }
                
            }
            
            Spacer()
            
            Button(action: {
                // Future Action
            }) {
                Image(systemSymbol: .personFill)
                    .font(Font(pictureFont).weight(.bold))
                    .frame(width: pictureFont.pointSize + .width(percent: 6.0), height: pictureFont.pointSize + .width(percent: 6.0))
                    .foregroundColor(Color(UIColor.mainDARKPURPLE))
                    .background(Color(UIColor.poppinLIGHTGOLD))
                    .clipShape(Circle())
            }
            .shadow(color: Color.gray.opacity(0.4), radius: 4.0, x: 0.0, y: 1.0)
            
        }
        
    }

}

// Border View:

struct BorderView: View {
    
    var body: some View {
        
        HStack (spacing: .width(percent: 2.0)) {
            
            Rectangle()
                .foregroundColor(.white)
                .frame(height: .width(percent: 0.5))
                .cornerRadius(.width(percent: 0.5))
            
            Circle()
                .foregroundColor(.white)
                .frame(width: .width(percent: 2.0), height: .width(percent: 2.0))
            
            Rectangle()
                .foregroundColor(.white)
                .frame(height: .width(percent: 0.5))
                .cornerRadius(.width(percent: 0.5))
            
        }
        
    }
    
}

// Menu Buttons:

struct MenuButtons: View {
    
    let menuButtonFont: UIFont = UIFont.dynamicFont(with: "Octarine-Bold", style: .headline)
    
    var body: some View {
        
        ScrollView {
            
            VStack (spacing: .width(percent: 4.5)) {
                
                Button(action: {
                    // Future Action
                }) {
                    HStack(spacing: .width(percent: 4.5)) {
                        Image(systemSymbol: .clockFill)
                        Text("RSVP List")
                        Spacer()
                    }
                    .padding(EdgeInsets(top: .width(percent: 6.0), leading: .width(percent: 2.0), bottom: .width(percent: 2.0), trailing: .width(percent: 2.0)))
                    .font(Font(menuButtonFont).weight(.bold))
                    .foregroundColor(Color.white)
                }
                
                Button(action: {
                    // Future Action
                }) {
                    HStack(spacing: .width(percent: 4.5)) {
                        Image(systemSymbol: .starCircleFill)
                        Text("Subscription")
                        Spacer()
                    }
                    .padding(.width(percent: 2.0))
                    .font(Font(menuButtonFont).weight(.bold))
                    .foregroundColor(Color.white)
                }
                
                Button(action: {
                    // Future Action
                }) {
                    HStack(spacing: .width(percent: 4.5)) {
                        Image(systemSymbol: .gear)
                        Text("Settings")
                        Spacer()
                    }
                    .padding(.width(percent: 2.0))
                    .font(Font(menuButtonFont).weight(.bold))
                    .foregroundColor(Color.white)
                }
                
                Button(action: {
                    // Future Action
                }) {
                    HStack(spacing: .width(percent: 4.5)) {
                        Image(systemSymbol: .questionmarkCircleFill)
                        Text("Help")
                        Spacer()
                    }
                    .padding(.width(percent: 2.0))
                    .font(Font(menuButtonFont).weight(.bold))
                    .foregroundColor(Color.white)
                }
                
                Button(action: {
                    // Future Action
                }) {
                    HStack(spacing: .width(percent: 4.5)) {
                        Image(systemSymbol: .personBadgeMinusFill)
                            .offset(CGSize(width: 0.0, height: .width(percent: 1.0)))
                        Text("Logout")
                        Spacer()
                    }
                    .padding(.width(percent: 2.0))
                    .font(Font(menuButtonFont).weight(.bold))
                    .foregroundColor(Color.white)
                }
                
            }
            
        }
        
    }
    
}

