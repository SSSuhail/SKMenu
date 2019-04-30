//
//  ContainerViewController.swift
//  SideMenu
//
//  Created by Suhail.Shabir on 29/04/19.
//  Copyright © 2019 DLT Labs. All rights reserved.
//  Copyright © 2019 Suhail Shabir. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
   
   enum SlideOutState {
      case bothCollapsed
      case leftMenuExpanded
      case rightMenuExpanded
   }
   
   var centerNavigationController: UINavigationController!
   var centerViewController: UIViewController!
   var leftViewController: SideMenuViewController!
   var rightViewController: SideMenuViewController?
   
   static let `default` = ContainerViewController()
   
   
   var currentState: SlideOutState = .bothCollapsed {
      didSet {
         let shouldShowShadow = currentState != .bothCollapsed
         showShadowForCenterViewController(shouldShowShadow)
      }
   }
   
   let centerPanelExpandedOffset: CGFloat = 100
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setUpContainerView()
   }
   
   func setUpContainerView()  {
      if centerNavigationController != nil{
         centerNavigationController.viewControllers = [centerViewController]
         collapseSidePanels()
      }
      else{
         centerNavigationController = UINavigationController(rootViewController: centerViewController)
      }
      view.addSubview(centerNavigationController.view)
      addChild(centerNavigationController)
      centerNavigationController.didMove(toParent: self)
      
      let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
      centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
      tapGesture.numberOfTapsRequired = 1
      centerNavigationController.view.addGestureRecognizer(tapGesture)
   }
}

// MARK: CenterViewController delegate
extension UIViewController: ContainerViewControllerDelegate {
   
   func toggleLeftPanel() {
      let notAlreadyExpanded = (ContainerViewController.default.currentState != .leftMenuExpanded)
      if notAlreadyExpanded {
         addLeftPanelViewController()
      }
      animateLeftPanel(shouldExpand: notAlreadyExpanded)
   }
   
   func toggleRightPanel() {
      let notAlreadyExpanded = (ContainerViewController.default.currentState != .rightMenuExpanded)
      if notAlreadyExpanded {
         addRightPanelViewController()
      }
      animateRightPanel(shouldExpand: notAlreadyExpanded)
   }
   
   func collapseSidePanels() {
      
      switch ContainerViewController.default.currentState {
      case .rightMenuExpanded:
         toggleRightPanel()
      case .leftMenuExpanded:
         toggleLeftPanel()
      default:
         break
      }
   }
   
   func addLeftPanelViewController() {
      if let leftMenu = ContainerViewController.default.leftViewController{
         addChildSidePanelController(leftMenu)
      }
      else{
         print("left menu is nil")
      }
   }
   
   func addChildSidePanelController(_ sidePanelController: SideMenuViewController) {
      //sidePanelController.delegate = centerViewController
      ContainerViewController.default.view.insertSubview(sidePanelController.view, at: 0)
      ContainerViewController.default.addChild(sidePanelController)
      sidePanelController.didMove(toParent: self)
   }
   
   func addRightPanelViewController() {
      if let rightMenu = ContainerViewController.default.rightViewController{
         addChildSidePanelController(rightMenu)
      }
   }
   
   func animateLeftPanel(shouldExpand: Bool) {
      
      if shouldExpand {
         ContainerViewController.default.currentState = .leftMenuExpanded
         animateCenterPanelXPosition(targetPosition: ContainerViewController.default.centerNavigationController.view.frame.width - ContainerViewController.default.centerPanelExpandedOffset)
         
      } else {
         animateCenterPanelXPosition(targetPosition: 0) { _ in
            ContainerViewController.default.currentState = .bothCollapsed
            //ContainerViewController.default.leftViewController?.view.removeFromSuperview()
         }
      }
   }
   
   func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
         ContainerViewController.default.centerNavigationController.view.frame.origin.x = targetPosition
      }, completion: completion)
   }
   
   func animateRightPanel(shouldExpand: Bool) {
      
      if shouldExpand {
         ContainerViewController.default.currentState = .rightMenuExpanded
         animateCenterPanelXPosition(targetPosition: -ContainerViewController.default.centerNavigationController.view.frame.width + ContainerViewController.default.centerPanelExpandedOffset)
         
      } else {
         animateCenterPanelXPosition(targetPosition: 0) { _ in
            ContainerViewController.default.currentState = .bothCollapsed
            ContainerViewController.default.rightViewController?.view.removeFromSuperview()
         }
      }
   }
   
   func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
      if shouldShowShadow {
         ContainerViewController.default.centerNavigationController.view.layer.shadowOpacity = 0.8
      } else {
         ContainerViewController.default.centerNavigationController.view.layer.shadowOpacity = 0.0
      }
   }
}

// MARK: Gesture recognizer
extension ContainerViewController: UIGestureRecognizerDelegate {
   
   @objc func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
      animateCenterPanelXPosition(targetPosition: 0) { _ in
         self.currentState = .bothCollapsed
         self.leftViewController?.view.removeFromSuperview()
      }
   }
   
   @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
      
      let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
      
      switch recognizer.state {
         
      case .began:
         if currentState == .bothCollapsed {
            if gestureIsDraggingFromLeftToRight {
               addLeftPanelViewController()
            } else {
               return
               //TODO: Handle right Menu
               //addRightPanelViewController()
            }
            showShadowForCenterViewController(true)
         }
         
      case .changed:
         if gestureIsDraggingFromLeftToRight { // Handling only left Menu
            if let rview = recognizer.view {
               rview.center.x = rview.center.x + recognizer.translation(in: view).x
               recognizer.setTranslation(CGPoint.zero, in: view)
            }
         }
      case .ended:
         //TOTO: Need To find out how to differentiate left and right
         if let _ = leftViewController,
            let rview = recognizer.view {
            // animate the side panel open or closed based on whether the view has moved more or less than halfway
            let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
            animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            
         }
         else if let _ = rightViewController,
            let rview = recognizer.view {
            let hasMovedGreaterThanHalfway = rview.center.x < 0
            animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
         }
      default:
         break
      }
   }
}
