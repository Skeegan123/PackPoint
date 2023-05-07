//
//  PointCard.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/29/23.
//

import SwiftUI
import CoreLocation

struct PointCard: View {
    let point: Point
    let distance: CLLocationDistance

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: point.image_url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 360, height: 150)
                    .clipped()
                    .cornerRadius(20)
            } placeholder: {
                // This will show while the image is loading
                ProgressView()
            }

            HStack {
                Text(point.name)
                    .font(.headline)
                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                Spacer()
                Text("\(point.rating, specifier: "%.1f")")
                    .font(.callout)
                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                    .fontWeight(.semibold)
                    .padding(.top, 3)
                Image(systemName: "star.fill")
                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
            }

            HStack {
                Text("Distance: \(String(format: "%.2f", distance / 1609.34)) miles")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                    .fontWeight(.thin)
                Spacer()
            }
        }
        .padding()
        .padding(.top, -20)
        .shadow(radius: 5)
    }
}
