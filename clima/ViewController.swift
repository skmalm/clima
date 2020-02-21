//
//  ViewController.swift
//  clima
//
//  Created by Sebastian Malm on 2/20/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchSubmitted()
    }
    
    private func searchSubmitted() {
        cityLabel.text = searchTextField.text
        searchTextField.endEditing(true)
        searchTextField.text = ""
    }
    
    @IBOutlet weak var searchTextField: UITextField! { didSet {
        searchTextField.delegate = self
        }}
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchSubmitted()
        return true
    }
}
