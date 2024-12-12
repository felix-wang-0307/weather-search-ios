import SwiftUI
import SwiftUI

struct SearchBarView: View {
    @Binding var cityName: String // City name binding
    @ObservedObject var viewModel: AutocompleteViewModel
    private let controller: SearchBarController // Use controller to handle logic
    var onCitySelected: ((String) -> Void)?

    init(cityName: Binding<String>, viewModel: AutocompleteViewModel, controller: SearchBarController, onCitySelected: ((String) -> Void)? = nil) {
        self._cityName = cityName
        self.viewModel = viewModel
        self.controller = controller
        self.onCitySelected = onCitySelected
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Enter City Name", text: $cityName)
                    .onChange(of: cityName) { newValue in
                        controller.onTextChanged(newValue) // Delegate logic to controller
                    }
                Button(action: {
                    cityName = ""
                    controller.onTextChanged("") // Clear suggestions
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)

            if !viewModel.suggestions.isEmpty {
                SuggestionsDropdownView(
                    suggestions: viewModel.suggestions,
                    onSelect: { suggestion in
                        cityName = suggestion.city
                        onCitySelected?(suggestion.city) // Notify parent view
                    }
                )
            }
        }
    }
}

#Preview {
    struct SearchBarView_Preview: View {
        @State private var cityName: String = ""
        @StateObject private var viewModel = AutocompleteViewModel()
        
        var body: some View {
            ZStack {
                SearchBarView(
                    cityName: $cityName,
                    viewModel: viewModel,
                    controller: SearchBarController(viewModel: viewModel)
                ) { selectedCity in
                    print("Selected City: \(selectedCity)")
                }
                .padding()
            }
        }
    }
    return SearchBarView_Preview()
}
