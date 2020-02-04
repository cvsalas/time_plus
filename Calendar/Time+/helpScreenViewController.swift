//
//  helpScreenViewController.swift
//  Time+
//
//  Created by Roee Landesman on 2/3/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class helpScreenViewController: UIViewController {

    @IBAction func returnHomeSegue(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: 100, height: 100)
        preferredContentSize = size
        // Do any additional setup after loading the view.
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
