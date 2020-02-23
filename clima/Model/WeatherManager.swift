//
//  File.swift
//  clima
//
//  Created by Sebastian Malm on 2/23/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import Foundation

struct WeatherManager {
    private let apiKey = "4e5bdca5dc39547b9ddcd773ed795361"
    private let urlBase = "https://api.openweathermap.org/data/2.5/weather?"
    let city: String
    let units: Units
    
    var urlString: String {
        // Sample call: api.openweathermap.org/data/2.5/weather?q={city name}&appid={your api key}
        return "\(urlBase)q=\(city)&units=\(units.rawValue)&appid=\(apiKey)"
    }
    
    func performRequest() {
        // 1: create a URL
        let url = URL(string: urlString)
        // 2: create a URL Session
        let session = URLSession(configuration: .default)
        // 3: Give the session a task
        assert(url != nil, "Error creating URL from urlString")
        let task = session.dataTask(with: url!) { data, response, error in
            assert(error == nil, "Networking error: \(error!)")
            assert(data != nil, "Error getting data")
            print(String(data: data!, encoding: .utf8) ?? "Error casting data to string")
        }
        // 4: Start the task
        task.resume()
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
