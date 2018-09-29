//
//  CityScreenViewController.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-28.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit


class CityScreenViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    // data recive from HomePage
    var keyLocationName = ""
    var keyLat = ""
    var keyLon = ""

    //page Connections to View
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var detailsView: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // relative number to scale font size based on device screen size
    let relativeFontTempTitle:CGFloat = 0.075
    let relativeFontButton:CGFloat = 0.060
    let relativeFontCellTitle:CGFloat = 0.043
    let relativeFontCellDescription:CGFloat = 0.025

    // array(s) to show in collection
    var daysArray : [DaysInfo] = []
    
    // refrenced for classes
    var bookmarkedTools = BookmarkedTools()
    var knownTools = KnownTools()
    var settingsMem = DefaultsSettings()
    let api = ApiJson()

    // initial Value for Setting
    var collectionSource : String = "Bookmarked"
    var seacrhMethod : String = "def"
    var unitsInit : String = "metric"

    override func viewDidLoad() {
        super.viewDidLoad()

        // update initial Value for Setting by app Storage
        collectionSource = settingsMem.checkSettingsStat(keyName: "collectionSource", newKeyValue: collectionSource)
        unitsInit = settingsMem.checkSettingsStat(keyName: "unitsInit", newKeyValue: unitsInit)
        seacrhMethod = settingsMem.checkSettingsStat(keyName: "seacrhMethod", newKeyValue: seacrhMethod)

        tableView.delegate = self
        tableView.dataSource = self
        
        //navigationItem.title = keyLocationName
        behindView.layer.cornerRadius = 10
        titleView.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.thin)
        detailsView.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.thin)
        titleView.textColor = UIColor(hex: "0000b3")
        detailsView.textColor = UIColor(hex: "06023E")
        
        let closeFrameSize = bestFrameSize()
        titleView.font = titleView.font.withSize(closeFrameSize * relativeFontTempTitle)
        
        self.updateBoard(latVal: keyLat, lonval: keyLon)
        daysArray = updateDaysTable(latVal: keyLat, LonVal: keyLon)
        reupateboard(daysArr: daysArray)
        updateBackgroundImage(mainStat: daysArray[0].main)

        tableView.reloadData()
    }
    
    
    
    // fill out and tableview input array with last five days info from "forecast"
    func updateDaysTable(latVal : String, LonVal : String) -> [DaysInfo] {
        var outputArray : [DaysInfo] = []
        let dayKey = [0,8,16,24,32]
        api.lat = keyLat.toFloat()
        api.lon = keyLon.toFloat()
        api.requestType = "forecast"
        api.units = unitsInit
        //let forecast = api.getForecastViaJsonWithURL()
        let forecast : ForecastModel = api.getModelViaJsonWithURL()
        keyLocationName = forecast.city.name
        
        for onekey in dayKey {
            var onedayInfo = DaysInfo()
            onedayInfo.dt = forecast.list[onekey].dt
            onedayInfo.dt_txt = forecast.list[onekey].dt_txt
            onedayInfo.temp = String(format: "%.0f",forecast.list[onekey].main.temp)
            onedayInfo.humidity = String(forecast.list[onekey].main.humidity)
            onedayInfo.main = forecast.list[onekey].weather[0].main
            onedayInfo.description = forecast.list[onekey].weather[0].description
            onedayInfo.speed = String(forecast.list[onekey].wind.speed)
            onedayInfo.deg = String(forecast.list[onekey].wind.deg)

            outputArray.append(onedayInfo)
        }
        return outputArray
    }
    
    // update thoes parts that in some cases missing in "weather" from "forecast"
    func reupateboard(daysArr : [DaysInfo]) {
        let unitsChar = unitsInit == "metric" ?  "°c" : "°f"
        self.titleView.text = keyLocationName
        
        var detailsText = ""  //"\(daysArray[0].main)\n"
        detailsText += "Temperature : \(daysArray[0].temp)\(unitsChar)\n"
        detailsText += "Humidity : \(daysArray[0].humidity)%\n"
        detailsText += "Wind speed: \(daysArray[0].speed)km/hr \(daysArray[0].deg)°\n"
        detailsText += "(\(daysArray[0].description))\n"
        self.detailsView.text = detailsText
    }
    
    
    // update main board of the screen with "weather" info
    func updateBoard(latVal : String , lonval : String)  {
        let unitsChar = unitsInit == "metric" ?  "°c" : "°f"
        
        api.lat = latVal.toFloat()
        api.lon = lonval.toFloat()
        api.requestType = "weather"
        api.units = unitsInit
        let weather = api.getWeatherViaJsonWithURL()
        //let weather : WeatherModel = api.getModelViaJsonWithURL()
        
        if (weather.name == "") {
            self.titleView.text = ""
            self.detailsView.text = ""
            updateBackgroundImage(mainStat: "")
        } else {
            keyLocationName = weather.name
            self.titleView.text = "\(weather.name)\n"
            
            var detailsText = "\(weather.weather[0].main)\n"
            detailsText += "Temperature : \(weather.main.temp)\(unitsChar)\n"
            detailsText += "Humidity : \(weather.main.humidity)%\n"
            detailsText += "Wind speed: \(weather.wind.speed)km/hr \(weather.wind.deg)°\n"
            detailsText += "(\(weather.weather[0].description))\n"
            self.detailsView.text = detailsText
        }
    }
    
    // update background image depend of the main filed in "weather"
    func updateBackgroundImage(mainStat : String) {
        switch mainStat {
        case "Clouds":
            backgroundImage.image = UIImage(named: "clouds")
            break
        case "Clear":
            backgroundImage.image = UIImage(named: "clear")
            break
        case "Rain":
            backgroundImage.image = UIImage(named: "rain")
            break
        case "Snow":
            backgroundImage.image = UIImage(named: "snow")
            break
        case "Mist":
            backgroundImage.image = UIImage(named: "mist")
            break
        default:
            backgroundImage.image = UIImage(named: "clouds01")
        }
    }
    
    
    // Starting to set tableview for last five days info
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TableViewCell
        let oneday = daysArray[indexPath.row]
        let unitsChar = unitsInit == "metric" ?  "°c" : "°f"
        let closeFrameSize = bestFrameSize()
        cell.titleLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.thin)
        cell.detailsLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)


        let date = Date(timeIntervalSince1970: oneday.dt)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        var titleText = "\(oneday.temp) \(unitsChar)\n"
        titleText += "\(strDate)\n"   // oneday.dt_txt
        cell.titleLabel.text = titleText
        cell.titleLabel.font = cell.titleLabel.font.withSize(closeFrameSize * relativeFontCellTitle)

        var detailsText = "\(oneday.main)\n"
        detailsText += "Temperature : \(oneday.temp)\(unitsChar)\n"
        detailsText += "Humidity : \(oneday.humidity)%\n"
        detailsText += "Wind speed: \(oneday.speed)km/hr \(oneday.deg)°\n"
        detailsText += "(\(oneday.description))\n"
        cell.detailsLabel.text = detailsText
        cell.detailsLabel.font = cell.detailsLabel.font.withSize(closeFrameSize * relativeFontCellDescription)
        
        cell.titleLabel.textColor = UIColor(hex: "4D2D0A")
        cell.detailsLabel.textColor = UIColor(hex: "008375")
        // cell properties
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.masksToBounds = true

        return cell
    }

}
