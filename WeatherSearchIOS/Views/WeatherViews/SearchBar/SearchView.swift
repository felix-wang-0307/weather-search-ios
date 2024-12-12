import SwiftUI
import UIKit

struct SearchBarView2: UIViewControllerRepresentable {
    @Binding var cityName: String // Binding for the entered city name
    @ObservedObject var viewModel: AutocompleteViewModel // Autocomplete ViewModel
    var onCitySelected: ((String) -> Void)? // Callback for city selection

    func makeUIViewController(context: Context) -> SearchBarViewController {
        let viewController = SearchBarViewController()
        viewController.viewModel = viewModel
        viewController.onCitySelected = onCitySelected
        viewController.cityNameBinding = $cityName
        return viewController
    }

    func updateUIViewController(_ uiViewController: SearchBarViewController, context: Context) {
        // Update the view controller when SwiftUI state changes
        uiViewController.cityNameBinding = $cityName
    }
}

class SearchBarViewController: UIViewController {
    var viewModel: AutocompleteViewModel!
    var onCitySelected: ((String) -> Void)?
    var cityNameBinding: Binding<String>?

    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var suggestions: [AutocompleteSuggestion] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupConstraints()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Enter City Name"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        tableView.isHidden = true // Initially hidden
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // SearchBar Constraints
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // TableView Constraints
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchAutocompleteSuggestions(for input: String) {
        viewModel.fetchAutocompleteSuggestionsPublisher(input: input)
    }

    private func updateSuggestions() {
        suggestions = viewModel.suggestions
        tableView.reloadData()
        tableView.isHidden = suggestions.isEmpty
    }
}

extension SearchBarViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cityNameBinding?.wrappedValue = searchText
        if searchText.isEmpty {
            suggestions = []
            tableView.reloadData()
            tableView.isHidden = true
        } else {
            fetchAutocompleteSuggestions(for: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchBarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        let suggestion = suggestions[indexPath.row]
        cell.textLabel?.text = "\(suggestion.city), \(suggestion.state)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = suggestions[indexPath.row].city
        cityNameBinding?.wrappedValue = selectedCity
        onCitySelected?(selectedCity)
        searchBar.text = selectedCity
        suggestions = []
        tableView.reloadData()
        tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}
