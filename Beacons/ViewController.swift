//
//  ViewController.swift
//  Beacons
//
//  Created by Mac Bellingrath on 8/6/15.
//  Copyright © 2015 Mac Bellingrath. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!

    var timer: NSTimer?
    var time = 0
    
    
    @IBOutlet weak var distanceReading: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        view.backgroundColor = UIColor.grayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - CLLocationManager Methods
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                
                //Ranging is the ability to determine the distance from Beacon (so we check availability)
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                    
                }
            
            }

        }

    }
    
    func startScanning(){
        let uuid = NSUUID(UUIDString: "B0702880-A295-A8AB-F734-031A98A512DE")
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 123, minor: 456, identifier: "MyBeacon")
        locationManager.startRangingBeaconsInRegion(beaconRegion)
        locationManager.startMonitoringForRegion(beaconRegion)
    }
    func updateDistance(distance: CLProximity){
        UIView.animateWithDuration(0.8){ [unowned self] in
            switch distance {
            
            
                //if already .near && recordtimeIsRunning .) return 
                
            case .Far:
                self.distanceReading.text = "Far"
                self.view.backgroundColor = UIColor.blueColor()
    
                
            case .Near:
                self.distanceReading.text = "Near"
                self.view.backgroundColor = UIColor.orangeColor()
                
                //startRecordingTime
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "printTime", userInfo: nil, repeats: true)
                
                
            case .Unknown:
                self.distanceReading.text = "Unknown"
                self.view.backgroundColor = UIColor.grayColor()
            case .Immediate:
                self.distanceReading.text = "Immediate"
                self.view.backgroundColor = UIColor.redColor()
                
                
            }
            
        }
    }
    
    func printTime() {
        time++
        print(time)
    }
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0] as CLBeacon
            updateDistance(beacon.proximity)
            
        } else {
            updateDistance(.Unknown)
        }
    }
    
}