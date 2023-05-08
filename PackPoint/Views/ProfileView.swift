//
//  ProfileView.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/29/23.
//

import SwiftUI
import FirebaseAuth
import CoreLocation

struct ProfileView: View {
    @State private var showingActionSheet = false
    @State var signOut: Bool = false
    @State private var isLoading = true
    @State private var showingAlert = false
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(String(format: "%02d", profileViewModel.points.count))
                                .font(.system(size: 46))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                            Text("PackPoints\nReached")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                                .lineSpacing(0)
                        }
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 50))
                            .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                            .onTapGesture {
                                showingActionSheet = true
                            }
                            .actionSheet(isPresented: $showingActionSheet) {
                                ActionSheet(title: Text("Options"), buttons: [
                                    .default(Text("Sign Out"), action: {
                                        do {
                                            try Auth.auth().signOut()
                                            signOut = true
                                        } catch {
                                            print("error")
                                        }
                                        print("User signed out")
                                    }),
                                    .destructive(Text("Delete Account"), action: {
                                        showingAlert = true
                                    }),
                                    .cancel()
                                ])
                            }
                    }.padding(.horizontal, 35)
                    
                    Text("My PackPoints")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 53/255, green: 53/255, blue: 53/255))
                        .padding(.top, 20)
                        .padding(.horizontal, 35)
                    if isLoading {
                        ProgressView() // This will show a loading spinner
                    } else if profileViewModel.points.isEmpty {
                        Text("You havent created any points.") // This will show when there are no points
                    } else {
                        ForEach(profileViewModel.points) { point in
                            NavigationLink(destination: PointInfo(point: point, distance: profileViewModel.calculateDistance(point: point, userLocation: locationManager.location ?? CLLocation()))) {
                                PointCard(point: point, distance: profileViewModel.calculateDistance(point: point, userLocation: locationManager.location ?? CLLocation()))
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            locationManager.updateLocation()
        }
        .onChange(of: locationManager.location) { newLocation in
            profileViewModel.fetchUsersPoints() { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let pointsArray):
                        profileViewModel.points = pointsArray
                    case .failure(let error):
                        print("Error fetching points: \(error)")
                    }
                    self.isLoading = false
                }
            }
        }
        .alert("Are you sure you want to delete your account?", isPresented: $showingAlert) {
            Button("Delete", role: .destructive) {
                ProfileViewModel().deleteUser() { result in
                    switch result {
                    case .success(let message):
                        signOut = true
                        print(message)
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .padding()
        .refreshable {
            locationManager.updateLocation()
            profileViewModel.fetchUsersPoints { result in
                switch result {
                case .success(let fetchedPoints):
                    DispatchQueue.main.async {
                        profileViewModel.points = fetchedPoints
                    }
                case .failure(let error):
                    print("Error fetching points: \(error)")
                }
                self.isLoading = false
            }
        }
        .navigationDestination(isPresented: $signOut) {
            Onboarding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
