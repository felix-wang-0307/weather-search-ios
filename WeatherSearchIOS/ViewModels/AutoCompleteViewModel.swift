import Foundation
import Combine
import Alamofire
import SwiftyJSON

class AutocompleteViewModel: ObservableObject {
    @Published var suggestions: [AutocompleteSuggestion] = []
    private let baseUrl = "https://weather-search-web-571.wn.r.appspot.com/autocomplete"
    private var cancellables: Set<AnyCancellable> = []
    
    // Fetch autocomplete suggestions using Alamofire and SwiftyJSON
    func fetchAutocompleteSuggestions(input: String) {
        guard let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)?input=\(encodedInput)") else { return }
        
        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                self.parseSuggestions(from: json)
            case .failure(let error):
                print("Autocomplete API error: \(error.localizedDescription)")
                self.suggestions = [] // Clear suggestions on error
            }
        }
    }
    
    // Parse JSON response to update suggestions
    private func parseSuggestions(from json: JSON) {
        let suggestionsData = json["data"].arrayValue
        DispatchQueue.main.async {
            self.suggestions = suggestionsData.map {
                AutocompleteSuggestion(city: $0["city"].stringValue, state: $0["state"].stringValue)
            }
        }
    }
}
