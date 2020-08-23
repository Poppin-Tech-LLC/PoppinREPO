//
//  StartViewUI.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/17/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import SwiftUI

struct StartViewUI: View {
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color(UIColor.poppinLIGHTGOLD), Color(UIColor.poppinDARKGOLD)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("poppin")
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .font(Font(UIFont.dynamicFont(with: "Octarine-Bold", style: .title1)))
                        .frame(maxWidth: .infinity)
                        .padding(.top, .width(percent: 4.5))
                    
                    Spacer()

                    Image(uiImage: .poppinEventPopsicleIcon256)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .width(percent: 33.0), height: .width(percent: 33.0))
                    
                    Spacer()
                    
                    VStack(spacing: .width(percent: 4.0)) {
                        
                        Button(action: {

                            // Future Action

                        }) {

                            Text("Log In")
                                .padding(.vertical, .width(percent: 3.5))
                                .frame(maxWidth: .infinity)
                                .font(Font(UIFont.dynamicFont(with: "Octarine-Bold", style: .title3)))
                                .lineLimit(1)
                                .foregroundColor(Color(UIColor.mainDARKPURPLE))
                                .background(Color.white)
                                .cornerRadius(.width(percent: 3.0))
                                .padding(.horizontal, .width(percent: 4.0))

                        }
                        .buttonStyle(BouncyButtonStyle())
                        .shadow(color: Color.gray.opacity(0.4), radius: 4.0, x: 0.0, y: 1.0)
                        
                        Button(action: {
                            
                            // Future Action
                            
                        }) {
                            
                            Text("Sign Up")
                                .padding(.vertical, .width(percent: 3.5))
                                .frame(maxWidth: .infinity)
                                .font(Font(UIFont.dynamicFont(with: "Octarine-Bold", style: .title3)))
                                .lineLimit(1)
                                .foregroundColor(Color(UIColor.mainDARKPURPLE))
                                .background(Color.white)
                                .cornerRadius(.width(percent: 3.0))
                                .padding(.horizontal, .width(percent: 4.0))
                            
                        }
                        .buttonStyle(BouncyButtonStyle())
                        .shadow(color: Color.gray.opacity(0.4), radius: 4.0, x: 0.0, y: 1.0)
                        
                    }
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: .width(percent: 4.5), trailing: 0.0))
                    
                    DisclaimerViewUI()
                        .padding(EdgeInsets(top: 0.0, leading: .width(percent: 4.5), bottom: .width(percent: 4.5), trailing: .width(percent: 4.5)))
                    
                }
                .padding(EdgeInsets(top: .width(percent: 3.0), leading: .width(percent: 4.0), bottom: .width(percent: 3.0), trailing: .width(percent: 4.0)))
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        
    }
}

struct StartViewUI_Previews: PreviewProvider {
    static var previews: some View {
        StartViewUI()
    }
}

// Disclaimer View

struct DisclaimerViewUI: View {
    
    var body: some View {
        
        (Text("By clicking Log In or Sign Up, you agree to our ")
            .font(Font(UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)))
            .foregroundColor(.white)
        + Text("Terms")
            .font(Font(UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)))
            .foregroundColor(.white)
            .underline()
        + Text(" and ")
            .font(Font(UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)))
            .foregroundColor(.white)
        + Text("Privacy Policy")
            .font(Font(UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)))
            .foregroundColor(.white)
            .underline())
            .multilineTextAlignment(.center)
            .onTapGesture {
                
                // Future Action
                
        }
        
    }
    
}
