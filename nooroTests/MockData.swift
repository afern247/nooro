//
//  MockData.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import Foundation

struct MockData {
    static let sampleWeatherData = WeatherData(
        location: Location(
            name: "Washington"
        ),
        current: CurrentWeather(
            tempC: 10.1,
            condition: Condition(
                text: "Mist",
                icon: "//cdn.weatherapi.com/weather/64x64/night/143.png"
            ),
            humidity: 89,
            uv: 2.0,
            feelslikeC: 8.8
        )
    )
}
