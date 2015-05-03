//
//  SVApplicationsManager.swift
//  Configurer
//
//  Created by Sebastien Villar on 03/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation
import Cocoa

class SVApplicationsManager: NSObject {
  let operations: [String: kSVScreenArea]
  var applications = [SVApplication]()
  var observer: NSObject?
  
  init(operations: Dictionary<String, kSVScreenArea>) {
    self.operations = operations
  }
  
  func run() {
    var screen = SVScreen(screen: NSScreen.mainScreen()!)
    
    for (path, area) in self.operations {
      var application = SVApplication(path: path)
      self.applications.append(application)
      
      application.observeLaunch() {
        application.window?.rect = screen.rectForArea(area)
      }
      
      application.launch()
      
    }
  }
}