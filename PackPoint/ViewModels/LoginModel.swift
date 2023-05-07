//
//  LoginModel.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/28/23.
//

import Foundation

class LoginModel {
    
    func checkUserExists(completion: @escaping (Bool) -> Void) {
        print("Checking if user exists")

        guard let url = URL(string: "https://packpoint.azurewebsites.net/api/users/exists") else {
            completion(false)
            return
        }

        AuthManager().getFirebaseIdToken { result in
            switch result {
            case .success(let idToken):
//                print("1Successfully got Firebase ID token")

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
//                print(idToken)

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                        print("Error: \(error?.localizedDescription ?? "No data")")
                        completion(false)
                        return
                    }
//                    print("Response status code: \(httpResponse.statusCode)")

                    completion(httpResponse.statusCode == 200)
                }
                task.resume()

            case .failure(let error):
                print("Error getting Firebase ID token: \(error)")
                completion(false)
            }
        }
    }


    
    public func createUser(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        AuthManager().getFirebaseIdToken { result in
            switch result {
            case .success(let idToken):
//                print("2Successfully got Firebase ID token")
                let url = URL(string: "https://packpoint.azurewebsites.net/api/users")
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
                
                let payload: [String: Any] = ["phone_number": phoneNumber]
                request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        print("Error: No data")
                        return
                    }
                    
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let _ = jsonResponse["firebase_uid"] as? String {
                        } else {
                            print("Error: Invalid JSON response")
                        }
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                task.resume()
            case .failure(let error):
                print("Error getting Firebase ID token: \(error)")
                completion(.failure(error))
            }
        }
    }

}
