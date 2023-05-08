//
//  PointInfoModel.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 5/8/23.
//

import Foundation
import FirebaseAuth

class PointInfoModel: ObservableObject {
    public func deletePoint(pointId: String, completion: @escaping (Result<String, Error>) -> Void) {
        AuthManager().getFirebaseIdToken { result in
            switch result {
            case .success(let idToken):
                let url = URL(string: "https://packpoint.azurewebsites.net/api/points/\(pointId)")
                var request = URLRequest(url: url!)
                request.httpMethod = "DELETE"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }
                    
                    guard let _ = data else {
                        print("Error: No data")
                        completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                        return
                    }
                    
                    completion(.success("Point successfully deleted"))
                }
                task.resume()
            case .failure(let error):
                print("Error getting Firebase ID token: \(error)")
                completion(.failure(error))
            }
        }
    }

}
