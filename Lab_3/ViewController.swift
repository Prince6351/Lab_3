//
//  ViewController.swift
//  Lab_3
//
//  Created by Prince Saini on 2022-11-12.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var serarchLocation: UITextField!
    
    @IBOutlet weak var Symbols: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        //code for weather images
       
        serarchLocation.delegate = self
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == serarchLocation {
            loadweather(search: serarchLocation.text)
            textField.endEditing(true)
        }
        
        return true
    }
    
    //function to customize the images for diffrent Symbols
    private func customImageColor(Code: Int){
        let code = Code
        let update = UIImage.SymbolConfiguration(paletteColors: [.brown,.black])
        Symbols.preferredSymbolConfiguration = update
        print(code)
        
        switch(code){
        case 1000:
            Symbols.image = UIImage(systemName: "sun.max")
        case 1003:
            Symbols.image = UIImage(systemName: "cloud.sun")
        case 1006:
            Symbols.image = UIImage(systemName: "cloud.fill")
        case 1009:
            Symbols.image = UIImage(systemName: "smoke.fill")
        case 1030:
            Symbols.image = UIImage(systemName: "sun.haze.fill")
        case 1063:
            Symbols.image = UIImage(systemName: "cloud.sun.rain.fill")
        case 1066:
            Symbols.image = UIImage(systemName: "cloud.snow.fill")
        case 1069:
            Symbols.image = UIImage(systemName: "cloud.hail")
        case 1072:
            Symbols.image = UIImage(systemName: "cloud.hail.circle")
        case 1087:
            Symbols.image = UIImage(systemName: "cloud.bolt.rain.fill")
        case 1114:
            Symbols.image = UIImage(systemName: "wind.snow")
        case 1117:
            Symbols.image = UIImage(systemName: "wind.circle.fill")
        case 11135:
            Symbols.image = UIImage(systemName: "cloud.fill")
        case 1183:
            Symbols.image = UIImage(systemName: "sun.dust")
        default:
            Symbols.image = UIImage(systemName: "sun.max")
        }
    }


    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    
    @IBAction func Search(_ sender: UIButton) {
        
        loadweather(search: serarchLocation.text)
        
    }
    
   
    
    private func loadweather(search: String?)
    {
        guard let search  = search else{
            
            return 
        }
        guard let  url = getURL(query: search) else {
            print("could not get url")
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            print("Network call complete")
            
            guard error == nil else {
                print("Received error")
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }

            if let weatherResponse = self.parseJson(data: data) {
                                DispatchQueue.main.async {
                    self.locationLabel.text = weatherResponse.location.name
                    self.tempLabel.text = "\(weatherResponse.current.temp_c) C"
                                    self.customImageColor(Code: weatherResponse.current.condition.code)

                }
                
                
            }
            
        }
    
        dataTask.resume()
        
    }
    
    private func getURL(query: String) -> URL?
    {
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apikey = "aac24df09232473b85e13121222311"
        
       
        guard let url =
                "\(baseUrl)\(currentEndpoint)?key=\(apikey)&q=\(query)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
  
     
        return URL(string: url)
        
        
    }
    private func parseJson(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        var weather: WeatherResponse?
        
        do {
            weather = try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            print("Error decoding")
        }
        
        return weather
    }
    
    struct WeatherResponse: Decodable {
        let location: Location
        let current: Weather
    }
    struct Location: Decodable {
        let name: String
        let country: String
    }
    struct Weather: Decodable {
        let temp_c: Float
        let condition: WeatherCondition
    }
    struct WeatherCondition: Decodable {
        let text: String
        let code: Int
    }
    
    

    
    @IBAction func Location(_ sender: UIButton) {
        
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("get Location")
        
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            print("lat:(\(lat),\(long)")
            
        }
    }
    

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error)
    }
}

