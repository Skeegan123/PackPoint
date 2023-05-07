//
//  Login.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/28/23.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct Login: View {
    @State private var phoneNumber = ""
    @State private var isButtonVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var onVerificationScreen = false
    @State private var successfullLogin: Bool = false
    @State private var verificationCode: String = ""
    @State private var textInput: String = ""
    
    struct LoginPage{
        var text: String
        var placeholderText: String
    }
    
    var loginPages = [
        LoginPage(text: "Enter your phone number to find your pack:", placeholderText: "Phone Number"),
        LoginPage(text: "Enter the verification code sent to you:", placeholderText: "Verification Code")
    ]
    
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
                Text(!onVerificationScreen ? loginPages[0].text : loginPages[1].text)
                    .font(.title)
                    .padding(.horizontal)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                
                TextField("", text: $textInput)
                    .placeholder(when: textInput.isEmpty) {
                        Text(!onVerificationScreen ? loginPages[0].placeholderText : loginPages[1].placeholderText).foregroundColor(.white)
                    }
                    .keyboardType(.phonePad)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(#colorLiteral(red: 175/255, green: 202/255, blue: 226/255, alpha: 1)))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 60)
                    .foregroundColor(.white)
                    .accentColor(.white)
                    .onReceive(textInput.publisher.collect()) {
                        if !onVerificationScreen {
                            self.textInput = self.format(phoneNumber: String($0))
                        }
                    }
                Spacer()
                
                Button(action: {
                    if !onVerificationScreen {
                        phoneNumber = textInput
//                        print("Phone Number: \(phoneNumber)")
//                        print("Text Input: \(textInput)")
                        // If phone number is correct length, start auth
                        if phoneNumber.count == 14 {
                            AuthManager.shared.startAuth(phoneNumber: unformat(phoneNumber: phoneNumber)) { success in
                                guard success else { return }
                                DispatchQueue.main.async {
                                    // Navigate to LogIn2 view
                                    textInput = ""
                                    onVerificationScreen = true
                                    //                                onVerificationScreen = true
                                }
                            }
                        }
                    } else {
                        verificationCode = textInput
//                        print("Verification Code: \(phoneNumber)")
//                        print("Text Input: \(textInput)")
                        AuthManager().verifyCode(code: verificationCode) { success in
                            guard success else { return }
                            DispatchQueue.main.async {
                                // Navigate to Yay
                                textInput = ""
                                successfullLogin = true
                                LoginModel().checkUserExists() { exists in
//                                    print(exists)
                                    if exists {
                                        print("User exists, logging in")
                                    } else {
                                        print("User doesn't exist, creating a new one")
                                        // Call your createUser function here
                                        LoginModel().createUser(phoneNumber: unformat(phoneNumber: phoneNumber)) { result in
                                            switch result {
                                            case .success(let userId):
                                                print("User ID: \(userId)")
                                            case .failure(let error):
                                                print("Error: \(error)")
                                            }
                                        }
                                    }
                                }
                            }
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
        .navigationDestination(isPresented: $successfullLogin) {
//            Yay()
            MainContentView()
        }
        .navigationBarHidden(true)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
