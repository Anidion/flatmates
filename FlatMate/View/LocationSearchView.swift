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
    @Binding var city: String // For storing the city
    @Binding var province: String // For storing the province/state
    @Binding var country: String // For storing the country
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Enter an area, address, or postal code", text: $searchText, onCommit: {
                    performSearch()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                // Search Results
                List(searchResults, id: \.self) { mapItem in
                    Button(action: {
                        if let name = mapItem.name {
                            selectedLocation = name
                            let placemark = mapItem.placemark
                            city = placemark.locality ?? ""
                            province = placemark.administrativeArea ?? ""
                            country = placemark.country ?? ""
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(mapItem.name ?? "Unknown Place")
                                .font(.headline)
                            Text(mapItem.placemark.title ?? "No address available")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Enter the area where you want to find a flatmate.")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText // Use the query entered by the user
        request.resultTypes = [.address, .pointOfInterest] // Include addresses and points of interest
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Search error: \(error.localizedDescription)")
            } else {
                if let results = response?.mapItems {
                    // Include matches for name, address, or postal code
                    searchResults = results.filter { mapItem in
                        let name = mapItem.name?.lowercased() ?? ""
                        let title = mapItem.placemark.title?.lowercased() ?? ""
                        let address = mapItem.placemark.postalAddress?.street.lowercased() ?? ""
                        let postalCode = mapItem.placemark.postalCode?.lowercased() ?? ""
                        
                        // Match query with name, title, address, or postal code
                        return name.contains(searchText.lowercased())
                        || title.contains(searchText.lowercased())
                        || address.contains(searchText.lowercased())
                        || postalCode.contains(searchText.lowercased())
                    }
                } else {
                    searchResults = []
                }
            }
        }
    }
}

