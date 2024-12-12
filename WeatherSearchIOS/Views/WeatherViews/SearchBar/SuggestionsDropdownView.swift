import SwiftUI

struct SuggestionsDropdownView: View {
    let suggestions: [AutocompleteSuggestion]
    let onSelect: (AutocompleteSuggestion) -> Void

    var body: some View {
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
        }
        .frame(maxHeight: 200) // Limit dropdown height
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}
