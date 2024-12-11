import Foundation

class SearchBarController {
    private let viewModel: AutocompleteViewModel

    init(viewModel: AutocompleteViewModel) {
        self.viewModel = viewModel
    }

    // Trigger fetching suggestions when text changes
    func onTextChanged(_ input: String) {
        guard !input.isEmpty else {
            viewModel.suggestions = [] // Clear suggestions when input is empty
            return
        }
        viewModel.fetchAutocompleteSuggestions(input: input)
    }
}
