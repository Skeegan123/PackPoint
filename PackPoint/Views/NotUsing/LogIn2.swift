//
//  LogIn2.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/26/23.
//

import SwiftUI

struct LogIn2: View {
    @State private var verificationCode = ""
    @State private var isButtonVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var goToYay: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
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
                Text("Verification Code:")
                    .font(.title)
                    .padding(.horizontal)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                
                TextField("", text: $verificationCode)
                    .placeholder(when: verificationCode.isEmpty) {
                        Text("Verification Code").foregroundColor(.white)
                    }
                    .keyboardType(.phonePad)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(#colorLiteral(red: 208/255, green: 189/255, blue: 225/255, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 60)
                    .foregroundColor(.white)
                    .accentColor(.white)
                Spacer()
                
                Button(action: {
                    AuthManager().verifyCode(code: verificationCode) { success in
                        guard success else { return }
                        DispatchQueue.main.async {
                            // Navigate to Yay
                            goToYay = true
                        }
                    }
                }, label: {
                    Text("Next")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color(#colorLiteral(red: 80/255, green: 129/255, blue: 255/255, alpha: 1)))
                        .cornerRadius(25)
                })
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationDestination(isPresented: $goToYay) {
            Yay()
        }
        .navigationBarHidden(true)
    }
}

struct LogIn2_Previews: PreviewProvider {
    static var previews: some View {
        LogIn2()
    }
}
