//
//  WeatherViewController.swift
//  OpenWeather
//
//  Created by 윤여진 on 2022/08/13.
//

import UIKit

import MapKit
import CoreLocation

import Alamofire
import SwiftyJSON
import Kingfisher

class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var currentRegion: CLLocationCoordinate2D?
    
    let today = Date()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
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
        
        locationManager.delegate = self
        
        labelCollectionDesign()
        dateLabelDesign()
        locationLabelDesign()
        //requestWeatherAPI(37.65128, 127.08335)
        iconImageViewDesign()
        
        OpenWeatherAPIManager.shared.requestAPI(37.65128, 127.08335) { value in
            
            let url = URL(string: "https://openweathermap.org/img/wn/\(value.iconNumber)@2x.png")
            self.iconImageView.kf.setImage(with: url)
            self.locationLabel.text = value.nameText
            self.tempLabel.text = value.tempText
            self.humidityLabel.text = value.humidityText
            self.windspeedLabel.text = value.windSpeedText
            self.commentLabel.text = value.commentText
        }
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
    
    
    
    //    func requestWeatherAPI(_ lat: Double, _ lon: Double) {
    //
    //        let url = "\(EndPoint.weatherURL)lat=\(lat)&lon=\(lon)&appid=\(APIKey.openWeather)"
    //
    //        AF.request(url, method: .get).validate().responseData { [self] response in
    //            switch response.result {
    //            case .success(let value):
    //                let json = JSON(value)
    //                print("JSON: \(json)")
    //
    //                let name = json["name"].stringValue
    //                locationLabel.text = " \(name) "
    //
    //                let temp = json["main"]["temp"].doubleValue
    //                tempLabel.text = "  지금은 \(round(temp - 273))℃ 에요!   "
    //
    //                let humidity = json["main"]["humidity"].doubleValue
    //                humidityLabel.text = "  \(round(humidity))% 만큼 습해요 ㅠㅠ   "
    //
    //                let windspeed = json["wind"]["speed"].doubleValue
    //                windspeedLabel.text = "  \(round(windspeed))m/s의 바람이 불고 있어요!!   "
    //
    //                let iconNumber = json["weather"][0]["icon"].stringValue
    //                let url = URL(string: "https://openweathermap.org/img/wn/\(iconNumber)@2x.png")
    //
    //                iconImageView.kf.setImage(with: url)
    //
    //            case .failure(let error):
    //                print(error)
    //            }
    //        }
    //    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴.
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 체크: locationServicesEnabled
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있음 => 위치 권한 요청 가능 => 위치 권한을 요청
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어 위치 권한 요청이 불가합니다.")
        }
        
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
            
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            
            locationManager.startUpdatingLocation()
            
        default:
            print("DEFAULT")
        }
    }
    
    
    
    func showRequestLocationServiceAlert() {
        
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
            
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        checkUserDeviceLocationServiceAuthorization()
        
    }
    
}




