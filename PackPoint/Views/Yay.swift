//
//  Yay.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/26/23.
//

import SwiftUI
import FirebaseAuth

struct Yay: View {
    @State var signOut: Bool = false
    var body: some View {
        ZStack {
            Color(.systemGreen).ignoresSafeArea()
            Button {
                do {
                    try Auth.auth().signOut()
                    signOut = true
                } catch {
                    print("error")
                }
            } label: {
                Text("Sign Out")
            }

        }
        .navigationDestination(isPresented: $signOut) {
            Onboarding()
        }
        .navigationBarHidden(true)
    }
}

struct Yay_Previews: PreviewProvider {
    static var previews: some View {
        Yay()
    }
}
