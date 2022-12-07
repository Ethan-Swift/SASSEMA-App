//
//  File.swift
//  Location
//
//  Created by Ethan Swift on 7/6/22.
//
import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork
import Network
import NetworkExtension



class WiFiSensor: NSObject {
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    
    func getWiFiBssid() -> String? {
        var bssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
                    break
                }
            }
        }
        return bssid
    }
    
    //Creates Wifi Dictionary
    func createDict() {
        let save = Save()
        
            let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
            var status: String = "not working"
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    print("We're connected!")
                    status = "Connected"
                } else {
                    print("No connection.")
                    status = "No Connection"
                }

                //print(path.isExpensive)
            }
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
            
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            var wifiDictionary = [String : Any]()
            wifiDictionary["deviceid:"] = UIDevice.current.identifierForVendor?.uuidString
            wifiDictionary["senseStartTimeMillis:"] = Int(round(NSDate().timeIntervalSince1970*1000))
            wifiDictionary["sensorType:"] = "WiFi"
            wifiDictionary["SSID:"] = String(getWiFiSsid() ?? "nil")
            wifiDictionary["BSSID:"] = String(getWiFiBssid() ?? "nil")
            wifiDictionary["Capabilities"] = "nil"
            wifiDictionary["RSSI"] = "nil"
            wifiDictionary["MAC Address"] = "nil"
            wifiDictionary["State"] = status
            wifiDictionary["os"] = UIDevice.current.model
            wifiDictionary["version"] = UIDevice.current.systemVersion
            wifiDictionary["senseStartTime"] = RFC3339DateFormatter.string(from: Date())
            print(wifiDictionary)
            save.writeData(uid: wifiDictionary["deviceid:"] as! String, sensor: "WiFi", startTimeMillis: Int64(wifiDictionary["senseStartTimeMillis:"] as! Int), data: wifiDictionary)
           // Thread.sleep(forTimeInterval: 15)
        
    }
}
