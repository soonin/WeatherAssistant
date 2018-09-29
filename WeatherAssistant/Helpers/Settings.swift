//
//  Settings.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-27.
//  Copyright © 2018 Pooya. All rights reserved.
//

import Foundation

// for save and lode value by key over UserDefaults.standard
// to keep them even in case app completely closed
class DefaultsSettings {
    
    // save value by key over UserDefaults.standard permanet storage
    func saveSettings(keyName: String, keyValue: String){
        UserDefaults.standard.set(keyValue, forKey: keyName)
    }
    
    // load value by key over UserDefaults.standard permanet storage
    func loadSettings(keyName: String) -> String {
        return UserDefaults.standard.string(forKey: keyName) ?? ""
    }
    
    // check only if value by key not exist update the value for the key
    func checkSettingsStat(keyName : String, newKeyValue : String) -> String {
        var existingVal : String = loadSettings(keyName: keyName)
        if ( existingVal == "" ) {
            existingVal = newKeyValue
        } 
        return existingVal
    }
    
    
}
