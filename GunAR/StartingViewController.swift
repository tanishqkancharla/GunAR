//
//  StartingViewController.swift
//  GunAR
//
//  Created by Tanishq Kancharla on 1/9/18.
//  Copyright © 2018 Tanishq Kancharla. All rights reserved.
//

import Foundation
import UIKit



class StartingViewController: UIViewController, UIPickerViewDelegate {
    
    func numberOfComponents(in: UIPickerView){
       
    }
    
    
    @IBOutlet weak var numberOfPlayersLabel: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func numberOfPlayersChosen(_ sender: Any) {
        
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
