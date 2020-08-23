//
//  ActivityView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/16/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    
    static let activityWidth: CGFloat = .width(percent: 87)
    
    var body: some View {
        
        ZStack (alignment: .leading) {
            
            Color(UIColor.mainDARKPURPLE).edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .foregroundColor(.white)
                .frame(width: .width(percent: 0.5))
                .edgesIgnoringSafeArea([.bottom, .top])
            
            VStack (alignment: .trailing) {
                
                Text("Activity")
                    .foregroundColor(Color(UIColor.white))
                    .font(Font(UIFont.dynamicFont(with: "Octarine-Bold", style: .title2)))
                    .frame(width: ActivityView.activityWidth - .width(percent: 14.0))
                
                BorderView()
                
                Spacer()
                
            }
            .padding(EdgeInsets(top: .width(percent: 5.0), leading: .width(percent: 7.0), bottom: .width(percent: 5.0), trailing: .width(percent: 7.0)))
            .frame(width: ActivityView.activityWidth)
            
        }
        
    }
    
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}

// Activity View

//struct ActivityView: View {
//
//    var body: some View {
//
//        H
//
//    }
//
//}
