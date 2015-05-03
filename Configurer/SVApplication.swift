//
//  SVApplication.swift
//  Configurer
//
//  Created by Sebastien Villar on 02/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation
import Cocoa

let LAUNCH_CALLBACKS_DISPATCH_DURATION = Int64(0.2 * pow(10,9)) // nanoseconds
let TIMEOUT_DURATION = NSTimeInterval(5) // seconds

class SVApplication : NSObject {
  private let path: String
  private var element: AXUIElementRef?
  private var pid: pid_t?
  private var launchObserver: NSObjectProtocol?
  private var launchCallbacks = Array<Void -> Void>()
  private var launchCallbacksTimeoutDate: NSDate?
  
  var window: SVWindow? {
    get {
      var windowElement: AXUIElementRef? = self.element?.getAttribute(kAXMainWindowAttribute)
      if windowElement != nil {
        return SVWindow(element: windowElement!)
      }
      
      return nil
    }
  }
  
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
          self.stopObservingLaunch()
          self.runLaunchCallbacks()
        }
      }
    }
  }
  
  private func runLaunchCallbacks() {
    if (self.launchCallbacksTimeoutDate == nil) {
      self.launchCallbacksTimeoutDate = NSDate().dateByAddingTimeInterval(TIMEOUT_DURATION)
    }
    
    // Timed out
    if NSDate().compare(self.launchCallbacksTimeoutDate!) == NSComparisonResult.OrderedDescending {
      return
    }
    
    // If window exists, launch callbacks
    if self.window != nil {
      for callback in self.launchCallbacks {
        callback()
      }
    }
    
    // Else delay callbacks until it exists or times out
    else {
      var dispatch = dispatch_time(DISPATCH_TIME_NOW, LAUNCH_CALLBACKS_DISPATCH_DURATION)
      dispatch_after(dispatch, dispatch_get_main_queue()) { [weak self] in
        self?.runLaunchCallbacks()
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