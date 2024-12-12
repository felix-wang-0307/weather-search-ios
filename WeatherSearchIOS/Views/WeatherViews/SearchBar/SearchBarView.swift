import SwiftUI

struct SearchBarView: View {
    @Binding var cityName: String // City name binding
    @ObservedObject var viewModel: AutocompleteViewModel
    private let controller: SearchBarController
    var onCitySelected: ((String) -> Void)?

    @State private var searchBarFrame: CGRect = .zero // Frame of the search bar

    init(cityName: Binding<String>, viewModel: AutocompleteViewModel, controller: SearchBarController, onCitySelected: ((String) -> Void)? = nil) {
        self._cityName = cityName
        self.viewModel = viewModel
        self.controller = controller
        self.onCitySelected = onCitySelected
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Enter City Name", text: $cityName)
                        .onChange(of: cityName) { newValue in
                            controller.onTextChanged(newValue) // Fetch suggestions
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear.onAppear {
                                    // Track the frame of the search bar
                                    self.searchBarFrame = geo.frame(in: .global)
                                }
                            }
                        )
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
                .overlay( // Add dropdown as an overlay
                    DropdownOverlay(
                        suggestions: viewModel.suggestions,
                        searchBarFrame: searchBarFrame,
                        onSelect: { suggestion in
                            cityName = suggestion.city
                            onCitySelected?(suggestion.city) // Notify parent view
                        }
                    )
                )
            }
        }
    }
}

struct DropdownOverlay: View {
    let suggestions: [AutocompleteSuggestion]
    let searchBarFrame: CGRect
    let onSelect: (AutocompleteSuggestion) -> Void

    var body: some View {
        if !suggestions.isEmpty {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(suggestions, id: \.city) { suggestion in
                        Button(action: {
                            onSelect(suggestion)
                        }) {
                            Text("\(suggestion.city), \(suggestion.state)")
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxHeight: 200)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
                .position(x: searchBarFrame.midX, y: searchBarFrame.maxY + 100) // Position below the search bar
            }
        } else {
            EmptyView()
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
