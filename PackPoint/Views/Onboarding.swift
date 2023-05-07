//
//  Onboarding.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/28/23.
//

import SwiftUI

struct Onboarding: View {
    @State private var buttonPressed = false
    @State private var nextPage: Bool = false
    @State private var currentOnboardingScreen = 0
    
    struct OnboardingScreen {
        var image: String
        var text: String
    }
    
    let onboardingScreens = [
        OnboardingScreen(image: "Onboarding1", text: "Find hidden points nearby."),
        OnboardingScreen(image: "Onboarding2", text: "Share your favorite points with your pack."),
        OnboardingScreen(image: "Onboarding3", text: "Check current status of PackPoints via Live Chat. (Coming Soon)")
    ]
    
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
                Image(onboardingScreens[currentOnboardingScreen].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                Text(onboardingScreens[currentOnboardingScreen].text)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                    .font(.title2)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack {
                    ForEach(Array(onboardingScreens.indices), id: \.self) { index in
                        Circle()
                            .fill(index <= currentOnboardingScreen ? Color(red: 80/255, green: 129/255, blue: 255/255) : Color(red: 208/255, green: 189/255, blue: 225/255))
                            .frame(width: 8, height: 8)
                    }
                }
                Button (action: {
                    if currentOnboardingScreen < onboardingScreens.count - 1 {
                            withAnimation {
                                currentOnboardingScreen += 1
                            }
                    } else {
                        nextPage = true
                    }
                }, label: {
                    Text("Next")
                        .foregroundColor(Color(.white))
                        .fontWeight(.semibold)
                        .font(.title3)
                        .frame(width: 350, height: 50)
                        .background(Color(red: 80/255, green: 129/255, blue: 255/255))
                        .cornerRadius(25)
                        .opacity(buttonPressed ? 0.5 : 1.0)
                })
                .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                    buttonPressed = pressing
                }, perform: {})
                .padding(.top)
                Button (action : {
                    nextPage = true
                }, label: {
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
                })
                .padding(.bottom)
            }
        }
        .navigationDestination(isPresented: $nextPage) {
            Login()
        }
        .navigationBarHidden(true)
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
