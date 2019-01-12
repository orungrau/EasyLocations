//
//  ViewController.swift
//  EasyLocationsExample
//
//  Created by Anatoly Myaskov on 1/12/19.
//  Copyright © 2019 Anatoly Myaskov. All rights reserved.
//

import UIKit
import EasyLocations

class ViewController: UIViewController {
    var easyLocations: EasyLocations?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        easyLocations = EasyLocations()
    }

    @IBAction func requestAuthorizationAction(_ sender: Any) {
        easyLocations!.requestAuthorization()
    }
    
    @IBAction func startAction(_ sender: Any) {
        easyLocations!.startUpdating()
        
        easyLocations?.locations({ locations, status in
            let location = locations!.last!
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        })
    }
    
    @IBAction func stopAction(_ sender: Any) {
        easyLocations!.stopUpdating()
    }
}

