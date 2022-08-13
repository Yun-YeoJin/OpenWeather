//
//  OpenWeatherAPIManager.swift
//  OpenWeather
//
//  Created by 윤여진 on 2022/08/13.
//

import Foundation

import Alamofire
import SwiftyJSON

class OpenWeatherAPIManager {
    
    static let shared = OpenWeatherAPIManager()
    
    private init() { }
    
    func requestAPI(_ lat: Double, _ lon: Double, completionHandler: @escaping ([WeatherInfo]) -> () ) {
        
        // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        let url = "\(EndPoint.weatherURL)lat=\(lat)&lon=\(lon)&appid=\(APIKey.openWeather)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let list  = json[0].arrayValue.map { WeatherInfo(name: $0["name"].stringValue, temp: $0["temp"].doubleValue, humidity: $0["humidity"].doubleValue, windspeed: $0["speed"].doubleValue, weatherimage: json["weather"]["icon"].stringValue) }
                
                completionHandler(list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
