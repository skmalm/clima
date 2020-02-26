//
//  ViewController.swift
//  clima
//
//  Created by Sebastian Malm on 2/20/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchSubmitted()
    }
    
    private func searchSubmitted() {
        if searchTextField.text != "" {
            cityLabel.text = searchTextField.text
        }
        searchTextField.endEditing(true)
    }
    
    @IBOutlet weak var searchTextField: UITextField! { didSet {
        searchTextField.delegate = self
        }}
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
}

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
        var weatherManager = WeatherManager(forCity: textField.text!, withUnits: .imperial)
        weatherManager.delegate = self
        weatherManager.performRequest()
        textField.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionSymbolName)
            self.temperatureLabel.text = weather.temperatureString
        }
    }
    
    
}
