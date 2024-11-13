//
//  ContentView.swift
//  Parks-Lab5
//
//  Created by Allison Gumowitz on 10/22/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var parks: [Park] = []
    
    var body: some View {
        
        Label("Allison Gumowitz Z23708856", systemImage: "star.fill")
        
        NavigationStack{
            ScrollView {
                LazyVStack {
                    ForEach(parks) {park in
                        NavigationLink(value: park){
                            ParkRow(park: park)
                        }
                    }
                }
            }
            .navigationDestination(for: Park.self) { park in // <-- Add a navigationDestination that reacts to any Park type sent from a Navigation Link
                ParkDetailView(park: park)
            }
            .navigationTitle("National Parks")
        }
        .padding()
        .onAppear(perform: {
                            
                            Task {
                                let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=ca&api_key=urxT670Md2pp3GkTWQ9QdZoGxsHQUQbdlmxcQa0U")!
                                do {
                                    
                                    // Perform an asynchronous data request
                                    let (data, _) = try await URLSession.shared.data(from: url)
                                    
                                    // Decode json data into ParksResponse type
                                    let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)
                                    
                                    // Get the array of parks from the response
                                    let parks = parksResponse.data
                                    
                                    // Print the full name of each park in the array
                                    for park in parks {
                                        print(park.fullName)
                                    }
                                    
                                    self.parks = parks
                                    
                                    
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        })
                }
            }
            
            
            #Preview {
                ContentView()
            }
            
