//
//  ViewController.swift
//  clima
//
//  Created by Sebastian Malm on 2/20/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    @IBOutlet private weak var searchTextField: UITextField! { didSet { searchTextField.delegate = self }}
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        conditionImageView.isHidden = true
        weatherManager.delegate = self
        locationManager.delegate = self
    }
    
    private func searchSubmitted() {
        searchTextField.endEditing(true)
    }
    
    @IBAction private func currentLocationButtonPressed(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    @IBAction private func searchPressed(_ sender: UIButton) { searchSubmitted() }
    
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchSubmitted()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Type a city name here"
            return false
        } else {
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(forCity: textField.text!, withUnits: .imperial)
        textField.text = ""
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(_ weatherManager: WeatherManager, error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: "hand.thumbsdown")
            self.temperatureLabel.text = "??"
            self.cityLabel.text = "ERROR"
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.isHidden = false
            self.conditionImageView.image = UIImage(systemName: weather.conditionSymbolName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // forc unwrapping locations.last is safe because locations always has at least one item, as per the documentation
        let coordinates = Coordinates(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
        weatherManager.fetchWeather(forCoordinates: coordinates, withUnits: .imperial)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
