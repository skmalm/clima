//
//  WeatherData.swift
//  clima
//
//  Created by Sebastian Malm on 2/23/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

struct WeatherData: Decodable, CustomStringConvertible {
    
    var description: String {
        guard weather.count > 0 else { return "ERROR" }
        return "Condition code: \(weather[0].id). It is \(main.temp) degrees in the city of \(name)."
    }
    
    let weather: Array<Weather>
    let main: Main
    let name: String
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
