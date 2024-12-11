import Foundation
import Alamofire
import SwiftyJSON

class GeocodingController {
    private let baseUrl = "https://weather-search-web-571.wn.r.appspot.com/geocoding"

    // Fetch latitude and longitude for the given address (city and state)
    func fetchCoordinates(for address: String, completion: @escaping (Result<(latitude: Double, longitude: Double), Error>) -> Void) {
        guard let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)?address=\(encodedAddress)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                if json["success"].boolValue {
                    let latitude = json["data"]["latitude"].doubleValue
                    let longitude = json["data"]["longitude"].doubleValue
                    completion(.success((latitude: latitude, longitude: longitude)))
                } else {
                    completion(.failure(NSError(domain: "Geocoding Error", code: -1, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
