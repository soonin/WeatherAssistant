//
//  SettingViewController.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-28.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var unitSysLabel: UILabel!
    @IBOutlet weak var unitSysSegment: UISegmentedControl!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchSegment: UISegmentedControl!
    @IBOutlet weak var resetBookmarks: UIButton!
    @IBOutlet weak var resetKnowns: UIButton!
    
    // relative number to scale font size based on device screen size
    let relativeFontWelcomeTitle:CGFloat = 0.045
    let relativeFontButton:CGFloat = 0.060
    let relativeFontCellTitle:CGFloat = 0.043
    let relativeFontCellDescription:CGFloat = 0.025

    // array(s) to show in collection
    var bookmarkedArray : [BookmarkedEntity] = []
    var knownArray : [KnownEntity] = []
    
    // refrenced for classes
    var bookmarkedTools = BookmarkedTools()
    var knownTools = KnownTools()
    var settingsMem = DefaultsSettings()

    // initial Value for Setting
    var collectionSource : String = "Bookmarked"
    var seacrhMethod : String = "def"  //
    var unitsInit : String = "metric"

    override func viewDidLoad() {
        super.viewDidLoad()

        // update initial Value for Setting by app Storage
        collectionSource = settingsMem.checkSettingsStat(keyName: "collectionSource", newKeyValue: collectionSource)
        unitsInit = settingsMem.checkSettingsStat(keyName: "unitsInit", newKeyValue: unitsInit)
        updateUnitsSegmentedControl(selectedSeg: unitsInit)
        seacrhMethod = settingsMem.checkSettingsStat(keyName: "seacrhMethod", newKeyValue: seacrhMethod)
        updateSearchSegmentedControl(selectedSeg: seacrhMethod)

        
        
        navigationItem.title = "Settings page"
        
        resetKnowns.customizeDelete()
        resetBookmarks.customizeDelete()
        
        // fetch data to arrays
        bookmarkedArray = bookmarkedTools.fetchData()
        knownArray =  knownTools.fetchData()
    }
    


    @IBAction func resetBookmarksAct(_ sender: UIButton) {
        bookmarkedTools.deleteAllData()
        
    }
    
    
    @IBAction func resetKnownAct(_ sender: UIButton) {
        knownTools.deleteAllData()
        let numberOfPreLoad = knownTools.preLoadFromPlist(forResource: "KnownLocations", ofType: "plist")
        if (numberOfPreLoad > 0) {
            settingsMem.saveSettings(keyName: "preloadKnown", keyValue: "yes")
        }
        knownArray =  knownTools.fetchData()
    }
    
    
    @IBAction func unitsSegAct(_ sender: UISegmentedControl) {
        switch unitSysSegment.selectedSegmentIndex {
        case 0:
            unitsInit = "metric"
            settingsMem.saveSettings(keyName: "unitsInit", keyValue: "metric")
            break
        case 1:
            unitsInit = "imperial"
            settingsMem.saveSettings(keyName: "unitsInit", keyValue: "imperial")
            break
        default:
            unitsInit = "metric"
            settingsMem.saveSettings(keyName: "unitsInit", keyValue: "metric")
            break
        }
    }
    
    
    func updateUnitsSegmentedControl(selectedSeg : String) {
        switch selectedSeg {
        case "metric":
            unitSysSegment.selectedSegmentIndex = 0
            break
        case "imperial":
            unitSysSegment.selectedSegmentIndex = 1
            break
        default:
            unitSysSegment.selectedSegmentIndex = 0
            break
        }
    }
    
    
    @IBAction func searchSegAct(_ sender: UISegmentedControl) {
        switch searchSegment.selectedSegmentIndex {
        case 0:
            seacrhMethod = "CCI"
            settingsMem.saveSettings(keyName: "seacrhMethod", keyValue: "CCI")
            break
        case 1:
            seacrhMethod = "CCS"
            settingsMem.saveSettings(keyName: "seacrhMethod", keyValue: "CCS")
            break
        default:
            seacrhMethod = "CCI"
            settingsMem.saveSettings(keyName: "seacrhMethod", keyValue: "CCI")
            break
        }
    }
    
    func updateSearchSegmentedControl(selectedSeg : String) {
        switch selectedSeg {
        case "CCI":
            searchSegment.selectedSegmentIndex = 0
            break
        case "CCS":
            searchSegment.selectedSegmentIndex = 1
            break
        default:
            searchSegment.selectedSegmentIndex = 0
            break
        }
    }
        

}
