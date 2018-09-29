//
//  AddViewController.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-28.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import MapKit

class AddViewController: UIViewController , MKMapViewDelegate {

    // data recive from HomePage
    var keyLocationName = ""
    var keyLat = ""
    var keyLon = ""
    
    //page Connections to View
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var detailsView: UILabel!
    @IBOutlet weak var addBtnView: UIButton!
    
    // relative number to scale font size based on device screen size
    let relativeFontTempTitle:CGFloat = 0.075
    let relativeFontButton:CGFloat = 0.040
    let relativeFontTitle:CGFloat = 0.050
    let relativeFontDetails:CGFloat = 0.020

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

        let closeFrameSize = bestFrameSize()
        titleView.font = titleView.font.withSize(closeFrameSize * relativeFontTitle)
        detailsView.font = detailsView.font.withSize(closeFrameSize * relativeFontDetails)
        addBtnView.titleLabel?.font = addBtnView.titleLabel?.font.withSize(closeFrameSize * relativeFontButton)
        
        mapView.delegate = self
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
        
        mapView.mapType = MKMapType.standard
        
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(keyLat.toFloat()),longitude: CLLocationDegrees(keyLon.toFloat()))
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "iOSDevCenter-Kirit Modi"
        annotation.subtitle = "Timeframe"
        mapView.addAnnotation(annotation)
        
        self.updateBoard(latVal: keyLat, lonval: keyLon)
}
    
    
@objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer)
{
    
    let location = gestureReconizer.location(in: mapView)
    let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
    
    // Add annotation:
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    mapView.addAnnotation(annotation)

    updateBoard(latVal : String(format: "%.02f",annotation.coordinate.latitude), lonval : String(format: "%.02f",annotation.coordinate.longitude))
    
}


var selectedAnnotation: MKPointAnnotation?

func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
    let latValStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.latitude)!))
    let lonvalStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.longitude)!))
    
    updateBoard(latVal : latValStr, lonval : lonvalStr)
    
}

    
func updateBoard(latVal : String , lonval : String)  {
    let unitsChar = unitsInit == "metric" ?  "°c" : "°f"
    
    keyLat = latVal
    keyLon = lonval
    
    api.lat = latVal.toFloat()
    api.lon = lonval.toFloat()
    api.requestType = "weather"
    api.units = unitsInit
    let weather = api.getWeatherViaJsonWithURL()
    //let weather : WeatherModel = api.getModelViaJsonWithURL()
    
    if (weather.name == "") {
        self.titleView.text = ""
        self.detailsView.text = ""
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
   
    
    // add to bookmarks and exit
    @IBAction func addToBookmarkedAct(_ sender: UIButton) {
        let doneTask = bookmarkedTools.saveDataToEntity(locationName: keyLocationName, lat: keyLat, lon: keyLon)
        
        if (doneTask) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
}
