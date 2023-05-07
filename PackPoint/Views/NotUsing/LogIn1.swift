//
//  LogIn1.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/24/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LogIn1: View {
    @State private var phoneNumber = ""
    @State private var isButtonVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var goToVerificationCode = false
    
    
    
    private func format(phoneNumber: String) -> String {
        let filtered = phoneNumber.filter { "0123456789".contains($0) }
        var result = ""

        for (index, char) in filtered.enumerated() {
            if index == 0 {
                result.append("(")
            } else if index == 3 {
                result.append(") ")
            } else if index == 6 {
                result.append("-")
            }

            if index < 10 {
                result.append(char)
            }
        }

        return result
    }
    
    private func unformat(phoneNumber: String) -> String {
        var result = ""
        
        for char in phoneNumber {
            let newChar = String(char)
            if (newChar != "(" && newChar != ")" && newChar != "-" && newChar != " ") {
                result += newChar
            }
        }
        
        return "+1" + result
    }
    
    

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
                Text("Enter your phone number to find your pack:")
                    .font(.title)
                    .padding(.horizontal)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                
                TextField("", text: $phoneNumber)
                    .placeholder(when: phoneNumber.isEmpty) {
                        Text("Phone Number").foregroundColor(.white)
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
                    .onReceive(phoneNumber.publisher.collect()) {
                        self.phoneNumber = self.format(phoneNumber: String($0))
                    }
                Spacer()
                
                Button(action: {
                    AuthManager.shared.startAuth(phoneNumber: unformat(phoneNumber: phoneNumber)) { success in
                        guard success else { return }
                        DispatchQueue.main.async {
                            // Navigate to LogIn2 view
                            goToVerificationCode = true
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
        .navigationDestination(isPresented: $goToVerificationCode) {
            LogIn2()
        }
        .navigationBarHidden(true)
    }
}

struct LogIn1_Previews: PreviewProvider {
    static var previews: some View {
        LogIn1()
    }
}
