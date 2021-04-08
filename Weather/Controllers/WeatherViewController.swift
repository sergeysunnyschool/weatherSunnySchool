//
//  WeatherViewController.swift
//  Weather
//
//  Created by Local Express on 01.04.21.
//

import UIKit
import GooglePlaces

class WeatherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cityService = CityService()
    
    var cities = [City]()
    var opened = [Bool]()
    
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        configureTableView()
        configureCities()        
    }
    
    func configureCities() {
        cities = CityService().loadCities()
        opened = Array(repeating: false, count: cities.count)
        tableView.reloadData()
    }
    
    func startLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    
    func saveCity(_ city: City) {
        cityService.saveCity(city)
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: CityTableViewCell.id, bundle: nil), forCellReuseIdentifier: CityTableViewCell.id)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundView?.clipsToBounds = true
    }
    
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    

}
 
extension WeatherViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let city = City(name: place.name, lat: place.coordinate.latitude, lng: place.coordinate.longitude)
        saveCity(city)
        configureCities()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.id, for: indexPath) as! CityTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        let city = cities[indexPath.row]
        cell.setup(city: city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return opened[indexPath.row] ? 316 : 180
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let city = self.cities[indexPath.row]
            self.cityService.deleteCity(city)
            self.configureCities()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        opened[indexPath.row] = !opened[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension WeatherViewController: WeatherHandler {
    func cityWeatherError(_ cell: UITableViewCell, cityName: String, error: Error) {
        displayError(Errors.errorWeatherForCity(cityName: cityName, errorDescription: error.localizedDescription))
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager?.stopUpdatingLocation()
            getPlace(for: location) {[weak self] (placemark) in
                guard let self = self else {
                    return
                }
                if let cityName = placemark?.locality {
                    let city = City(name: cityName, lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                    self.saveCity(city)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
    
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      :
            locationManager?.startUpdatingLocation()
            print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        @unknown default:
            break
        }
    }
}
