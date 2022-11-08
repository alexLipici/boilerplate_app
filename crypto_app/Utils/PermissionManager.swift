//
//  PermissionManager.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit
import Photos
import Contacts
import AVFoundation
import EventKit
import AppTrackingTransparency

enum Permission {
    case cameraUsage
    case photoLibraryUsage
    case microphoneUsage
    case calendar
    case locationWhenInUse
    case locationAlways
    case appTransparency
    case notifications
}

class PermissionManager: NSObject {
    
    // MARK: - Constants
    
    private let PHOTO_LIBRARY_PERMISSION = "TODO"
    private let CAMERA_USAGE_PERMISSION = "TODO"
    private let MICROPHONE_USAGE_ALERT = "TODO"
    private let CALENDAR_USAGE_ALERT = "TODO"
    private let LOCATION_USAGE_ALERT = "TODO"
    private let NOTIFICATIONS_USAGE_ALERT = "TODO"
    
    // MARK: - Variables
    
    private weak var parent: UIViewController?
    private var cachedCompletionHandler: ((_ accessGranted: Bool) -> Void)?
    private var requestedPermission: Permission?
    
    // MARK: - Initializers
    
    required init(parentViewController: UIViewController?) {
        super.init()
        
        self.parent = parentViewController
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appEnteredFromBackgroundAction),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    static var cameraPermissionGranted: Bool {
        get {
            return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        }
    }
    
    static var microphonePermissionGranted: Bool {
        get {
            return AVAudioSession.sharedInstance().recordPermission == .granted
        }
    }
    
    static var locationPermissionGranted: Bool {
        get {
            let locationStatus = CLLocationManager().authorizationStatus
            return locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse
        }
    }
    
    static var locationServicesEnabled: Bool {
        get {
            return CLLocationManager.locationServicesEnabled()
        }
    }
    
    static var appTransparencyPermissionGranted: Bool {
        return ATTrackingManager.trackingAuthorizationStatus == .authorized
    }
    
    static var subscribedToPushNotifications: Bool {
        get {
            return UIApplication.shared.isRegisteredForRemoteNotifications
        }
    }
    
    // MARK: - Methods
    
    func requestAccessFor(
        _ permission: Permission,
        showGoToSettingsAlert: Bool,
        customGoToSettingsMessage: String? = nil,
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        self.requestedPermission = nil
        
        switch permission {
            
            case .cameraUsage:
                
                requestCameraPermission(showGoToSettingsAlert: showGoToSettingsAlert,
                                        customGoToSettingsMessage: customGoToSettingsMessage,
                                        completionHandler: completionHandler)
                
            case .photoLibraryUsage:
                
                requestPhotoLibraryUsage(showGoToSettingsAlert: showGoToSettingsAlert,
                                         customGoToSettingsMessage: customGoToSettingsMessage,
                                         completionHandler: completionHandler)
                
            case .microphoneUsage:
                
                requestMicrophoneUsage(showGoToSettingsAlert: showGoToSettingsAlert,
                                       customGoToSettingsMessage: customGoToSettingsMessage,
                                       completionHandler: completionHandler)
                
            case .calendar:
                
                requestCalendarPermission(showGoToSettingsAlert: showGoToSettingsAlert,
                                          customGoToSettingsMessage: customGoToSettingsMessage,
                                          completionHandler: completionHandler)
                
            case .locationWhenInUse, .locationAlways:
                
                requestLocationPermission(permission,
                                          showGoToSettingsAlert: showGoToSettingsAlert,
                                          customGoToSettingsMessage: customGoToSettingsMessage,
                                          completionHandler: completionHandler)
       
            case .appTransparency:
                
                requestAppTransparencyPermission(completionHandler: completionHandler)
                
            case .notifications:
                
                requestNotificationsPermission(showGoToSettingsAlert: showGoToSettingsAlert,
                                               customGoToSettingsMessage: customGoToSettingsMessage,
                                               completionHandler: completionHandler)
        }
    }
    
    private func requestCameraPermission(
        showGoToSettingsAlert: Bool,
        customGoToSettingsMessage: String? = nil,
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
                
            case .authorized:
                
                completionHandler(true)
                
            case .denied:
                
                guard showGoToSettingsAlert else { return completionHandler(false) }
                
                showSettingsAlert(.cameraUsage,
                                  message: customGoToSettingsMessage ?? CAMERA_USAGE_PERMISSION,
                                  completionHandler)
                
            case .restricted, .notDetermined:
                
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    
                    completionHandler(granted)
                }
                
            @unknown default:
                completionHandler(false)
        }
    }
    
    private func requestPhotoLibraryUsage(
        showGoToSettingsAlert: Bool,
        customGoToSettingsMessage: String? = nil,
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        switch PHPhotoLibrary.authorizationStatus() {
                
            case .authorized, .limited:
                
                completionHandler(true)
                
            case .denied:
                
                guard showGoToSettingsAlert else { return completionHandler(false) }
                
                showSettingsAlert(.photoLibraryUsage,
                                  message: customGoToSettingsMessage ?? PHOTO_LIBRARY_PERMISSION,
                                  completionHandler)
                
            case .restricted, .notDetermined:
                
                PHPhotoLibrary.requestAuthorization { (status) in
                    completionHandler(status == .authorized)
                }
                
            @unknown default:
                completionHandler(false)
        }
    }
    
    private func requestMicrophoneUsage(
        showGoToSettingsAlert: Bool,
        customGoToSettingsMessage: String? = nil,
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        switch AVAudioSession.sharedInstance().recordPermission {
                
            case .granted:
                
                completionHandler(true)
                
            case .denied:
                
                guard showGoToSettingsAlert else { return completionHandler(false) }
                
                showSettingsAlert(.microphoneUsage,
                                  message: customGoToSettingsMessage ?? MICROPHONE_USAGE_ALERT,
                                  completionHandler)
                
            case .undetermined:
                
                AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                    
                    completionHandler(granted)
                })
                
            @unknown default:
                completionHandler(false)
        }
    }
    
    private func requestCalendarPermission(
        showGoToSettingsAlert: Bool,
        customGoToSettingsMessage: String? = nil,
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        switch EKEventStore.authorizationStatus(for: .event) {
                
            case .notDetermined:
                
                let eventStore = EKEventStore()
                
                eventStore.requestAccess(to: .event) { (granted, error) in
                    
                    completionHandler(granted)
                }
                
            case .restricted:
                
                completionHandler(false)
                
            case .denied:
                
                guard showGoToSettingsAlert else { return completionHandler(false) }
                
                showSettingsAlert(.calendar,
                                  message: customGoToSettingsMessage ?? CALENDAR_USAGE_ALERT,
                                  completionHandler)
                
            case .authorized:
                
                completionHandler(true)
                
            @unknown default:
                
                completionHandler(false)
        }
    }
    
    private func requestLocationPermission(
        _ permission: Permission,
        showGoToSettingsAlert: Bool,
        customGoToSettingsMessage: String? = nil,
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        let locationManager = CLLocationManager()
        
        switch locationManager.authorizationStatus {
                
            case .notDetermined:
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                if permission == .locationAlways {
                    locationManager.requestAlwaysAuthorization()
                } else {
                    locationManager.requestWhenInUseAuthorization()
                }
                
                self.cachedCompletionHandler = completionHandler
                
            case .restricted:
                
                completionHandler(false)
                
            case .denied:
                
                guard showGoToSettingsAlert else { return completionHandler(false) }
                
                showSettingsAlert(permission,
                                  message: customGoToSettingsMessage ?? LOCATION_USAGE_ALERT,
                                  completionHandler)
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                completionHandler(true)
                
            @unknown default:
                
                completionHandler(false)
        }
    }
    
    private func requestAppTransparencyPermission(
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        switch ATTrackingManager.trackingAuthorizationStatus {
            
        case .authorized: completionHandler(true)
            
        case .notDetermined:
            
            ATTrackingManager.requestTrackingAuthorization { authorizationStatus in
                switch authorizationStatus {
                case .authorized: completionHandler(true)
                default: completionHandler(false)
                }
            }
            
        default: completionHandler(false)
        }
    }
    
    private func requestNotificationsPermission(
        showGoToSettingsAlert: Bool,
        customGoToSettingsMessage: String? = nil,
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] notifStatus in
            
            guard let self = self else { return }
            
            switch notifStatus.authorizationStatus {
                    
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    completionHandler(true)
                }
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, _ in
                    
                    DispatchQueue.main.async {
                        if granted {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                        completionHandler(granted)
                    }
                }
                    
            case .denied:
                    
                guard showGoToSettingsAlert else { return completionHandler(false) }
                
                self.showSettingsAlert(.notifications,
                                       message: customGoToSettingsMessage ?? self.NOTIFICATIONS_USAGE_ALERT,
                                       completionHandler)
                
            default: completionHandler(false)
            }
        }
    }
    
    private func showSettingsAlert(
        _ permission: Permission,
        message: String,
        _ completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        let alert = UIAlertController(
            title: "Attention!",
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        let goToSettingsItem = UIAlertAction(title: "Go to settings", style: .default) { [weak self] _ in
            
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settingsUrl) {
                
                self?.requestedPermission = permission
                self?.cachedCompletionHandler = completionHandler
                
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsUrl) {
            
            alert.addAction(goToSettingsItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            completionHandler(false)
        }
        
        alert.addAction(cancelAction)
        
        parent?.present(alert, animated: false)
    }
    
    @objc private func appEnteredFromBackgroundAction() {
        
        guard
            let cachedPermission = self.requestedPermission,
            let cachedCompletion = self.cachedCompletionHandler
        else {
            return
        }
        
        requestAccessFor(
            cachedPermission,
            showGoToSettingsAlert: false,
            completionHandler: cachedCompletion
        )
    }
}

extension PermissionManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        cachedCompletionHandler?(status == .authorizedAlways || status == .authorizedWhenInUse)
        cachedCompletionHandler = nil
    }
}
