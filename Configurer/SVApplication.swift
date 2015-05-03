//
//  SVApplication.swift
//  Configurer
//
//  Created by Sebastien Villar on 02/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation
import Cocoa

class SVApplication : NSObject {
  private let path: String
  private var element: AXUIElementRef?
  private var pid: pid_t?
  private var launchObserver: NSObjectProtocol?
  private var launchCallbacks = Array<Void -> Void>()
  
  lazy var window: SVWindow? = { [unowned self] in
    var windowElement: AXUIElementRef? = self.element?.getAttribute(kAXMainWindowAttribute)
    if windowElement != nil {
      return SVWindow(element: windowElement!)
    }
    
    return nil
  }()
  
  init(path: String) {
    self.path = path
    
    super.init()
    
    self.startObservingLaunch()
  }
  
  deinit {
    self.stopObservingLaunch()
  }
  
  func launch() {
    NSWorkspace.sharedWorkspace().launchApplication(self.path)
  }
  
  func observeLaunch(fn: Void -> Void) {
    self.launchCallbacks.append(fn)
  }
  
  private func startObservingLaunch() {
    self.launchObserver = NSWorkspace.sharedWorkspace().notificationCenter.addObserverForName(NSWorkspaceDidActivateApplicationNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] notification in
      if let dictionary: Dictionary = notification.userInfo {
        var runningApplication = dictionary[NSWorkspaceApplicationKey] as? NSRunningApplication
  
        // If current application activated
        var bundlePath = runningApplication?.bundleURL?.path
        if bundlePath != nil && bundlePath!.hasSuffix(self.path) {
          // Fill missing data
          self.pid = runningApplication?.processIdentifier
          self.element = AXUIElementCreateApplication(self.pid!).takeUnretainedValue()
          
          // Launch callbacks
          for callback in self.launchCallbacks {
            callback()
          }
          self.stopObservingLaunch()
        }
      }
    }
  }
  
  private func stopObservingLaunch() {
    if self.launchObserver != nil {
      NSWorkspace.sharedWorkspace().notificationCenter.removeObserver(self.launchObserver!)
      self.launchObserver = nil
    }
  }
}