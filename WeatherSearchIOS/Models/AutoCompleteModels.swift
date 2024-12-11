import Foundation

// Represents a single autocomplete suggestion
struct AutocompleteSuggestion: Identifiable {
    let id = UUID()
    let city: String
    let state: String
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
