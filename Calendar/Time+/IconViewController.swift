//
//  IconViewController.swift
//  Time+
//
//  Created by Amber Jaitrong on 2/14/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class IconViewController: UIViewController {
    
    var icon : UILabel!
    var icon_return : ((IconViewController) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func iconSet(sender: Any){
        let button = sender as! UIButton
        icon = button.titleLabel!
        icon_return(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func EllipsisButtom(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func doctorButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func medicineButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func tvButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func friendsButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func excerciseButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func foodButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func bookButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func cameraIcon(_ sender: Any) {
        iconSet(sender: sender)
    }
        
    @IBAction func chessButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func weightButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func entertainmentButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func musicButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func hammerIcon(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func songButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    
    @IBAction func gasButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func binoButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func hikingButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func campButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func skiButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    

    @IBAction func snowboardButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    
    
    @IBAction func snowButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    
    @IBAction func beachButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    
    @IBAction func briefCaseButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func creditcardButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func gavelButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func graduateButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func hospitalButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func landmarkButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func phoneButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func prescriptionButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func shoppingButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func theaterButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func voteButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func showerButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func sleepButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func catButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func dogButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func coffeeButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func prayButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func anchorButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func bicycleButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func carButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    
    @IBAction func busButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func movingButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func planeButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func trainButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func walkingButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    
    @IBAction func babyButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func birthdayButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func partyButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func loveButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    @IBAction func homeButton(_ sender: Any) {
         iconSet(sender: sender)
    }
    
    
    @IBAction func baseballButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    
    @IBAction func basketballButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func bowlingButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func footballButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func soccerButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func golfButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func hockeyButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func skateButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func swimButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func pingpongButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    @IBAction func volleyballButton(_ sender: Any) {
        iconSet(sender: sender)
    }
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
