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
  let configuration: SVApplicationsConfiguration
  var applications = [SVApplication]()
  var observer: NSObject?
  
  init(configuration: SVApplicationsConfiguration) {
    self.configuration = configuration
  }
  
  func run() {
    var screen = SVScreen(screen: NSScreen.mainScreen()!)
    
    // Launch window apps
    for config in self.configuration.windowConfigurations {
      switch config {
      case .Window(let path, let area):
        var application = SVApplication(path: path)
        self.applications.append(application)
        
        application.observeLaunch() {
          application.window?.rect = screen.rectForArea(area)
        }
        
        application.launch()
      default:
        break
      }
    }
    
    // Lauch fullScreen apps
    self.launchFullScreenAppAtIndex(0)
  }
  
  private func launchFullScreenAppAtIndex(index: Int) {
    var fullScreenConfigs = self.configuration.fullScreenConfigurations;
    if (fullScreenConfigs.count <= index) {
      return;
    }
        
    var config = fullScreenConfigs[index]
    
    switch config {
    case .FullScreen(let path):
      var application = SVApplication(path: path)
      self.applications.append(application)
      
      application.observeLaunch() { [weak self] in
        application.window?.setFullScreen();
        self?.launchFullScreenAppAtIndex(index + 1)
      }
      
      application.launch()
    default:
      break
    }
  }
}