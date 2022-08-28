//
//  OpenWeatherAPIManager.swift
//  OpenWeather
//
//  Created by 윤여진 on 2022/08/13.
//

import UIKit

import Alamofire
import SwiftyJSON


class OpenWeatherAPIManager {

    static let shared = OpenWeatherAPIManager()

    private init() { }

    var list: [WeatherInfo] = []

    func requestAPI(_ lat: Double, _ lon: Double, completionHandler: @escaping (WeatherInfo) -> ()) {

        // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        let url = "\(EndPoint.weatherURL)lat=\(lat)&lon=\(lon)&appid=\(APIKey.openWeather)"

        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
            
                
                let name = json["name"].stringValue
                let temp = json["main"]["temp"].doubleValue
                let humidity = json["main"]["humidity"].doubleValue
                let windspeed = json["wind"]["speed"].doubleValue
                let iconNumber = json["weather"][0]["icon"].stringValue
              

                let data = WeatherInfo(name: name, temp: temp, humidity: humidity, windspeed: windspeed, iconNumber: iconNumber)

                completionHandler(data)

            case .failure(let error):
                print(error)
            }
        }
        print(list)
    }

}
