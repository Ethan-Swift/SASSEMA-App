//
//  LocationSensor.swift
//  Project4
//
//  Created by Sofia Dimotsi on 7/12/22.
//

//LocationSensor class collects data related to the location of the user. It creates a dictionary and it then writes the dictionary on a json file


import Foundation
import UIKit
import SwiftUI
import CoreLocation
import CoreTelephony
import MapKit


    

class LocationSensor:  NSObject,  UITextFieldDelegate, CLLocationManagerDelegate {
    
     private var locations: [MKPointAnnotation] = []
     var locationNeed: [CLLocation]!
       
    @objc private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.distanceFilter = 50               //setting minimum meters 50
        manager.desiredAccuracy = kCLLocationAccuracyKilometer  //Getting the meters, kilometers etc
        manager.requestWhenInUseAuthorization() //requesting authorization from user to collect when app in use
        manager.requestAlwaysAuthorization()  //requesting authorization from the user to collect the location data
        
        manager.pausesLocationUpdatesAutomatically = false
        manager.allowsBackgroundLocationUpdates = true//upgrading location in the background
        manager.showsBackgroundLocationIndicator = true //for always access to location services
        return manager
    }()
        
    
    func StartUpdatingAction(_ sender: UIButton){
        sender.isSelected = !sender.isSelected       //if the button is selected (touchUpInside)
        if sender.isSelected{
            locationManager.startUpdatingLocation()//start gathering information regarding the location of the user
        }else{
            locationManager.stopUpdatingLocation()  // if the user did not click on the button, stop updating the current location
        }
    }
    
     func launchingPage2(sender: UIButton){
         locationManager.requestWhenInUseAuthorization()
         StartUpdatingAction(sender)
         locationManager.startUpdatingLocation()
         locationManager.location
        }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //creating the dictionary for the location file
        //print("heyyy")
        let userLocation :CLLocation = locations[0] as CLLocation
        var locationsDictionary = [String : Any]()
        
        //creating the device id and appending it to the dictionary
        let uid = UIDevice.current.identifierForVendor?.uuidString
        locationsDictionary["deviceid"] = uid
        locationsDictionary["userid"] = uid
       
        //creating the accurancy and appending it to the dictionary
        locationsDictionary["accurancy"] = userLocation.horizontalAccuracy
        
        // Setup the Network Info and create a CTCarrier object
        let networkInfo = CTTelephonyNetworkInfo()
        //let carrier = networkInfo.serviceSubscriberCellularProviders

        // Get carrier name
        let netInfo = CTTelephonyNetworkInfo()
        let carrier = netInfo.serviceSubscriberCellularProviders?.filter({ $0.value.carrierName != nil }).first?.value
        let udid = UIDevice.current.identifierForVendor?.uuidString
        let version = UIDevice.current.systemVersion
        let modelName = UIDevice.current.model
        //print((carrier))
        locationsDictionary["provider"] = "nil"//carrier //why nil?
        locationsDictionary["os"] = modelName
        locationsDictionary["version"] = version
        
       //Getting Speed
        let speed =  (locations.first?.speed)
        locationsDictionary["speed"] = speed
    
        //accurancy
        let ccor = (locations.first?.courseAccuracy)
        
        let deviceType = UIDevice.current
      
        // finding the longitude and latitude and appending them to dictionary
        locationsDictionary["latitude"] = Double(userLocation.coordinate.latitude)
        locationsDictionary["longitude"] = Double(userLocation.coordinate.longitude)
        locationsDictionary["sensorType"] = "location"

        //appending sense start times, calling the functions
        locationsDictionary["senseStartTimeMillis"] = getSenseTime()
        locationsDictionary["senseStartTime"] = getSenseStartTime()
      
        //Sofia, July 13th, file saving logic comes here
        
        /*
        let fileName = " \(uid!)_Location_\(getSenseTime())"
        let documentDirectoryUrl = try! FileManager.default.url(
              for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
           )
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("log")
           // prints the file path
           print("File path \(fileUrl.path)")
           //data to write in file.
        let stringData = locationsDictionary.description
           do {
              try stringData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
           } catch let error as NSError {
              print (error)
           }
        */
        
        print(locationsDictionary)
        Save().writeData(uid: uid!, sensor: "Location", startTimeMillis: getSenseTime(), data: locationsDictionary)
        /*
       let geocoder = CLGeocoder()
       geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
           if (error != nil){
                print("error in reverseGeocode")
            }
           let placemark = placemarks! as [CLPlacemark]
        if placemark.count>0{
            let placemark = placemarks![0]
            print(placemark.locality!)
            print(placemark.administrativeArea!)
            print(placemark.country!)

            }
        }
         */
        //Thread.sleep(forTimeInterval: 600)

    }
    
    func getSenseTime()->Int64{
        //calculating the sense time in millisec and appending it to the dictionary
        return Date().millisecondsSince1970
    }
    
    func getSenseStartTime()->String{
        //calculating the date and appending it to the dictionary
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
       return RFC3339DateFormatter.string(from: Date())
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
  
    func createconfig() -> UIButton.Configuration{
        let config: UIButton.Configuration = .filled()  //filling it with the tint color, background
        return config
    }
    
    func createconfigStop()-> UIButton.Configuration{
        let config2: UIButton.Configuration = .filled()
        return config2
    }
    

}
