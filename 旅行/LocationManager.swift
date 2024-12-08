//
//  LocationManager.swift
//  旅行
//
//  Created by 若杉泰周 on 2024/12/07.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization() // 「常に許可」をリクエスト
    }
    
    func requestLocation() {
        isLoading = true
        locationManager.requestLocation()
    }
    
    // 位置情報が取得できた場合
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isLoading = false
        if let location = locations.first {
            DispatchQueue.main.async {
                self.location = location.coordinate
            }
        }
    }
    
    // 位置情報の取得に失敗した場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        print("Error getting location: \(error.localizedDescription)")
    }
    // 逆ジオコーディングで住所を取得
    func fetchAddress(from coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("逆ジオコーディングエラー: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let address = """
                \(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")
                """
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
}
