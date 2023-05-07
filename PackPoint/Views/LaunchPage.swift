//
//  EntryPage.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/22/23.
//

import SwiftUI

struct LaunchPage: View {
    var body: some View {
        ZStack {
            // Make background color #ECD6FF
            Color(#colorLiteral(red: 236/255, green: 214/255, blue: 255/255, alpha: 1))
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image("PackPointLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                Text("Never lose your pack.")
                    .foregroundColor(Color(red: 75/255, green: 46/255, blue: 131/255))
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer()
            }.ignoresSafeArea()
        }
    }
}

struct LaunchPage_Previews: PreviewProvider {
    static var previews: some View {
        LaunchPage()
    }
}
