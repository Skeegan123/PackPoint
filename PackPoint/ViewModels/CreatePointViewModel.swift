//
//  CreatePointViewModel.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/30/23.
//

import Foundation
import UIKit
import FirebaseAuth

class CreatePointViewModel: ObservableObject {
    
    func processImage(_ image: UIImage) -> UIImage {
        let resizedImage = downscale(image: image, maxWidth: 600.0)

        return resizedImage
    }

    func downscale(image: UIImage, maxWidth: CGFloat) -> UIImage {
        let aspectRatio = image.size.width / image.size.height
        let newHeight = maxWidth / aspectRatio

        UIGraphicsBeginImageContext(CGSize(width: maxWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: maxWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? image
    }
    
    func createNewPoint(name: String, description: String, address: String, rating: Int, noise_level: Int, busy_level: Int, wifi: Bool, amenities: String, lat: Double, lng: Double, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        
        let newImage = processImage(image)
        
        guard let url = URL(string: "https://packpoint.azurewebsites.net/api/points") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
//        print("Lat: \(lat), Lng: \(lng)")
        
        AuthManager().getFirebaseIdToken { result in
            switch result {
            case .success(let idToken):
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let boundary = "---011000010111000001101001"
                let boundaryPrefixData = "--\(boundary)\r\n".data(using: .utf8)!
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
                request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

                var data = Data()
                
                let params: [[String: Any]] = [
                  [
                    "name": "name",
                    "value": name
                  ],
                  [
                    "name": "description",
                    "value": description
                  ],
                  [
                    "name": "address",
                    "value": address
                  ],
                  [
                    "name": "rating",
                    "value": "\(rating)"
                  ],
                  [
                    "name": "noise_level",
                    "value": "\(noise_level)"
                  ],
                  [
                    "name": "busy_level",
                    "value": "\(busy_level)"
                  ],
                  [
                    "name": "wifi",
                    "value": wifi ? "true" : "false"
                  ],
                  [
                    "name": "amenities",
                    "value": amenities
                  ],
                  [
                    "name": "lat",
                    "value": "\(lat)"
                  ],
                  [
                    "name": "lng",
                    "value": "\(lng)"
                  ]
                ]
                
                for param in params {
                    if let strValue = param["value"] as? String, let dataValue = strValue.data(using: .utf8) {
                        data.append(boundaryPrefixData)
                        data.append("Content-Disposition: form-data; name=\"\(param["name"]!)\"\r\n\r\n".data(using: .utf8)!)
                        data.append(dataValue)
                        data.append("\r\n".data(using: .utf8)!)
                    } else if let imgValue = param["value"] as? UIImage, let imgData = imgValue.jpegData(compressionQuality: 1.0) {
                        data.append(boundaryPrefixData)
                        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                        data.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8)!)
                        data.append(imgData)
                        data.append("\r\n".data(using: .utf8)!)
                    }
                }
                
                if let imageData = newImage.jpegData(compressionQuality: 1.0) {
                    data.append(boundaryPrefixData)
                    data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                    data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    data.append(imageData)
                    data.append("\r\n".data(using: .utf8)!)
                }

                let finalBoundary = "--\(boundary)--\r\n"
                if let finalBoundaryData = finalBoundary.data(using: .utf8) {
                    data.append(finalBoundaryData)
                }


                request.httpBody = data
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                        return
                    }

                    if let str = String(data: data, encoding: .utf8) {
                        completion(.success(str))
                    } else {
                        completion(.failure(NSError(domain: "Unable to convert data to text", code: -1, userInfo: nil)))
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

