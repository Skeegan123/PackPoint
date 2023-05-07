//
//  PointInfo.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/30/23.
//

import SwiftUI
import CoreLocation

struct PointInfo: View {
    let point: Point
    let distance: CLLocationDistance
    
    @StateObject private var locationManager = LocationManager()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    struct BottomRoundedRectangle: Shape {
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .allCorners
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    ZStack(alignment: .top) {
                        AsyncImage(url: URL(string: point.image_url)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .clipShape(BottomRoundedRectangle(radius: 20, corners: [.bottomLeft, .bottomRight]))
                                .edgesIgnoringSafeArea(.horizontal)
                        } placeholder: {
                            // This will show while the image is loading
                            ProgressView()
                        }.ignoresSafeArea()
                        
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left") // Use your custom image here
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white) // Change to your desired color
                                    .font(.system(size: 25)) // Change 20 to your desired size
                            }
                            .padding(8) // Add padding around the button
                            .background(Color.black.opacity(0.7)) // Add a semi-transparent black background
                            .cornerRadius(10) // Round the corners of the background
                            .padding(.top, 50) // You can adjust this to place the button exactly where you want
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(point.name)
                                .font(.title)
                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                .fontWeight(.semibold)
                            
                            Text("\(String(format: "%.2f", distance / 1609.34)) miles")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                    .font(.system(size: 12))
                                    .padding(.trailing, -5)
                                
                                Text("\(point.rating, specifier: "%.1f")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                            }
                            
                            // Description
                            if !point.description.isEmpty {
                                Text("Description:")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                    .padding(.top)
                                Text("\(point.description)")
                                    .font(.body)
                                    .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                            }
                            
                            VStack(alignment: .leading) {
                                
                                // Noise Level
                                HStack {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        .font(.system(size: 12))
                                    
                                    // Switch statement for noise level
                                    switch point.noise_level {
                                        case 0:
                                            Text("Not Specified")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 1:
                                            Text("Silent")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 2:
                                            Text("Quiet")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 3:
                                            Text("Moderate")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 4:
                                            Text("Loud")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 5:
                                            Text("Blaring")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                            
                                        default:
                                            Text("Error")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                    }
                                }
                                
                                // Busy level
                                HStack {
                                    Image(systemName: "person.3.fill")
                                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        .font(.system(size: 8))
                                    
                                    // Switch statement for noise level
                                    switch point.busy_level {
                                        case 0:
                                            Text("Not Specified")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 1:
                                            Text("Empty")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 2:
                                            Text("Somewhat")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 3:
                                            Text("Moderate")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 4:
                                            Text("Busy")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        case 5:
                                            Text("Packed")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                            
                                        default:
                                            Text("Error")
                                                .font(.subheadline)
                                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                    }
                                }
                                
                                // Is there wifi?
                                HStack {
                                    Image(systemName: "wifi")
                                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        .font(.system(size: 12))
                                    
                                    Text(point.wifi ? "Wifi Access" : "No Wifi Access")
                                        .font(.subheadline)
                                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                }
                                
                                // Amenities
                                HStack {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                        .font(.system(size: 12))
                                    
                                    // Loop through amenities array and print each one separated by ','
                                    let amenitiesString = point.amenities.map { $0.trimmingCharacters(in: .whitespaces) }.joined(separator: ", ")
                                    Text(amenitiesString.isEmpty ? "\(amenitiesString)" : "None specified")
                                        .font(.subheadline)
                                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                }
                            }.padding(.vertical)
                        }.padding(.horizontal)
                        Spacer()
                    }
                    Text("Location")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(#colorLiteral(red: 80/255, green: 129/255, blue: 255/255, alpha: 1)), lineWidth: 7)
                        SinglePointMapView(point: point)
//                            .frame(width: 350, height: 250)
                            .cornerRadius(20)
                            .onAppear {
                                locationManager.updateLocation()
                            }
                    }
                    .padding(.bottom, 50)
                    .frame(width: 350, height: 250)
                    
                }
            }.ignoresSafeArea()
            
            .navigationBarBackButtonHidden(true)
            
        }
    }
}
