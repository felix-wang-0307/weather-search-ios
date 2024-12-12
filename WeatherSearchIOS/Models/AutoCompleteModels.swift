import Foundation

// Represents a single autocomplete suggestion
struct AutocompleteSuggestion: Hashable {
    let city: String
    let state: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(city)
        hasher.combine(state)
    }

    static func ==(lhs: AutocompleteSuggestion, rhs: AutocompleteSuggestion) -> Bool {
        return lhs.city == rhs.city && lhs.state == rhs.state
    }
}


// Represents the autocomplete API response
struct AutocompleteResponse: Codable {
    let success: Bool
    let data: [AutocompleteResult]
}

// Represents each city suggestion from the API response
struct AutocompleteResult: Codable {
    let city: String
    let state: String
}
