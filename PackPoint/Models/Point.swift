//
//  Point.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/28/23.
//

import Foundation

struct Point: Identifiable, Decodable {
    var id: Int
    var name: String
    var description: String
    var rating: Float
    var noise_level: Int
    var busy_level: Int
    var wifi: Bool
    var amenities: [String]
    var address: String
    var lat: Double
    var lng: Double
    var firebase_uid: String
    var image_url: String
}
