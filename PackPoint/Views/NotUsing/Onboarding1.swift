//
//  Onboarding1.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/22/23.
//

import SwiftUI

struct Onboarding1: View {
    @State private var buttonPressed = false
    
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
                Image("Onboarding1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Text("Find hidden points on our campus.")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                    .font(.title2)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack{
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color(red: 208/255, green: 189/255, blue: 225/255))
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color(red: 208/255, green: 189/255, blue: 225/255))
                }
                NavigationLink(destination: Onboarding2()) {
                    Text("Next")
                        .foregroundColor(Color(.white))
                        .fontWeight(.semibold)
                        .font(.title3)
                        .frame(width: 350, height: 50)
                        .background(Color(red: 80/255, green: 129/255, blue: 255/255))
                        .cornerRadius(25)
                        .opacity(buttonPressed ? 0.5 : 1.0)
                }
                .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                    buttonPressed = pressing
                }, perform: {})
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

struct Onboarding1_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding1()
    }
}
