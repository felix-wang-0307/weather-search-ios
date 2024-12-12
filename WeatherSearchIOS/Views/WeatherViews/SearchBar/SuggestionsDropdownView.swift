import SwiftUI
import UIKit

struct UIKitSuggestionsTableView: UIViewRepresentable {
    var suggestions: [AutocompleteSuggestion]
    var onSelect: (AutocompleteSuggestion) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator

        // Make the background slightly translucent white
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 8
        tableView.isOpaque = false

        return tableView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.suggestions = suggestions
        uiView.reloadData()
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: UIKitSuggestionsTableView
        var suggestions: [AutocompleteSuggestion] = []

        init(_ parent: UIKitSuggestionsTableView) {
            self.parent = parent
            self.suggestions = parent.suggestions
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return suggestions.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
            let suggestion = suggestions[indexPath.row]
            cell.textLabel?.text = "\(suggestion.city), \(suggestion.state)"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.backgroundColor = .clear // Keep cells clear so background shows
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let suggestion = suggestions[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            parent.onSelect(suggestion)
        }
    }
}
