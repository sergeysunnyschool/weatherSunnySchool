//
//  WeatherCollectionViewCell.swift
//  Weather
//
//  Created by Local Express on 08.04.21.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let id = "WeatherCollectionViewCell"
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureTemp(_ temp: Temp) {
        tempLabel.text = temp.value?.toTemperature
        dateLabel.text = temp.dt?.toInervaleSince1970Date.toString()
    }

}
