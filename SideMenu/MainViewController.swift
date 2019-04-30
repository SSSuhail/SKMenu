//
//  MainViewController.swift
//  SideMenu
//
//  Created by Suhail.Shabir on 29/04/19.
//  Copyright © 2019 Suhail Shabir. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
   }
   @IBAction func openMenu(_ sender: UIButton) {
      toggleLeftPanel()
   }
}

