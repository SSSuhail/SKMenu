
//
//  SideMenuViewController.swift
//  SideMenu
//
//  Created by Suhail.Shabir on 29/04/19.
//  Copyright © 2019 Suhail Shabir. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
   
  var menuItems = ["A","B","C","D"]
  
  enum CellIdentifiers {
    static let menuOptionCell = "cell"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.reloadData()
   tableView.tableFooterView = UIView()
  }
}

// MARK: Table View Data Source
extension SideMenuViewController: UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return menuItems.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //TODO: Customize menu Cell as per requirement
      let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.menuOptionCell, for: indexPath)
      cell.textLabel?.text = menuItems[indexPath.row]
      
      return cell
   }
}

// Mark: Table View Delegate
extension SideMenuViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      switch indexPath.row {
      case 0:
         ContainerViewController.default.centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "a") as? MainViewController
      case 1:
         ContainerViewController.default.centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "b")
      case 2:
         ContainerViewController.default.centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "c")
      case 3:
         ContainerViewController.default.centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "d")
      default:
         return
      }
      ContainerViewController.default.setUpContainerView()
   }
}
