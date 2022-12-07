//
//  ViewController.swift
//  Project4
//
//  Created by Sofia Dimotsi on 6/10/22.

// In this project the user enters the username and if it is longer than 6 digits then a new screen is launched with the SASSEMA logo. Once the screen is launched background process of collecting Location, Activity, and WiFi data starts. The data are being saved in jSON files.
//in order for the code to work I also had to add signing & configurations and in info tab -> Location privacy always and in usage etc. 


import SwiftUI
import Foundation
import CoreLocation
import CoreTelephony
import UIKit
import DeviceActivity

import CoreMotion


class ViewController: UIViewController{
    
    var myTextField: UITextField!
    var sumbitButton: UIButton!
    var usernameError: UILabel!
    var Activity = ActivitySensor()   //calling the classes of the sensors
    var Location = LocationSensor()
    var WiFi = WiFiSensor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CREATING THE LAUNCHING PAGE
        let graphics = CreateButtons()
        
        //creating the UILabel
        view.addSubview(graphics.UsernameLabel())
        
        //creating the LOGO image
        let im = graphics.getImage()
        im.frame = view.alignmentRect(forFrame: CGRect(x:110, y:300,width: 200,height: 50))
        view.addSubview(im)
        //view.snapshotView(afterScreenUpdates: true)
        
        //creating the text field
        myTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300.00, height: 30.00));
        myTextField.placeholder = "Enter Username"
        myTextField.borderStyle = UITextField.BorderStyle.line
        myTextField.backgroundColor = UIColor.white
        myTextField.textColor = UIColor.blue
        myTextField.keyboardType = .emailAddress
        myTextField.center = self.view.center
        view.addSubview(myTextField)
      
        //create the sumbitButton when clicked the collection of data begins
        sumbitButton = UIButton(frame: CGRect(x:100, y:500, width: 200, height: 50)) // creating the button and setting its sizes
        sumbitButton.addTarget(self,
                       action: #selector(launchingPage),
                       for: .touchUpInside
                )   //setting a target to the button. Target itself, with action the function of the launchingPage function which can be found below, when the button is touched and released
        sumbitButton.configuration = createconfig() //creating the virtual look of the button
        sumbitButton.tintColor = UIColor.blue   //changing the background color to blue
        sumbitButton.setTitle("Sumbit", for: .normal)  //setting the tittle
        sumbitButton.actions(forTarget: sumbitButton, forControlEvent: .touchUpInside)
        view.addSubview(sumbitButton)
        
        usernameError = UILabel(frame: CGRect(x:50, y:600, width: 2000,  height: 50)) //creating the label in case the username does not meet the requirements
    }
    
    
   @objc func launchingPage(_ sender: UIButton){
       var documentDirectoryUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

       documentDirectoryUrl.appendPathComponent("SASSEMA")

       let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

       let url = NSURL(fileURLWithPath: path)

       if let pathComponent = url.appendingPathComponent("SASSEMA") {
           
           let filePath = pathComponent.path
           
           let fileManager =  FileManager.default
           do {
               
               let f = try fileManager.contentsOfDirectory(atPath: path)
               
               try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
               
               let files =  try fileManager.contentsOfDirectory(atPath: filePath)
               if files.contains("userID.txt") {
                   present(SecondViewController(), animated: true)
               }
               else{
                   present(SecondViewController(), animated: true)
               }
               
           }
           catch {

               print(error)

           }
       }
     let str = myTextField.text!
     let boolval = isValidInput(Input: str)  //checking if username is valid through isValidInput function below
     if boolval != true{
            usernameError.text = "Invalid Username. Enter username again"
            usernameError.backgroundColor = .white
            usernameError.textColor = .red
            view.addSubview(usernameError)  //in case the username is invalid a message pops up to enter the username again
     }else{
         
         present(SecondViewController(), animated: true)  //if username is valid second view controller screen is launched with the SASSEMA logo
      //Once the second view controller pops up, we call the classes for the sensors. All of them create a unique dictionary and write it to a file
      // while true{
         let queue = DispatchQueue(label: "Wifi Loop")
         queue.async {
             while true {
                 ActivitySensor().activity()   //Calling activity class to start collecting activity data
                 WiFiSensor().createDict()//Calling WiFi class to start collecting WiFi data
                 Thread.sleep(forTimeInterval: 600)
             }
         }
         Location.launchingPage2(sender: sender) //Calling Location class to start collecting Location data
        // Thread.sleep(forTimeInterval: 15)
         //}
    }
}

      func isValidInput(Input: String) -> Bool {  //function checking if the username is valid (longer than 6 digits)
          let con = Input.count
          print(Input)
            if con <= 6{
              return false
          }else{
              return true
          }
        }
    
      func createconfig() -> UIButton.Configuration{
          let config: UIButton.Configuration = .filled()  //filling it with the tint color, background
          return config
      }
}


class SecondViewController: UIViewController {   //Second view controller pops up SASSEMA logo

    override func viewDidLoad() {
        super.viewDidLoad()
        view.snapshotView(afterScreenUpdates: true)
        view.backgroundColor = .white
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        imageView.contentMode = .scaleAspectFit
        if let newImage = UIImage(named: "sassema") {  //saving the jpg file at Assets of the project with the name sassema 
           imageView.image = newImage
        }
        self.view.addSubview(imageView)
}
}

class DataAgreementView: UIViewController {   //Second view controller pops up SASSEMA logo

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let text = UITextView
        let button = UIButton()
        button.frame.size = CGSize(width: 88.0, height: 44.0)
        button.center = self.view.center
        button.text = "Button"
        button.addTarget(self, action: Selector("buttonWasPressed"), forControlEvents: .TouchUpInside)
        self.view.addSubview(view: button)
        
}
}






