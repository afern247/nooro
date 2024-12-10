//
//  SearchViewModel.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import SwiftUI
import Combine

enum WeatherCondition: String {
    case clear = "Clear"
    case overcast = "Overcast"
    case partlyCloudy = "Partly cloudy"

    static func imageName(for conditionText: String?) -> String? {
        switch WeatherCondition(rawValue: conditionText ?? "") ?? .overcast {
        case .clear: return "clear"
        case .overcast: return "overcast"
        case .partlyCloudy: return "partly_cloudy"
        }
    }
}

class SearchViewModel: ObservableObject {
    
    @Published var query = ""
    @Published var error: Bool = false
    @Published var noResults: Bool = false
    @Published var searchResults: WeatherData?
    @Published var selectedWeather: WeatherData? = { Cache.read(fileName: .lastCity) as? WeatherData ?? nil }()
    @Published var showNoResults: Bool = false
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    internal func performSearch() {
        Task { @MainActor in
            guard !query.isEmpty else {
                self.searchResults = nil
                self.noResults = false
                return
            }
            
            do {
                let weatherData = try await self.weatherService.fetchWeather(for: self.query)
                self.searchResults = weatherData
                self.error = false
                self.noResults = false
            } catch WeatherServiceError.noResults {
                self.searchResults = nil
                self.noResults = true
                self.error = false
            } catch {
                self.searchResults = nil
                self.error = true
                self.noResults = false
            }
        }
    }
    
    func refreshWeather(for location: String) {
        Task {
            do {
                let updatedWeather = try await weatherService.fetchWeather(for: location)
                DispatchQueue.main.async {
                    self.selectedWeather = updatedWeather
                }
            } catch {
                // Log the error, view will have previous cache
                print("Error updating current user's weather selection")
            }
        }
    }
    
    func cacheSelection(_ selection: WeatherData) {
        Cache.write(.lastCity, with: selection)
        self.selectedWeather = selection
        self.query = ""
    }
    
    func updateShowNoResults() {
        self.showNoResults = self.searchResults == nil && !self.query.isEmpty
    }
    
    func handleOnAppear() {
        if let weather = selectedWeather {
            refreshWeather(for: weather.location.name)
        }
    }
    
    func handleSearchResultsChange() {
        showNoResults = searchResults == nil && !query.isEmpty
    }
    
    func handleWeatherSelection(_ weather: WeatherData) {
        selectedWeather = weather
        query = ""
        cacheSelection(weather)
    }
    
    func handleSearchSubmit() {
        performSearch()
    }
}
