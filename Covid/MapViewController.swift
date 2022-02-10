//
//  MapViewController.swift
//  Covid
//
//  Created by Jay on 2022/01/13.
//

import CoreLocation
import MapKit
import RxSwift
import Then
import UIKit

final class MapViewController: UIViewController, CLLocationManagerDelegate {

    var mapView = MKMapView()
    private let currentLocationButton = UIButton()
    private let centerLocationButton = UIButton()

    private var locationManager = CLLocationManager()
    private var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var hospitalLocation: CLLocationCoordinate2D
    private var centerAnnotation = MKPointAnnotation()
    private let disposeBag = DisposeBag()
    
    init(lat: String, lng: String, hospitalTitle: String) {
        let lat = Double(lat) ?? 0
        let lng = Double(lng) ?? 0
        hospitalLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        super.init(nibName: nil, bundle: nil)
        centerAnnotation.title = hospitalTitle
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkLocationAccess()
    }

}
extension MapViewController{
    
    private func setupView() {
        view.backgroundColor = .white
        title = "지도"
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }

        view.addSubview(currentLocationButton)
        view.addSubview(centerLocationButton)

        currentLocationButton.do {
            $0.backgroundColor = .blue
            $0.setTitle("현재위치로", for: .normal)
        }

        centerLocationButton.do {
            $0.backgroundColor = .red
            $0.setTitle("접종 센터로", for: .normal)
        }

        currentLocationButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(30)
            $0.centerY.equalToSuperview().offset(180)
        }
        centerLocationButton.snp.makeConstraints {
            $0.left.equalTo(mapView).offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(30)
            $0.top.equalTo(currentLocationButton.snp.bottom).offset(20)
        }
        
        let coordinateRegion = MKCoordinateRegion(center: hospitalLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)

        centerAnnotation.coordinate = hospitalLocation

        mapView.addAnnotation(centerAnnotation)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true

        locationManager.rx.didUpdateLocations
            .compactMap { $0.first?.coordinate }
            .bind(to: rx.currentLocation)
            .disposed(by: disposeBag)

        currentLocationButton.rx.tap
            .withUnretained(mapView)
            .subscribe(onNext: { mapView, _ in
                mapView.setUserTrackingMode(.follow, animated: true)
            })
            .disposed(by: disposeBag)

        centerLocationButton.rx.tap
            .withUnretained(mapView)
            .subscribe(onNext: { mapView, _ in
                mapView.setRegion(coordinateRegion, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func checkLocationAccess(){
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController(title: "오류 발생", message: "위치 서비스 기능이 꺼져있음", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            let alert = UIAlertController(title: "오류 발생", message: "위치 서비스 제공 불가", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
}
