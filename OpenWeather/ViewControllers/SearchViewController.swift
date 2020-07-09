//
//  SearchController.swift
//  OpenWeather
//
//  Created by MineDest on 7/2/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewController: UISearchController {
    var cityListTableView: UITableView?
    var locationManager = LocationManager()
    var fetcher: GMSAutocompleteFetcher?
    var placesClient: GMSPlacesClient?
    var cityList: CityList?
    var filter = GMSAutocompleteFilter()
    var delegat: BackToMainVCDelegat?

    override func viewDidLoad() {
        showTableView()
        cityListTableView?.delegate = self
        cityListTableView?.dataSource = self
        searchBar.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()
        self.fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        self.fetcher?.delegate = self
        self.fetcher?.provide(token)
    }
    func showTableView() {
        cityListTableView = UITableView(frame: .zero, style: .plain)
        self.view.backgroundColor = cityListTableView?.backgroundColor?.withAlphaComponent(0.7)
        cityListTableView?.backgroundColor = .clear
        cityListTableView?.rowHeight = 50
        self.cityListTableView?.frame = CGRect.init(origin: CGPoint(x: .zero, y: searchBar.bounds.height + 5),
                                                    size: self.view.frame.size)
        guard let cityListTableView = cityListTableView else {
            return
        }
        self.view.addSubview(cityListTableView)
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinate = Coordinate(latitude: cityList?[indexPath.row].coord.latitude ?? 0,
                                    longtitude: cityList?[indexPath.row].coord.longitude ?? 0)
        let city = cityList?[indexPath.row].name ?? ""
        delegat?.update(coordinate: coordinate, city: city)
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "City")
        cell.backgroundColor = .clear
        guard cityList?.count != 0 else {
            return cell
        }
        cell.detailTextLabel?.text = cityList?[indexPath.row].fullName
        cell.textLabel?.text = cityList?[indexPath.row].name
        cell.textLabel?.frame = .zero
        return cell
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetcher?.sourceTextHasChanged(searchText)
        cityListTableView?.reloadData()
    }
}
extension SearchViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        cityList = CityList()
        placesClient = GMSPlacesClient()
        for prediction in predictions {
            guard let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) |
                UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.name.rawValue))  else {
                    return
            }
            self.placesClient?.fetchPlace(fromPlaceID: prediction.placeID,
                                          placeFields: fields,
                                          sessionToken: nil,
                                          callback: { (place: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    guard let city = place.formattedAddress?.capitalized else {
                        return
                    }
                    self.cityList?.append(CityListElement(name: place.name ?? "",
                                                          fullName: city,
                                                          coord: place.coordinate))
                }
                                            DispatchQueue.main.async {
                                                self.cityListTableView?.reloadData()
                                            }
            })
        }
    }
    func didFailAutocompleteWithError(_ error: Error) {
    }
}

protocol BackToMainVCDelegat {
    func update(coordinate: Coordinate, city: String)
}
