//
//  WeatherHomeView.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import SwiftUI

struct WeatherHomeView: View {
    
    @EnvironmentObject var viewModel: SearchViewModel
        
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            searchBarView
            
            // No City Selected State
            if viewModel.selectedWeather == nil && viewModel.query.isEmpty && !viewModel.noResults {
                Spacer()
                Text("No City Selected")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Please Search For A City")
                    .padding(.top)
                    .fontWeight(.bold)
                    .padding(.bottom)
            }
            
            // Display Selected Weather
            if let weather = viewModel.selectedWeather, viewModel.query.isEmpty {
                Spacer()
                
                VStack(spacing: 24) {
                    weatherImageView(weather.current.condition.text, width: 123)
                    
                    Text(weather.location.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    weatherTempView(weather.current.tempC)
                    
                    weatherDetailsView(weather)
                }
                Spacer()
            }
            
            // Search Results
            if let searchResults = viewModel.searchResults, !viewModel.query.isEmpty {
                searchResultView(searchResults)
            } else if viewModel.error {
                Spacer()
                Text("There was an error getting the weather, please try again later.")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Spacer()
        }
        .background(.bgPrimary)
        .onChange(of: viewModel.searchResults) {
            viewModel.handleSearchResultsChange()
        }
        .onAppear {
            viewModel.handleOnAppear()
        }
    }
    
    @ViewBuilder
    func weatherImageView(_ image: String, width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        if let image = WeatherCondition.imageName(for: image) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        }
    }
    
    @ViewBuilder
    func weatherTempView(_ temp: Double) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(Int(temp.rounded()))")
                .font(.system(size: 64))
                .fontWeight(.bold)
            
            Text("°")
                .font(.title2)
                .fontWeight(.light)
                .padding(.top, 8)
        }
    }
    
    @ViewBuilder
    func weatherDetailsView(_ weather: WeatherData) -> some View {
        HStack(spacing: 56) {
            WeatherDetailView(label: "Humidity", value: "\(weather.current.humidity)%")
            WeatherDetailView(label: "UV", value: "\(weather.current.uv)")
            WeatherDetailView(label: "Feels Like", value: String(format: "%.0f°", weather.current.feelslikeC))
        }
        .padding()
        .background(.bgCommonElement)
        .cornerRadius(16)
        .padding(.top, 12)
    }
    
    @ViewBuilder var searchBarView: some View {
        HStack {
            HStack {
                TextField("Search Location", text: $viewModel.query)
                    .textFieldStyle(.plain) // Removes the default background
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.handleSearchSubmit()
                    }
                    .padding(.trailing, 20.51) // Exact padding as per Figma
                
                Image(systemName: "magnifyingglass")
                    .padding(.trailing)
                    .foregroundColor(.fillSecondary)
            }
            .padding(.leading, 20)
            .frame(height: 44)
            .background(Color.bgCommonElement)
            .cornerRadius(15)
            .padding(.trailing, 3)
        }
        .padding([.horizontal, .top])
    }
    
    @ViewBuilder
    func searchResultView(_ searchResults: WeatherData) -> some View {
        List([searchResults], id: \.location.name) { weather in
            HStack(alignment: .center) {
                VStack(alignment: .center, spacing: 16) {
                    Text(weather.location.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    weatherTempView(weather.current.tempC)
                }
                
                Spacer()
                
                weatherImageView(weather.current.condition.text, height: 68)
            }
            .padding()
            .background(.bgCommonElement)
            .cornerRadius(16)
            .onTapGesture {
                viewModel.handleWeatherSelection(weather)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    WeatherHomeView()
        .environmentObject(SearchViewModel())
}
