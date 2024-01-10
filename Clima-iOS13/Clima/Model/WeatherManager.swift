import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1972a313dd0f33a8098e0758f5d5d939&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. create URL
        if let url = URL(string: urlString) {
            
            //2. Create URL session
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            //let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("error")
                    return
                }
                if let safeData = data {
                    //                    let dataString = String(data: safeData, encoding: .utf8)
                    //                    print(dataString)
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        //                        let weatherVC = WeatherViewController()
                        //                        weatherVC.didUpdateWeather(weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
//            print(weather.conditionName)
//            print(weather.cityName)
            //print(weather.temperature)
            //print(weather.temperatureString)
            //print(weather.getConditionName(weatherID: id))
            //getConditionName(weatherID: id)
            //print(decodedData.main.temp)
            //            print(decodedData.weather[0].id)
            //            print(decodedData.main.temp)
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
        
        //func handle(data: Data?, response: URLResponse?, error: Error?) {
        //        if error != nil {
        //            print("error")
        //            return
        //        }
        //        if let safeData = data {
        //            let dataString = String(data: safeData, encoding: .utf8)
        //            print(dataString)
        //        }

