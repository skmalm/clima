//
//  WeatherModel.swift
//  clima
//
//  Created by Sebastian Malm on 2/24/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

struct WeatherModel {
    
    let cityName: String
    
    let temperature: Double?
    
    var temperatureString: String {
        if let actualTemperature = temperature {
            return String(format: "%.0f", actualTemperature)
        } else {
            return "??"
        }
        
    }
    
    let conditionID: Int
    
    var conditionSymbolName: String {
        switch conditionID {
        case 200...299:
            return "cloud.bolt"
        case 300...399:
            return "cloud.drizzle"
        case 500...599:
            return "cloud.heavyrain"
        case 600...699:
            return "cloud.snow"
        case 700...770:
            return "cloud.fog"
        case 771, 781:
            return "tornado"
        case 800:
            return "sun.max"
        case 801...809:
            return "cloud"
        default:
            return "hand.thumbsdown"
        }
    }
    
    init(fromWeatherData weatherData: WeatherData?) {
        if weatherData != nil {
            cityName = weatherData!.name
            temperature = weatherData!.main.temp
            conditionID = weatherData!.weather.count > 0 ? weatherData!.weather[0].id : 0
        } else {
            cityName = "??"
            temperature = nil
            conditionID = 0
        }
    }
}
