//
//  SVApplicationsConfiguration.swift
//  Configurer
//
//  Created by Sebastien Villar on 03/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation

enum kSVApplicationConfiguration {
  case FullScreen(String)
  case Window(String, kSVScreenArea)
}

class SVApplicationsConfiguration: NSObject {
  private(set) var fullScreenConfigurations = [kSVApplicationConfiguration]()
  private(set) var windowConfigurations = [kSVApplicationConfiguration]()
  
  func addApplicationConfiguration(configuration: kSVApplicationConfiguration) {
    switch configuration {
    case .FullScreen:
      self.fullScreenConfigurations.append(configuration)
      
    case .Window:
      self.windowConfigurations.append(configuration)
    }
  }
}