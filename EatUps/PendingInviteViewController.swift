//
//  SendInviteViewController.swift
//  EatUps
//
//  Created by Marissa Bush on 7/11/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit
import AlamofireImage
import FirebaseDatabase
import SRCountdownTimer
import ChameleonFramework

class PendingInviteViewController: UIViewController, SRCountdownTimerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timer: SRCountdownTimer!

    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!

    var selectedUser: User?

    var eatupId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [HexColor(hexString: "FE8F72"), HexColor(hexString: "FE3F67")])
        
        APIManager.shared.checkResponse(selectedUser: selectedUser!, eatupId: eatupId!) { (success) in
            if success == true {
                self.performSegue(withIdentifier: "pendingToFindSegue", sender: nil)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
        }

        // Configure send invite user views
        nameLabel.text = selectedUser?.name
        if let url = selectedUser?.profilePhotoUrl {
            profileImage.af_setImage(withURL: url)
        }
        User.getRoundProfilePics(photoView: profileImage)

        // Configure alert controller
        let backAction = UIAlertAction(title: "Go Back", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
            APIManager.shared.resetStatus(userID: (self.selectedUser?.id)!)
            
        }
        
        // Timer setup
        timer.start(beginingValue: 60)
        timer.backgroundColor = UIColor(white: 0, alpha: 0)
        timer.isOpaque = false
        timer.lineColor = .white
        timer.lineWidth = 4.0
        timer.trailLineColor = .clear
        timer.labelTextColor = .white
        
    }



    @IBAction func didTapCancel(_ sender: Any) {
        APIManager.shared.resetStatus(userID: (self.selectedUser?.id)!)
        APIManager.shared.resetStatus(userID: (User.current?.id)!)
        ref.child("eatups/\(eatupId)").removeValue()
        self.dismiss(animated: true, completion: nil)
    }

    func timerDidEnd() {
        APIManager.shared.checkResponse(selectedUser: selectedUser!, eatupId: eatupId!) { (success) in
            if success == true {
                self.performSegue(withIdentifier: "pendingToFindSegue", sender: nil)
            }
            else {
                    APIManager.shared.resetStatus(userID: (self.selectedUser?.id)!)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pendingToFindSegue" {
            let FindUpeeViewController = segue.destination as! FindUpeeViewController
            FindUpeeViewController.selectedUser = selectedUser
            FindUpeeViewController.eatupId = eatupId
        }
    }

}
