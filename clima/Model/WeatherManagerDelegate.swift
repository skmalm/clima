//
//  WeatherModelDelegate.swift
//  clima
//
//  Created by Sebastian Malm on 2/26/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}