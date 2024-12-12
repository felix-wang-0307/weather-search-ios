import Foundation
import Combine
import Alamofire
import SwiftyJSON

class AutocompleteViewModel: ObservableObject {
    @Published var suggestions: [AutocompleteSuggestion] = []
    private let baseUrl = "https://weather-search-web-571.wn.r.appspot.com/autocomplete"
    
    // Fetch suggestions as a Combine Publisher
    func fetchAutocompleteSuggestionsPublisher(input: String) -> AnyPublisher<[AutocompleteSuggestion], Error> {
        guard let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)?input=\(encodedInput)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return Future<[AutocompleteSuggestion], Error> { promise in
            AF.request(url).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let suggestions = self.parseSuggestions(from: json)
                    promise(.success(suggestions))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
        .eraseToAnyPublisher()
    }

    // Parse JSON response into suggestions
    private func parseSuggestions(from json: JSON) -> [AutocompleteSuggestion] {
        let suggestionsData = json["data"].arrayValue
        return suggestionsData.map {
            AutocompleteSuggestion(city: $0["city"].stringValue, state: $0["state"].stringValue)
        }
    }
}
