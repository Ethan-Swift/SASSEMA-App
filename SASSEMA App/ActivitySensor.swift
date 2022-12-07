//
//  ActivitySensor.swift
//  Project4
//
//  Created by Sofia Dimotsi on 7/13/22.
//
//ActivitySensor class collects data related to the activity of the user. It creates a dictionary and it then writes the dictionary on a json file


import SwiftUI
import Foundation
import CoreLocation
import CoreTelephony
import UIKit
import DeviceActivity
import CoreMotion


class ActivitySensor:  NSObject {

    func activity(){
        
        var activityDictionary = [String : Any]()  //creating activityDictionary
        var InsideDictionary = [String : Any]()    //creating a dictionary to be inside of the activityDictionary for confidence and type of activity
        
        //creating the device id and appending it to the dictionary
        let uid = UIDevice.current.identifierForVendor?.uuidString
        activityDictionary["deviceid"] = uid
        activityDictionary["userid"] = uid
        var orientationString: String = ""
        var conf:   Int = 0
        var conf2 : Int = 0
        var conf3: String = ""
            
        let motionManager = CMMotionManager()
        let motionActivityManager = CMMotionActivityManager()
        if CMMotionActivityManager.isActivityAvailable() {
                motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                    if (motion?.stationary)! {
                        orientationString = "Still"}
                    else if(motion?.unknown)!{
                        orientationString = "Unknown"
                    }else{
                        orientationString = "Tilt"
                    }
                    
                    if motion?.confidence == CMMotionActivityConfidence.low {
                       conf3 = "Low"
                    } else if motion?.confidence == CMMotionActivityConfidence.medium {
                        conf3 = "Good"
                    } else if motion?.confidence == CMMotionActivityConfidence.high {
                        conf3 = "High"
                    }
                }
            }
        
        print(conf3)
        print(orientationString)
        
    
        if motionManager.isDeviceMotionAvailable {

             motionManager.deviceMotionUpdateInterval = 0.1
             print("hey1")
             print(motionManager.isDeviceMotionActive)
          //   conf = CMMotionActivityConfidence(rawValue: Int(motion.attitude.pitch))
             print(conf)
            if CMMotionActivityManager.isActivityAvailable() {
                    motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                        if (motion?.stationary)! {
                            orientationString = "Still"}
                        else if(motion?.unknown)!{
                            orientationString = "Unknown"
                        }else{
                            orientationString = "Tilt"
                        }
                       
                        conf = (motion?.confidence.rawValue)!
                        if motion?.confidence == CMMotionActivityConfidence.low {
                           conf3 = "Low"
                        } else if motion?.confidence == CMMotionActivityConfidence.medium {
                            conf3 = "Good"
                        } else if motion?.confidence == CMMotionActivityConfidence.high {
                            conf3 = "High"
                        }
                    }
             InsideDictionary["Confidence"] = conf
            }
        }
        else {
             orientationString = "No Activity Data" //"Still"
             let motion = CMMotionActivity()
             let isActivityAvailable = CMMotionActivityManager.isActivityAvailable()
             conf2 =  motion.confidence.rawValue
             InsideDictionary["Confidence"] = conf2
          }
     
        InsideDictionary["Activity"] = orientationString
        activityDictionary["applicationResult"] = InsideDictionary
        
        activityDictionary["sensor type"] = "Activity"
        
        let udid = UIDevice.current.identifierForVendor?.uuidString
       
        let version = UIDevice.current.systemVersion
        let modelName = UIDevice.current.model
        activityDictionary["os"] = modelName
        activityDictionary["version"] = version

        
        let deviceType = UIDevice.current
      

        //appending sense start times, calling the functions
        activityDictionary["senseStartTimeMillis"] = getSenseTime()
        activityDictionary["senseStartTime"] = getSenseStartTime()
        
        //Sofia, July 13th, file saving logic comes here
        /*
        let fileName = " \(uid!)_Activity_\(getSenseTime())"
        let documentDirectoryUrl = try! FileManager.default.url(
              for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
           )
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("log")
           // prints the file path
           print("File path \(fileUrl.path)")
           //data to write in file.
        let stringData = activityDictionary.description
           do {
              try stringData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
           } catch let error as NSError {
              print (error)
           }
         */
        print(activityDictionary)
        Save().writeData(uid: uid!, sensor: "Activity", startTimeMillis: getSenseTime(), data: activityDictionary)
      
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
    
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
