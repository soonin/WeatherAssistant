//
//  CollectionViewCell.swift
//  WeatherAssistant
//
//  Created by Pooya on 2018-09-27.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit

protocol DataCollectionProtocol {
    func passData(index : Int)
    func deleteData(index : Int)
}

class CollectionViewCell: UICollectionViewCell {
   
    var delegate : DataCollectionProtocol?
    var index : IndexPath?
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var trashImg: UIButton!
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        delegate?.deleteData(index: (index?.row)!)
    }
    
    
}
