import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cityName: String = "Unknown Location"
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Request location permissions
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate - Update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
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
                }
            }
        }
    }

    // Handle authorization changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
} 
