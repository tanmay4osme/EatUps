//
//  SendInviteViewController.swift
//  EatUps
//
//  Created by Marissa Bush on 7/11/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit
import AlamofireImage
import SRCountdownTimer

class SendInviteViewController: UIViewController, SRCountdownTimerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectedUser: User?
    
    var didNotRespondAlertController = UIAlertController(title: "User did not respond", message: "Please select another user", preferredStyle: .alert)
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        APIManager.shared.resetStatus(userID: (self.selectedUser?.id)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure send invite user views
        nameLabel.text = selectedUser?.name
        if let url = selectedUser?.profilePhotoUrl {
            profileImage.af_setImage(withURL: url)
        }
        
        // Configure timer views
        let timerRect = CGRect(x: 200, y: 200, width: 100, height: 100)
        let timer = SRCountdownTimer(frame: timerRect)
//        timer.center = timerLabel.center
        timer.start(beginingValue: 60)
        
        // Configure alert controller
        let backAction = UIAlertAction(title: "Go Back", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
            APIManager.shared.resetStatus(userID: (self.selectedUser?.id)!)
        }
        didNotRespondAlertController.addAction(backAction)
        
        // Do any additional setup after loading the view.
    }
    
    func timerDidEnd() {
        self.present(self.didNotRespondAlertController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
