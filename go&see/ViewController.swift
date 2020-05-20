//
//  ViewController.swift
//  Go&See
//
//  Created by liza on 2/14/20.
//  Copyright © 2020 liza. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //MARK: Properties
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var degreesLabel: UILabel!
    
    let apiKey = "bf63439520563721950f363a3b4aa838"
    var lat = 11.344533
    var lon = 104.33322
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[0]
    lat = location.coordinate.latitude
    lon = location.coordinate.longitude
    Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                //let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                //let iconName = jsonWeather["icon"].stringValue
                let a = jsonResponse["name"].stringValue
                let b = jsonTemp["temp"].doubleValue
                self.locationLabel.text = a
                
                //self.conditionImageView.image = UIImage(named: iconName)
                //self.conditionLabel.text = jsonWeather["main"].stringValue
                self.degreesLabel.text = "\(Int(round(b)))"
        
                
        }
        }
    }
    
}
