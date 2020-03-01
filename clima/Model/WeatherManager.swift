//
//  File.swift
//  clima
//
//  Created by Sebastian Malm on 2/23/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    // Sample API call: https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={your api key}
    
    // MARK: - Properties
    
    var delegate: WeatherManagerDelegate?
    private let urlBase = "https://api.openweathermap.org/data/2.5/weather?"
    
    // MARK: - Methods
    
    // Sample call: api.openweathermap.org/data/2.5/weather?q={city name}&appid={your api key}
    func fetchWeather(forCity city: String, withUnits units: Units) {
        let urlString = "\(urlBase)q=\(city.withoutSpaces)&units=\(units.rawValue)&appid=\(SensitiveConstants.openWeatherAPIKey)"
        print("api call URL string: \(urlString)")
        performRequest(withURLString: urlString)
    }
    
    func fetchWeather(forCoordinates coordinates: Coordinates, withUnits units: Units) {
        let urlString = "\(urlBase)lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=\(units.rawValue)&appid=\(SensitiveConstants.openWeatherAPIKey)"
        print("api call URL string: \(urlString)")
        performRequest(withURLString: urlString)
    }
    
    private func performRequest(withURLString urlString: String) {
        let url = URL(string: urlString)
        assert(url != nil, "Error creating URL from urlString")
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
        task.resume()
    }
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(fromWeatherData: decodedData)
        } catch {
            self.delegate?.didFailWithError(self, error: WeatherError.decodingError("Decoding error"))
            return nil
        }
    }
}

// MARK: - Extensions and Local Types

extension String {
    var withoutSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ weatherManager: WeatherManager, error: Error)
}

private enum WeatherError: Error {
    case dataError(String)
    case decodingError(String)
}
