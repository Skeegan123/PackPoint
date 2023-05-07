//
//  Onboarding3.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/24/23.
//

import SwiftUI

struct Onboarding3: View {
    var body: some View {
        ZStack{
            Color(.white).ignoresSafeArea()
            VStack{
                Image("PackPointLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .padding(.top)
                Text("PackPoint")
                    .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                    .fontWeight(.semibold)
                    .font(.headline)
                Spacer()
                Image("Onboarding3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                Text("Check current status of PackPoints via Live Chat.")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                    .font(.title2)
                    .padding(.horizontal, 70)
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.center)
                Spacer()
                // 3 Progress Dots go here
                HStack{
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                }
                NavigationLink(destination: LogIn1()) {
                    Text("Get Started!")
                        .foregroundColor(Color(.white))
                        .fontWeight(.semibold)
                        .font(.title3)
                        .frame(width: 350, height: 50)
                        .background(Color(red: 80/255, green: 129/255, blue: 255/255))
                        .cornerRadius(25)
                }
                .padding(.top)
                NavigationLink(destination: LogIn1()) {
                    Text("Log In")
                        .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                        .fontWeight(.semibold)
                        .font(.title3)
                        .frame(width: 350, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(red: 80/255, green: 129/255, blue: 255/255), lineWidth: 2)
                        )
                }
                .padding(.bottom)
            }
        }.navigationBarHidden(true)
    }
}

struct Onboarding3_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding3()
    }
}
