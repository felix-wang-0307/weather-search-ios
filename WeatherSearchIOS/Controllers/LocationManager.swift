import Foundation
import Combine
import UIKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cityName: String = "Unknown Location"
    @Published var latitude: Double = 42.3601
    @Published var longitude: Double = -71.0589
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        // Check the authorization status
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Request permission
        case .restricted, .denied:
            print("Location access denied or restricted.")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Start updating location if authorized
        @unknown default:
            break
        }
    }
    
    
    // CLLocationManagerDelegate - Update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        print("Location updated: \(latitude), \(longitude)")  // Debugging line
        
        // Call reverse geocoding to get the city name
        reverseGeocode(location: location)
    }
    
    
    
    // Reverse geocode to get city name
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, error == nil else { return }
            if let placemark = placemarks?.first, let city = placemark.locality {
                DispatchQueue.main.async {
                    self.cityName = city
                    print("Updated cityName: \(city)")  // Add this line to confirm
                }
            }
        }
    }
    
    // Handle authorization changes
    // Handle authorization changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Start location updates when authorized
            print("Location services authorized")
        case .denied, .restricted:
            print("Location access denied or restricted.")
            // Prompt the user to enable location permissions in Settings
            showLocationPermissionAlert()
        case .notDetermined:
            print("Location permission not determined yet. Requesting permission.")
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func showLocationPermissionAlert() {
        let alertController = UIAlertController(title: "Location Permission Denied",
                                                message: "Please enable location access in Settings to get weather updates based on your current location.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
