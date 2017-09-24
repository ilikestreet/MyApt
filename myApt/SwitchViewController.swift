//
//  SwitchViewController.swift
//  myHome
//
//  Created by Johnny Zhang on 2/9/17.
//  Copyright © 2017 Johnny Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SwitchViewController: UIViewController {
    
    @objc var userID = "jIj7eJqShJhw5yI2760DHFFGguf1"
    @objc var ref: DatabaseReference!
    @objc var fanStatus: Int = -1
    @objc let logController = LogCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    @objc let customBackground = UIColor(red: 254, green: 255, blue: 237)
    
    @objc let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    @objc let lightLabel: UILabel = {
        let label = UILabel()
        label.text = "Light:"
        label.textColor = UIColor.black
//        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc let fanLabel: UILabel = {
        let label = UILabel()
        label.text = "Fan:"
        label.textColor = UIColor.black
//        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc let lightSwitch: UISwitch = {
       let sw = UISwitch()
//        sw.backgroundColor = UIColor.red
        sw.isUserInteractionEnabled = false
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    @objc let fanStatusLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.black
//        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        getLogFromFirebase()
    }
    
    
   override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(contentView)
        contentView.addSubview(lightLabel)
        contentView.addSubview(fanLabel)
        contentView.addSubview(lightSwitch)
        contentView.addSubview(fanStatusLabel)
        
        setupContentViewConstraint()
        setupLightLabelViewConstraint()
        setupLightSwitchViewConstraint()
        setupFanLabelViewConstraint()
        setupFanStatusLabelViewConstraint()
        fanStatusLabel.text = String(fanStatus)

        setupNetwork()
        setupLightSwitch()
        setupGesture()

    }
    
    
    @objc func setupNetwork(){
        let email = "ilikestreet.jz@gmail.com"
        let password = "Abc110110119"
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            //Print into the console if successfully logged in
            print("You have successfully logged in")

        }
        
//        userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child(self.userID)
        
        

    }

    
    @objc func setupLightSwitch() {
        let checkingAlert = UIAlertController(title: "Checking Status", message: "Please wait", preferredStyle: .alert)
        self.present(checkingAlert, animated: true, completion: nil)
        
        ref.child("lastLightCommand").observe(DataEventType.value, with: { (snapshot) in
            if let value = snapshot.value as? String {
                self.lightSwitch.setOn(value == "LIGHT ON", animated: true)
                if self.lightSwitch.isOn {
                    self.contentView.backgroundColor = self.customBackground
                    self.view.backgroundColor = self.customBackground
                    self.lightLabel.textColor = UIColor.black
                    self.fanLabel.textColor = UIColor.black
                    self.fanStatusLabel.textColor = UIColor.black
                    UIApplication.shared.statusBarStyle = .default
                    self.setNeedsStatusBarAppearanceUpdate()
                }
                else {
                    self.contentView.backgroundColor = UIColor.black
                    self.view.backgroundColor = UIColor.black
                    self.lightLabel.textColor = self.customBackground
                    self.fanLabel.textColor = self.customBackground
                    self.fanStatusLabel.textColor = self.customBackground
                    UIApplication.shared.statusBarStyle = .lightContent
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            }
        })
        
        checkingAlert.dismiss(animated: true, completion: nil)
    }
    
    

        
    
    
    @objc func setupGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeAction))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeAction))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        let oneFingerTap = UITapGestureRecognizer(target: self, action: #selector(handleOneFingerTap))
        view.addGestureRecognizer(oneFingerTap)

        let leftEdgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeLeftEdge))
        leftEdgeSwipe.edges = .left
        view.addGestureRecognizer(leftEdgeSwipe)
    }

    
       
    
        
    
    @objc func setupContentViewConstraint() {
        // x, y, width, height
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    @objc func setupLightLabelViewConstraint() {
        // x, y, width, height
        lightLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        lightLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lightLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
        lightLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    
    @objc func setupLightSwitchViewConstraint() {
        // x, y, width, height
        lightSwitch.leftAnchor.constraint(equalTo: lightLabel.rightAnchor, constant: 55).isActive = true
        lightSwitch.topAnchor.constraint(equalTo: lightLabel.topAnchor, constant: 15).isActive = true
    }
    
    @objc func setupFanLabelViewConstraint() {
        // x, y, width, height
        fanLabel.leftAnchor.constraint(equalTo: lightLabel.leftAnchor).isActive = true
        fanLabel.topAnchor.constraint(equalTo: lightLabel.bottomAnchor).isActive = true
        fanLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
        fanLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    @objc func setupFanStatusLabelViewConstraint() {
        // x, y, width, height
        fanStatusLabel.leftAnchor.constraint(equalTo: fanLabel.rightAnchor).isActive = true
        fanStatusLabel.topAnchor.constraint(equalTo: fanLabel.topAnchor).isActive = true
        fanStatusLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
        fanStatusLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    @objc func handleSwipeAction(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .left && lightSwitch.isOn {
            //  Light Off
            ref.updateChildValues(["Command" : "LIGHT OFF"])
            ref.updateChildValues(["lastLightCommand" : "LIGHT OFF"])
            lightSwitch.setOn(false, animated: true)
            print("Light Off")
        }
        else if swipe.direction == .right && !lightSwitch.isOn{
            //  Light On
            ref.updateChildValues(["Command" : "LIGHT ON"])
            ref.updateChildValues(["lastLightCommand" : "LIGHT ON"])
            lightSwitch.setOn(true, animated: true)
            print("Light On")
        }
        
    }
    
    @objc func handleOneFingerTap(sender: UITapGestureRecognizer) {
        fanStatus += 1
        switch fanStatus {
            case 0:
                ref.updateChildValues(["Command" : "FAN ON/OFF"])
                print("FAN On/Off")
                break
            
            case 1...6:
                ref.updateChildValues(["Command" : "FAN SPEED"])
                print("FAN Speed")
                break
            
            case 7:
                ref.updateChildValues(["Command" : "FAN TURN"])
                print("FAN Turn")
                break
            
            default:
                fanStatus = -1
        }
        
        fanStatusLabel.text = String(fanStatus)
    }
    
    
    @objc func getLogFromFirebase(){

        ref.child("Log").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? NSDictionary {
                let logString = dic.map{"\($0):\($1)"}.joined(separator: "\n")
                let dataArray = logString.characters.split { $0 == "\n" }.map(String.init)
                self.logController.commandArray = dataArray
                self.logController.collectionView?.reloadData()

                
            }
            else {
                self.logController.commandArray = []
                print("None")
            }
        })
    }
    
    @objc func handleSwipeLeftEdge(gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionFade
            transition.subtype = kCATransitionFromLeft
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(logController, animated: false)
            print("left swipped")
        }
    }

}

extension UIColor{
    @objc convenience init(red: Float, green: Float, blue: Float) {
        self.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(1))
    }
}


