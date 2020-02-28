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
    let units: Units
    
    var city: String?
    var coordinates: Coordinates?
    
    var urlString: String? {
        // Sample call: api.openweathermap.org/data/2.5/weather?q={city name}&appid={your api key}
        if coordinates != nil {
            return "\(urlBase)lat=\(coordinates!.latitude)&lon=\(coordinates!.longitude)&units=\(units.rawValue)&appid=\(apiKey)"
        } else if city != nil {
            return "\(urlBase)q=\(city!.withoutSpaces)&units=\(units.rawValue)&appid=\(apiKey)"
        } else {
            return nil
        }
    }
    
    
    func performRequest() {
        // 1: create a URL
        guard urlString != nil else { return }
        let url = URL(string: urlString!)
        // 2: create a URL Session
            // I'm using the singleton shared session as I don't need configuration.
        // 3: Give the session a task
        assert(url != nil, "Error creating URL from urlString")
        print(url!)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(self, error: error!)
            } else if data == nil {
                self.delegate?.didFailWithError(self, error: WeatherError.dataError("Data error"))
            } else {
                if let weather = self.parseJSON(data!) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
            
        }
        // 4: Start the task
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(fromWeatherData: decodedData)
        } catch {
            self.delegate?.didFailWithError(self, error: WeatherError.decodingError("Decoding error"))
            return nil
        }
    }
    
    init(forCity city: String, withUnits units: Units) {
        self.units = units
        self.city = city
    }
    
    init(forCoorindates coordinates: Coordinates, withUnits units: Units) {
        self.units = units
        self.coordinates = coordinates
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

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ weatherManager: WeatherManager, error: Error)
}

enum WeatherError: Error {
    case dataError(String)
    case decodingError(String)
}
