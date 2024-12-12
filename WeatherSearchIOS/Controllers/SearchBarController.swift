import Foundation
import Combine

class SearchBarController {
    private let viewModel: AutocompleteViewModel
    private var fetchCancellable: AnyCancellable? // Manage Combine subscriptions
    
    init(viewModel: AutocompleteViewModel) {
        self.viewModel = viewModel
    }

    // Handle text input changes and fetch suggestions
    func onTextChanged(_ input: String) {
        guard !input.isEmpty else {
            clearSuggestions()
            return
        }
        fetchSuggestions(for: input)
    }

    // Fetch autocomplete suggestions through the ViewModel
    private func fetchSuggestions(for input: String) {
        fetchCancellable = viewModel.fetchAutocompleteSuggestionsPublisher(input: input)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching suggestions: \(error.localizedDescription)")
                }
            }, receiveValue: { suggestions in
                self.viewModel.suggestions = suggestions
            })
    }

    // Clear suggestions when input is empty or reset
    private func clearSuggestions() {
        viewModel.suggestions = []
        fetchCancellable?.cancel()
    }
}
