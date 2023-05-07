//
//  MainView.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/24/23.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct MainView: View {
    let infoDictionary = Bundle.main.infoDictionary
    @State private var signOut = false
    @State private var selectedTab = 0
    @State private var isLoading = true
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var mainViewModel = MainViewModel()

    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            ScrollView {
                VStack {
//                    Button {
//                        do {
//                            try Auth.auth().signOut()
//                            signOut = true
//                        } catch {
//                            print("error")
//                        }
//                    } label: {
//                        Text("Sign Out")
//                    }
                    HStack {
                        Text("Hey there,\nFind your pack!")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                            .multilineTextAlignment(.leading)
                            .padding()
                        Spacer()
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(#colorLiteral(red: 80/255, green: 129/255, blue: 255/255, alpha: 1)), lineWidth: 7)
                        MKMapViewRepresentable(userLocation: locationManager.location, points: mainViewModel.points)
//                            .frame(width: 350, height: 250)
                            .cornerRadius(20)
                            .onAppear {
                                locationManager.updateLocation()
                            }
                    }
                    .frame(width: 350, height: 250)
                    HStack {
                        Text("PackPoints Near You")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                            .multilineTextAlignment(.leading)
                            .padding()
                        Spacer()
                    }
                    if isLoading {
                        ProgressView() // This will show a loading spinner
                    } else if mainViewModel.points.isEmpty {
                        Text("No points near you.")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                    } else {
                        ForEach(mainViewModel.points) { point in
                            NavigationLink(destination: PointInfo(point: point, distance: mainViewModel.calculateDistance(point: point, userLocation: locationManager.location ?? CLLocation()))) {
                                PointCard(point: point, distance: mainViewModel.calculateDistance(point: point, userLocation: locationManager.location ?? CLLocation()))
                            }
                        }
                    }
                    }
                }
                .refreshable{
                    locationManager.updateLocation()
                }
            }
            .onChange(of: locationManager.location) { newLocation in
                if let location = newLocation {
                    mainViewModel.fetchNearbyPoints(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let pointsArray):
                                mainViewModel.points = pointsArray
                            case .failure(let error):
                                print("Error fetching points: \(error)")
                            }
                            isLoading = false
                        
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $signOut) {
                Login()
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
