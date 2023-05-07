//
//  CreatePointView.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/29/23.
//

import SwiftUI
import PhotosUI

struct CreatePointView: View {
    
    @State private var name = ""
    @State private var description = ""
    @State private var rating = 1
    @State private var address = ""
    
    @State private var noise_level = 1
    @State private var busy_level = 1
    @State private var wifi: Int = 0
    
    @State private var image = UIImage()
    @State private var showSheet = false
    
    @State private var selectedTags = Set<String>()
    
    @State private var lat: Double = 0.0
    @State private var lng: Double = 0.0
    
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    
    @State private var amenities: [String: Bool] = [
        "Restrooms": false,
        "Parking": false,
        "Outdoor Seating": false,
        // add more amenities as needed
    ]
    
    @State private var showingAlert = false
    @State private var showingErrorAlert = false
    @State private var imageIsUploaded = false
    @State private var loading = false
    
    @StateObject private var viewModel = CreatePointViewModel()
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
    
    func refreshForm() {
        name = ""
        description = ""
        rating = 1
        address = ""
        noise_level = 1
        busy_level = 1
        wifi = 0
        image = UIImage()
        selectedTags = Set<String>()
        showingAlert = false
        showingErrorAlert = false
    }
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("New PackPoint")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(#colorLiteral(red: 80/255, green: 129/255, blue: 255/255, alpha: 1)))
                        .padding(.horizontal, 35)
                        .padding(.top)
                        .onAppear {
                            locationManager.updateLocation()
                        }
                    Divider()
                        .frame(width: 345, height: 4)
                        .overlay(Color(#colorLiteral(red: 80/255, green: 129/255, blue: 255/255, alpha: 1)))

                    VStack {
                        Image(uiImage: self.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 360, height: 150)
                            .clipped()
                            .cornerRadius(20)
                            .background(Color.black.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(red: 80/255, green: 129/255, blue: 255/255), lineWidth: 2)
                            )
                            .padding()
                        
                        Button (action : {
                            showCamera = true
                            imageIsUploaded = true
                        }, label: {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 16))
                                Text("Take Photo")
                            }
                            .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                            .fontWeight(.semibold)
                            .font(.title3)
                            .frame(width: 350, height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(red: 80/255, green: 129/255, blue: 255/255), lineWidth: 2)
                            )
                        })
                        .sheet(isPresented: $showCamera) {
                            ImagePicker(sourceType: .camera, selectedImage: self.$image)
                        }
                        .padding(.bottom)
                        
                        Button (action : {
                            showPhotoLibrary = true
                            imageIsUploaded = true
                        }, label: {
                            HStack {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 16))
                                Text("Upload Photo")
                            }
                            .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                            .fontWeight(.semibold)
                            .font(.title3)
                            .frame(width: 350, height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(red: 80/255, green: 129/255, blue: 255/255), lineWidth: 2)
                            )
                        })
                        .sheet(isPresented: $showPhotoLibrary) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                        }
                        .padding(.bottom)
                    }
                    
                    HStack {
                        Text("Location Name:")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                        Spacer()
                    }.padding(.horizontal, 25)
                    TextField("Required", text: $name)
                        .padding()
                        .frame(width: 345, height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .environment(\.colorScheme, .light)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 80/255, green: 129/255, blue: 255/255), lineWidth: 2)
                        )
                        .padding(.bottom)
                    HStack {
                        Text("Description:")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                        Spacer()
                    }.padding(.horizontal, 25)
                    TextField("Optional", text: $description)
                        .padding()
                        .frame(width: 345)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .environment(\.colorScheme, .light)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 80/255, green: 129/255, blue: 255/255), lineWidth: 2)
                        )
                        .padding(.bottom)
                    
                    VStack {
                        PickerSection(title: "Rating", selection: $rating, tabs: [("1", 1), ("2", 2), ("3", 3), ("4", 4), ("5", 5)])
                        PickerSection(title: "Noise Level", selection: $noise_level, tabs: [("Silent", 1), ("Quiet", 2), ("Moderate", 3), ("Loud", 4), ("Blaring", 5)])
                        PickerSection(title: "Business Level", selection: $busy_level, tabs: [("Empty", 1), ("Fairly", 2), ("Moderate", 3), ("Busy", 4), ("Packed", 5)])
                        PickerSection(title: "Wifi", selection: $wifi, tabs: [("Yes", 0), ("No", 1)])
                    }
                    
                    VStack {
                        HStack {
                            Text("Tags:")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                            Spacer()
                        }.padding(.horizontal, 25)
                        TagCloud(selectedTags: $selectedTags)
                            .padding(.horizontal)
                    }
                    
                    
                    Button {
                        //Convert selectedTags set to comma separated string
                        let selectedTagsString = Array(selectedTags).joined(separator: ",")
                        
//                        print("\(imageIsUploaded) & \(name)")
                        if (imageIsUploaded && !name.isEmpty) {
                            loading = true
                            name = String(name.prefix(30))
                            description = String(description.prefix(1000))
                            
                            viewModel.createNewPoint(name: name, description: description, address: address, rating: rating, noise_level: noise_level, busy_level: busy_level, wifi: wifi == 0, amenities: selectedTagsString, lat: lat, lng: lng, image: image) { result in
                                switch result {
                                    case .success(let data):
                                        loading = false
                                        print("Success!\n\(data)")
                                        refreshForm()
                                        showingAlert = true

                                    case .failure(let error):
                                        loading = false
                                        print("Error: \(error)")
                                }
                                    
                            }
                        } else {
                            showingAlert = true
                            showingErrorAlert = true
                        }
                    } label: {
                        if loading {
                            ProgressView()
                                .foregroundColor(Color(.white))
                                .fontWeight(.semibold)
                                .font(.title3)
                                .frame(width: 350, height: 50)
                                .background(Color(red: 80/255, green: 129/255, blue: 255/255))
                                .cornerRadius(25)
                        } else {
                            Text("Share")
                                .foregroundColor(Color(.white))
                                .fontWeight(.semibold)
                                .font(.title3)
                                .frame(width: 350, height: 50)
                                .background(Color(red: 80/255, green: 129/255, blue: 255/255))
                                .cornerRadius(25)
                        }
                    }
                    .alert(showingErrorAlert ? "Error!\nYou are missing at least one required value." : "Success!\nYou can now return to the home tab.", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .padding()

                    }
                }
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
//                print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                lat = location.coordinate.latitude
                lng = location.coordinate.longitude
//                print("Lat: \(lat), Lng: \(lng)")
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct CreatePointView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePointView()
    }
}
