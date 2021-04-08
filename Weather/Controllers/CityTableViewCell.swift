//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Local Express on 01.04.21.
//

import UIKit

protocol WeatherHandler: class {
    func cityWeatherError(_ cell: UITableViewCell, cityName: String, error: Error)
}

class CityTableViewCell: UITableViewCell {
    
    static let id = "CityTableViewCell"

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sunriseDateLabel: UILabel!
    @IBOutlet weak var sunsetDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: WeatherHandler?
    var weathers: Weathers? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowView.layer.shadowRadius = 10
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
    }
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: WeatherCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: WeatherCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setup(city: City) {
//        self.city = city
        cityNameLabel.text = city.name
        if let weather = city.weathers, let temp = weather.temp.first?.value, let sunset = weather.sunset, let sunrise = weather.sunrise {
            weathers = weather
            self.temperatureLabel.text = temp.toTemperature
            let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunset))
            let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunrise))
            sunriseDateLabel.text = sunriseDate.toString()
            sunsetDateLabel.text = sunsetDate.toString()
            return
        } else {
            getTemperature(for: city)
        }
    }
    
    func configureWeathers(_ weathers: Weathers) {
        if let temp = weathers.temp.first?.value {
            self.temperatureLabel.text = temp.toTemperature
        }
        if let sunset = weathers.sunset, let sunrise = weathers.sunrise {
            let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunset))
            let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunrise))
            sunriseDateLabel.text = sunriseDate.toString()
            sunsetDateLabel.text = sunsetDate.toString()
        }
    }
            
    func getTemperature(for city: City) {
        guard let cityName = city.name else {
            return
        }
        Network.shared.getWaether(cityName: cityName, unit: .imperial) {[weak self] (json, error) in
            guard let self = self else {
                return
            }
//            print(json)
            if let error = error {
                self.delegate?.cityWeatherError(self, cityName: city.name ?? "", error: error)
                return
            }
            if let json = json {
                let weathers = Weathers(json)
                self.weathers = weathers
                city.weathers = weathers
                self.configureWeathers(weathers)
            }
        }
    }
    
}

extension CityTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers?.temp.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.id, for: indexPath) as? WeatherCollectionViewCell, let temps = weathers?.temp else {
            return UICollectionViewCell()
        }
        let temp = temps[indexPath.row]
        cell.configureTemp(temp)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96, height: collectionView.bounds.size.height)
    }
    
}
