//
//  ViewController.swift
//  OpenWeather
//
//  Created by 윤여진 on 2022/08/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        OpenWeatherAPIManager.shared.requestAPI(37.65134, 127.08336) {
            
        }
        
    }


}

