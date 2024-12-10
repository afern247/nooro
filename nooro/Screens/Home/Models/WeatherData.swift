//
//  WeatherData.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import Foundation

struct WeatherData: Codable, Equatable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable, Equatable {
    let name: String
}

struct CurrentWeather: Codable, Equatable {
    let tempC: Double
    let condition: Condition
    let humidity: Int
    let uv: Double
    let feelslikeC: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case humidity
        case uv
        case feelslikeC = "feelslike_c"
    }
}

struct Condition: Codable, Equatable {
    let text: String
    let icon: String
}
