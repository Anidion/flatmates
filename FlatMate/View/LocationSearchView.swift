//
//  LocationSearchView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-23.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    @Binding var selectedLocation: String
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Enter your city", text: $searchText, onCommit: {
                    performSearch()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                // Search Results
                List(searchResults, id: \.self) { mapItem in
                    Button(action: {
                        if let name = mapItem.name {
                            selectedLocation = name
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(mapItem.name ?? "")
                                .font(.headline)
                            Text(mapItem.placemark.title ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.resultTypes = .address

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Search error: \(error.localizedDescription)")
            } else {
                searchResults = response?.mapItems ?? []
            }
        }
    }
}
