//
//  WeatherService.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import Foundation

enum WeatherServiceError: Error {
    case noResults
    case badResponse
    case unknownError
}

struct APIErrorResponse: Decodable {
    let error: APIErrorDetail
}

struct APIErrorDetail: Decodable {
    let code: Int
    let message: String
}

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherData
}

class WeatherService: WeatherServiceProtocol {
    
    // API keys should NEVER be hardcoded, I did it here because this is a simple coding exercise and securing the key was not part of the requirement and would add would add extra things that was not asked for.
    private let apiKey = "2d0808f0155a43279d5181430241012"
    private let baseURL = "https://api.weatherapi.com/v1/current.json"
    
    func fetchWeather(for city: String) async throws -> WeatherData {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)&q=\(city)") else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 200 {
            // Decode the response and return the weather data
            return try JSONDecoder().decode(WeatherData.self, from: data)
        } else {
            // Decode the error response
            if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
               errorResponse.error.code == 1006 {
                throw WeatherServiceError.noResults
            }
            throw WeatherServiceError.badResponse
        }
    }
}
