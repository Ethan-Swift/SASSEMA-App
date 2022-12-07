//
//  CreateButtons.swift
//  Project4
//
//  Created by Sofia Dimotsi on 7/5/22.
//
//Declaring the graphics, made in order to make ViewController cleaner

import Foundation
import SwiftUI
import UIKit

class CreateButtons:  LocationSensor{

    func UsernameLabel() -> UILabel{
        let label = UILabel(frame:  CGRect(x:0, y:0, width: 300, height:210))
        label.center = CGPoint(x:200, y:400)
        label.textAlignment = .center
        label.text = "Username"
        return label
    }
        
    func getImage() -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x:70, y:150, width: 200,height: 50))
        imageView.contentMode = .scaleAspectFit
        if let newImage = UIImage(named: "sassema") {
              imageView.image = newImage
           }
        return imageView
    }
    
    
    func startButton() -> UIButton{
        let startButton = UIButton(frame: CGRect(x:100, y:300, width: 200, height: 50)) // creating the button and setting its sizes
        startButton.addTarget(self,
               action: "scheduleNoti",
               for: .touchUpInside
           )   //setting a target to the button. Target itself, with action the function of scheduling notification, when the button is touched and released
    
       startButton.configuration = createconfig() //creating the virtual look of the button
       startButton.tintColor = UIColor.blue   //changing the background color to blue
       startButton.setTitle("Start", for: .normal)  //setting the tittle
       startButton.actions(forTarget: startButton, forControlEvent: .touchUpInside)
       return startButton
    }
    
    func stopButton() -> UIButton{
        let stopButton = UIButton(frame: CGRect(x:100, y:400, width: 200,height: 50)) // creating the button and setting its sizes
        stopButton.addTarget(self,
                            action: "stopNoti",
                             for: .touchUpInside)       //setting a target to the button. Target itself, with action the function of removing  notifications, when the button is touched and released (touchUpInside). TouchDown choice would mean that the action starts when the user clicks the button.
     
        stopButton.configuration = createconfigStop() //creating the virtual look of the button
        stopButton.setTitle("Stop", for: .normal)
        stopButton.tintColor = UIColor.magenta //changing the background color
        return stopButton //making the button visible on launch screen
    }
    
    func locationButton() -> UIButton {
        let LocationButton = UIButton(frame: CGRect(x:100, y:500, width: 200, height: 50))   //create a button
       // LocationButton.setTitle(LocationButton.isSelected ? "Stop Updating" : "Start updating", for: .normal)
        LocationButton.tintColor = UIColor.gray
        LocationButton.configuration = UIButton.Configuration.filled()
       // LocationButton.addTarget(self, action: "StartUpdatingAction(_:))", for: .touchUpInside)
        LocationButton.addTarget(self,
                       action: "launchingPage2",
                       for: .touchUpInside
                )   //setting a target to the button. Target itself, with action the function of launchingPage2 (function inside locationSensor class), when the button is touched and released
        LocationButton.actions(forTarget: LocationButton, forControlEvent: .touchUpInside)
        return LocationButton
    }
    
}
