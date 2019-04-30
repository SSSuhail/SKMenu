//
//  ContainerViewControllerDelegate.swift
//  SideMenu
//
//  Created by Suhail.Shabir on 29/04/19.
//  Copyright © 2019 Suhail Shabir. All rights reserved.
//


import UIKit

@objc
protocol ContainerViewControllerDelegate {
  @objc optional func toggleLeftPanel()
  @objc optional func toggleRightPanel()
  @objc optional func collapseSidePanels()
}
