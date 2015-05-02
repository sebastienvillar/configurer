//
//  SVApplication.swift
//  Configurer
//
//  Created by Sebastien Villar on 02/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation

class SVApplication : NSObject {
  private let element: AXUIElementRef
  private let pid: pid_t
  
  lazy var window: SVWindow? = {
    var windowElement: AXUIElementRef? = self.element.getAttribute(kAXMainWindowAttribute)
    if windowElement != nil {
      return SVWindow(element: windowElement!)
    }
    
    return nil
  }()
  
  init(pid: pid_t) {
    self.pid = pid
    self.element = AXUIElementCreateApplication(pid).takeUnretainedValue()
    
    super.init()
  }
}