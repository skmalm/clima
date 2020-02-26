//
//  File.swift
//  clima
//
//  Created by Sebastian Malm on 2/23/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import Foundation

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    private let apiKey = "4e5bdca5dc39547b9ddcd773ed795361"
    private let urlBase = "https://api.openweathermap.org/data/2.5/weather?"
    let city: String
    let units: Units
    
    var urlString: String {
        // Sample call: api.openweathermap.org/data/2.5/weather?q={city name}&appid={your api key}
        return "\(urlBase)q=\(city.withoutSpaces)&units=\(units.rawValue)&appid=\(apiKey)"
    }
    
    
    func performRequest() {
        // 1: create a URL
        let url = URL(string: urlString)
        // 2: create a URL Session
            // I'm using the singleton shared session as I don't need configuration.
        // 3: Give the session a task
        assert(url != nil, "Error creating URL from urlString")
        print(url!)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            assert(error == nil, "Networking error: \(error!)")
            assert(data != nil, "Error getting data")
            if let weather = self.parseJSON(weatherData: data!) {
                self.delegate?.didUpdateWeather(weather: weather)
            }
        }
        // 4: Start the task
        task.resume()
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(fromWeatherData: decodedData)
        } catch {
            print(error)
            return WeatherModel(fromWeatherData: nil)
        }
    }
    
    init(forCity city: String, withUnits units: Units) {
        self.city = city
        self.units = units
    }
}

enum Units: String {
    case imperial
    case metric
}

extension String {
    var withoutSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
