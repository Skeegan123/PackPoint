//
//  AuthManager.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/26/23.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    static let auth = Auth.auth()
    
    static var verificationId : String? = nil
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                return
            }
            AuthManager.verificationId = verificationId
            completion(true)
        }
    }
    
    public func verifyCode(code: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = AuthManager.verificationId else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        AuthManager.auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func getFirebaseIdToken(completion: @escaping (Result<String, Error>) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.getIDToken(completion: { token, error in
                if let error = error {
                    completion(.failure(error))
                } else if let token = token {
                    completion(.success(token))
                }
            })
        } else {
            completion(.failure(NSError(domain: "NotSignedIn", code: 0, userInfo: nil)))
        }
    }
}
