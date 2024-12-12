import SwiftUI
import UIKit

struct UIKitSearchBar: UIViewRepresentable {
    @Binding var text: String
    var onTextChanged: ((String) -> Void)? // Similar to what you did with controller.onTextChanged
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: UIKitSearchBar
        
        init(parent: UIKitSearchBar) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
            parent.onTextChanged?(searchText)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Enter City Name"
        searchBar.autocapitalizationType = .none
        // Customize appearance as needed:
        searchBar.searchBarStyle = .prominent
        searchBar.barTintColor = .white
        searchBar.tintColor = .systemBlue
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
}
