//
//  RxCLLocationManagerDelegateProxy.swift
//  RxExample
//
//  Created by Carlos García on 8/7/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

// MARK: - CLLocationManager + HasDelegate

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

// MARK: - RxCLLocationManagerDelegateProxy

public class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
    DelegateProxyType,
    CLLocationManagerDelegate
{

    // MARK: Lifecycle

    public init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }

    deinit {
        self.didUpdateLocationsSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }

    // MARK: Public

    public static func registerKnownImplementations() {
        register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
        didUpdateLocationsSubject.onNext(locations)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _forwardToDelegate?.locationManager?(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }

    // MARK: Internal

    internal lazy var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
    internal lazy var didFailWithErrorSubject = PublishSubject<Error>()

}
