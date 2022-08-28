//
//  WeatherInfo.swift
//  OpenWeather
//
//  Created by 윤여진 on 2022/08/13.
//

import Foundation

struct WeatherInfo {
    
    let name: String
    let temp: Double
    let humidity: Double
    let windspeed: Double
    let iconNumber: String
    
    
    var nameText: String {
        get {
            return " \(name)의 날씨는? "
        }
    }
    
    var tempText: String {
        get {
            return "  지금은 \(round(temp - 273.15))℃ 에요!"
        }
    }
    
    var humidityText: String {
        get {
            return "  \(round(humidity))% 만큼 습해요 ㅠㅠ   "
        }
    }
    
    var windSpeedText: String {
        get {
            "  \(round(windspeed))m/s의 바람이 불고 있어요!!   "
        }
    }
    
    var commentText: String {
        get {
            "  오늘 하루도 화이팅이에요!!"
        }
    }
    
}
