//
//  ViewController.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-25.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // initial location in case of Location was off
    var keyLocationName = "East Palo Alto"
    var keyLat = "37.47"
    var keyLon = "-122.14"
    
    // collection view to show list of Bookmarked / Known locations
    // tableView was another option but Assignment asked for CollectionView 
    @IBOutlet weak var collectionView : UICollectionView!
    //Home page Tools Connections
    @IBOutlet weak var collectionSourceSeg: UISegmentedControl!
    @IBOutlet weak var searchForString: UITextField!
    @IBOutlet weak var serchBtn: UIButton!
    //navigation bar buttons Connections
    @IBOutlet weak var helpNavBtn: UIBarButtonItem!
    @IBOutlet weak var settingNavBtn: UIBarButtonItem!
    @IBOutlet weak var editNavBtn: UIBarButtonItem!
    @IBOutlet weak var addNavBtn: UIBarButtonItem!
    
    // relative number to scale font size based on device screen size
    let relativeFontWelcomeTitle:CGFloat = 0.045
    let relativeFontButton:CGFloat = 0.030
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
    var seacrhMethod : String = "def"
    var unitsInit : String = "metric"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update initial Value for Setting by app Storage
        collectionSource = settingsMem.checkSettingsStat(keyName: "collectionSource", newKeyValue: collectionSource)
        unitsInit = settingsMem.checkSettingsStat(keyName: "unitsInit", newKeyValue: unitsInit)
        seacrhMethod = settingsMem.checkSettingsStat(keyName: "seacrhMethod", newKeyValue: seacrhMethod)
        updatesegmentedControl(selectedSeg: collectionSource)

        //Customize Navigation
        navigationMaker()
        serchBtn.layer.cornerRadius = 5

        // delegate and dataSource
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.backgroundColor = UIColor.green
        

        // check for known pre-load plist if loaded or not
        if settingsMem.loadSettings(keyName: "preloadKnown") == "yes" {
            print("Known pre value already loaed")
        } else {
            let numberOfPreLoad = knownTools.preLoadFromPlist(forResource: "KnownLocations", ofType: "plist")
            print("number of preloaded  \(numberOfPreLoad)")
            if (numberOfPreLoad > 0) {
                settingsMem.saveSettings(keyName: "preloadKnown", keyValue: "yes")
            }
        }
        
        // fetch data to arrays
        bookmarkedArray = bookmarkedTools.fetchData()
        knownArray =  knownTools.fetchData()
        
        collectionView.reloadData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        // fetch data to arrays
        bookmarkedArray = bookmarkedTools.fetchData()
        knownArray =  knownTools.fetchData()
        
        collectionView.reloadData()
    }
    
    
    @IBAction func segmentedAct(_ sender: UISegmentedControl) {
        switch collectionSourceSeg.selectedSegmentIndex {
        case 0:
            collectionSource = "Bookmarked"
            settingsMem.saveSettings(keyName: "collectionSource", keyValue: "Bookmarked")
            collectionView.reloadData()
            break
        case 1:
            collectionSource = "Known"
            settingsMem.saveSettings(keyName: "collectionSource", keyValue: "Known")
            collectionView.reloadData()
            break
        default:
            collectionSource = "Bookmarked"
            settingsMem.saveSettings(keyName: "collectionSource", keyValue: "Bookmarked")
            collectionView.reloadData()
            break
        }
    }
    
    
    func updatesegmentedControl(selectedSeg : String) {
            switch selectedSeg {
            case "Bookmarked":
                collectionSourceSeg.selectedSegmentIndex = 0
                break
            case "Known":
                collectionSourceSeg.selectedSegmentIndex = 1
                break
            default:
                collectionSourceSeg.selectedSegmentIndex = 0
                break
        }
    }
    
    
    @IBAction func addAct(_ sender: UIBarButtonItem) {
        
        let vc =  storyboard?.instantiateViewController(withIdentifier: "AddPage") as? AddViewController
        vc?.keyLat = keyLat
        vc?.keyLon = keyLon
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func searchTextFieldAct(_ sender: UITextField) {
        let searchforVal = searchForString!.text
        knownArray = knownTools.searchInEntity(searchString: searchforVal!, searchType : seacrhMethod)
        bookmarkedArray = bookmarkedTools.searchInEntity(searchString: searchforVal!, searchType : seacrhMethod)
        print(knownArray)
        collectionView.reloadData()
    }
    
    
    @IBAction func searchAct(_ sender: UIButton) {
        let searchforVal = searchForString!.text
        if (searchforVal == "" ) {
            bookmarkedArray = bookmarkedTools.fetchData()
            knownArray =  knownTools.fetchData()
            
            collectionView.reloadData()
        } else {
            knownArray = knownTools.searchInEntity(searchString: searchforVal!, searchType : seacrhMethod)
            bookmarkedArray = bookmarkedTools.searchInEntity(searchString: searchforVal!, searchType : seacrhMethod)
            print(knownArray)
            
            collectionView.reloadData()
        }
    }
    
    
    @IBAction func editBarAct(_ sender: UIBarButtonItem) {
        if (editNavBtn.title == "Done" ) {
            editNavBtn.title = "Edit"
        }  else {
            editNavBtn.title = "Done"
        }
        self.collectionView.reloadData()
    }
    
    
    // UICollectionViewDelegate, UICollectionViewDataSource functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = (collectionSource == "Bookmarked") ?  bookmarkedArray.count : knownArray.count
        return numberOfItems
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let cellIndex = indexPath.item
        // Fix fonts size depend of the screen size
        let closeFrameSize = bestFrameSize()

        
        if (collectionSource == "Bookmarked") {
            let oneRecord = bookmarkedArray[cellIndex]
            cell.labelTitle.text = oneRecord.locationName
            cell.labelTitle.font = cell.labelTitle.font.withSize(closeFrameSize * relativeFontCellTitle)
            cell.labelDetails.text =  "Latitude: " + oneRecord.lat! + "°    Longitude: " + oneRecord.lon! + "°"
            cell.labelDetails.font = cell.labelDetails.font.withSize(closeFrameSize * relativeFontCellDescription)

        } else {
            let oneRecord = knownArray[cellIndex]
            cell.labelTitle.text = oneRecord.locationName
            cell.labelTitle.font = cell.labelTitle.font.withSize(closeFrameSize * relativeFontCellTitle)
            cell.labelDetails.text =  "Latitude: " + oneRecord.lat! + "°    Longitude: " + oneRecord.lon! + "°"
            cell.labelDetails.font = cell.labelDetails.font.withSize(closeFrameSize * relativeFontCellDescription)
        }
        
        if (editNavBtn.title == "Done" ) {
            cell.trashImg.isHidden = false
        }  else {
            cell.trashImg.isHidden = true
        }
        
        cell.labelDetails.textColor = UIColor(hex : "404040" )
        cell.labelTitle.textColor = UIColor(hex : "0000b3" )
        cell.trashImg.customizeDelete()
        cell.trashImg.titleLabel?.font = cell.labelDetails.font.withSize(closeFrameSize * relativeFontButton)
        
        // cell properties
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.masksToBounds = true
        //cell.backgroundColor = UIColor.lightGray
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        cell.index = indexPath
        cell.delegate = self
        return cell
    }
    
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        
        if let index = indexPath {
            print("Got clicked on index: \(index)!")
        }
        self.passData(index: indexPath!.item)
    }
    

    func navigationMaker()  {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        navigationItem.title = "Weather Assistant"
    }
    
} //end of ViewController



// extention for UICollectionViewDelegateFlowLayout
extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let heightMul : CGFloat = (heightVal < widthVal) ? 3.0 : 6.0
        
        return CGSize(width: bounds.width - 10   , height:  ( bounds.height / heightMul)  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}//end of extension  ViewController

