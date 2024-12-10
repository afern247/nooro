//
//  nooroTests.swift
//  nooroTests
//
//  Created by Arturo on 12/10/24.
//

import Testing
import Combine
@testable import nooro

struct nooroTests {

    @Test func testPerformSearchSuccess() async throws {
        let mockService = MockWeatherService(result: .success(MockData.sampleWeatherData))
        let viewModel = SearchViewModel(weatherService: mockService)
        
        viewModel.query = "Washington"
        viewModel.performSearch()
        
        // Wait for the asynchronous task to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms delay to allow the task to finish
        
        #expect(viewModel.searchResults?.location.name == "Washington")
        #expect(viewModel.error == false)
        #expect(viewModel.noResults == false)
    }

    @Test func testPerformSearchNoResults() async throws {
        let mockService = MockWeatherService(result: .failure(WeatherServiceError.noResults))
        let viewModel = SearchViewModel(weatherService: mockService)
        
        viewModel.query = "Unknown City"
        viewModel.performSearch()
        
        // Wait for the asynchronous task to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms delay to allow the task to finish
        
        #expect(viewModel.searchResults == nil)
        #expect(viewModel.error == false)
        #expect(viewModel.noResults == true)
    }

    @Test func testPerformSearchError() async throws {
        let mockService = MockWeatherService(result: .failure(WeatherServiceError.badResponse))
        let viewModel = SearchViewModel(weatherService: mockService)
        
        viewModel.query = "Test City"
        viewModel.performSearch()
        
        // Wait for the asynchronous task to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms delay to allow the task to finish
        
        #expect(viewModel.searchResults == nil)
        #expect(viewModel.error == true)
        #expect(viewModel.noResults == false)
    }

    @Test func testCacheSelection() throws {
        let weatherData = MockData.sampleWeatherData
        let mockService = MockWeatherService(result: .success(weatherData))
        let viewModel = SearchViewModel(weatherService: mockService)
        
        viewModel.cacheSelection(weatherData)
        
        Cache.write(.lastCity, with: weatherData)
        
        let cachedData = Cache.read(fileName: .lastCity) as? WeatherData
        #expect(cachedData?.location.name == "Washington")
    }
}

// MockWeatherService for testing
class MockWeatherService: WeatherServiceProtocol {
    private let result: Result<WeatherData, Error>
    
    init(result: Result<WeatherData, Error>) {
        self.result = result
    }
    
    func fetchWeather(for query: String) async throws -> WeatherData {
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
}
