//
//  MainViewModel.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/29/23.
//

import Foundation
import CoreLocation

class MainViewModel: ObservableObject {
    @Published var points: [Point] = []

    func fetchNearbyPoints(latitude: Double, longitude: Double, completion: @escaping (Result<[Point], Error>) -> Void) {
        self.points = [] // Clears the old points

        guard let url = URL(string: "https://packpoint.azurewebsites.net/api/points/nearby?lat=\(latitude)&lng=\(longitude)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        AuthManager().getFirebaseIdToken { result in
            switch result {
            case .success(let idToken):

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                        return
                    }

                    do {
                        let pointsArray = try JSONDecoder().decode([Point].self, from: data)
                        completion(.success(pointsArray))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()

            case .failure(let error):
                print("Error getting Firebase ID token: \(error)")
                completion(.failure(error))
            }
        }
    }



    func calculateDistance(point: Point, userLocation: CLLocation) -> CLLocationDistance {
        let pointLocation = CLLocation(latitude: point.lat, longitude: point.lng)
        return userLocation.distance(from: pointLocation)
    }
}
