//
//  WeatherViewController.swift
//  OpenWeather
//
//  Created by 윤여진 on 2022/08/13.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class WeatherViewController: UIViewController {
    
    var weatherList: [String] = []
    
    var weatherinfo: [WeatherInfo] = []
    
    let today = Date()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel! {
        didSet {
            commentLabel.text = "   오늘도 행복한 하루 보내세요!!! 화이팅!!!  "
        }
    }
    
    @IBOutlet var LabelCollection: [UILabel]!
    
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.image = UIImage(named: "backgroundImage")
            backgroundImageView.contentMode = .scaleToFill
            backgroundImageView.alpha = 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCollectionDesign()
        dateLabelDesign()
        locationLabelDesign()
        requestWeatherAPI(37.65128, 127.08335)
        iconImageViewDesign()
    }
    
    func labelCollectionDesign() {
        for i in LabelCollection {
            i.font = .systemFont(ofSize: 17)
            i.textColor = .black
            i.numberOfLines = 1
            i.backgroundColor = .white
            i.textAlignment = .center
            i.clipsToBounds = true
            i.layer.borderWidth = 1
            i.layer.cornerRadius = 10
        }
    }
    
    func dateSetting(_ date: Date, _ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        
        return dateFormatter.string(from: date)
        
    }
    
    func dateLabelDesign() {
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 15)
        dateLabel.backgroundColor = .clear
        dateLabel.text = dateSetting(today, "MM월 dd일 hh시 mm분")
        
    }
    
    func locationLabelDesign() {
        locationLabel.textColor = .white
        locationLabel.font = .boldSystemFont(ofSize: 20)
        locationLabel.backgroundColor = .clear
    }
    
    func iconImageViewDesign() {
        iconImageView.backgroundColor = .white
        iconImageView.layer.cornerRadius = 10
        iconImageView.layer.borderWidth = 1
        iconImageView.contentMode = .scaleAspectFit
    }
    
    
    
    func requestWeatherAPI(_ lat: Double, _ lon: Double) {
        
        let url = "\(EndPoint.weatherURL)lat=\(lat)&lon=\(lon)&appid=\(APIKey.openWeather)"
        
        AF.request(url, method: .get).validate().responseData { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let name = json["name"].stringValue
                locationLabel.text = " \(name) "
                
                let temp = json["main"]["temp"].doubleValue
                tempLabel.text = "  지금은 \(round(temp - 273))℃ 에요!   "
                
                let humidity = json["main"]["humidity"].doubleValue
                humidityLabel.text = "  \(round(humidity))% 만큼 습해요 ㅠㅠ   "
                
                let windspeed = json["wind"]["speed"].doubleValue
                windspeedLabel.text = "  \(round(windspeed))m/s의 바람이 불고 있어요!!   "
                
                let iconNumber = json["weather"][0]["icon"].stringValue
                let url = URL(string: "https://openweathermap.org/img/wn/\(iconNumber)@2x.png")
                
                iconImageView.kf.setImage(with: url)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

