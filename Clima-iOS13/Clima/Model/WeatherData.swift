//
//  WeatherData.swift
//  Clima
//
//  Created by Dmitrii Vilgauk on 23.11.2023.
//
//

import Foundation

struct WeatherData: Codable /*Decodable, Encodable*/ {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
