import SwiftUI

struct SuggestionsDropdownView: View {
    let suggestions: [AutocompleteSuggestion]
    let onSelect: (AutocompleteSuggestion) -> Void

    var body: some View {
        // Remove fixedSize for now and just let it layout naturally
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(suggestions, id: \.self) { suggestion in
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
        }
        .frame(maxHeight: 200) // Allow scroll if many items
    }
}
