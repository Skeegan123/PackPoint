//
//  MapView.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/30/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct MKMapViewRepresentable: UIViewRepresentable {
    let userLocation: CLLocation?
    let points: [Point]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MKMapViewRepresentable

        init(_ parent: MKMapViewRepresentable) {
            self.parent = parent
        }
        
        func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
            let scale = newWidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!.withRenderingMode(.alwaysOriginal)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { return nil }

            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                if let image = UIImage(named: "PackPointLogo") {
                    let resizedImage = resizeImage(image: image, newWidth: 25) // set your desired width
                    annotationView!.image = resizedImage
                }
//                    annotationView!.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "Onboarding1"))
            } else {
                annotationView!.annotation = annotation
            }

            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? MKPointAnnotation {
                // Here you can do whatever you want with the selected annotation.
                // For example, you can print its title:
                print("Selected annotation with title: \(annotation.title ?? "No title")")
            }
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator // set the delegate to the coordinator
        mapView.overrideUserInterfaceStyle = .light // Force light mode
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        for point in points {
            let annotation = MKPointAnnotation()
            annotation.title = point.name // or any other property of Point that should be the title
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
            mapView.addAnnotation(annotation)
        }
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Remove all existing annotations
        uiView.removeAnnotations(uiView.annotations)
        
        // Add new annotations
        for point in points {
            let annotation = MKPointAnnotation()
            annotation.title = point.name // or any other property of Point that should be the title
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
            uiView.addAnnotation(annotation)
        }
        
        // Update the region to the user's location
        if let userLocation = userLocation {
            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Smaller delta values for a more zoomed-in view
            )
            uiView.setRegion(region, animated: true)
        }
    }
}

struct SinglePointMapView: UIViewRepresentable {
    let point: Point

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SinglePointMapView

        init(_ parent: SinglePointMapView) {
            self.parent = parent
        }
        
        func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
            let scale = newWidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!.withRenderingMode(.alwaysOriginal)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { return nil }

            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                if let image = UIImage(named: "PackPointLogo") {
                    let resizedImage = resizeImage(image: image, newWidth: 25) // set your desired width
                    annotationView!.image = resizedImage
                }
//                    annotationView!.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "Onboarding1"))
            } else {
                annotationView!.annotation = annotation
            }

            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? MKPointAnnotation {
                // Here you can do whatever you want with the selected annotation.
                // For example, you can print its title:
                print("Selected annotation with title: \(annotation.title ?? "No title")")
            }
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator // set the delegate to the coordinator
        mapView.overrideUserInterfaceStyle = .light // Force light mode
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        let annotation = MKPointAnnotation()
        annotation.title = point.name // or any other property of Point that should be the title
        annotation.coordinate = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // Smaller delta values for a more zoomed-in view
        )
        mapView.setRegion(region, animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // No need to update the map view in this case
    }
}
