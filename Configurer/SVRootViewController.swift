//
//  SVRootViewController.swift
//  Configurer
//
//  Created by Sebastien Villar on 03/05/15.
//  Copyright (c) 2015 -. All rights reserved.
//

import Foundation
import Cocoa

private let TEXT_FIELD_SIZE = NSMakeSize(200, 30)
private let POPUP_BUTTON_SIZE = NSMakeSize(100, 30)
private let MARGIN: CGFloat = 10

private let INITIAL_PATHS = ["/Applications/Safari.app", "/Applications/Google Chrome.app", "/Applications/Sublime Text.app", "/Applications/Dash.app", "/Applications/VLC.app"];
private let INITIAL_AREAS = ["LeftHalf", "RightHalf", "BottomRightQuadran", "LeftHalf", "BottomRightQuadran"];

class SVRootViewController: NSViewController {
  private let addButton: NSButton
  private let executeButton: NSButton
  private var textFields: Array<NSTextField> = []
  private var popupButtons: Array<NSPopUpButton> = []
  private var checkboxes: Array<NSButton> = []
  private var applicationManager: SVApplicationsManager?
  
  required
  init?(coder: NSCoder) {
    self.addButton = NSButton()
    self.addButton.title = "Add"
    self.addButton.action = Selector("didClickAddButton")
    
    self.executeButton = NSButton()
    self.executeButton.title = "Execute"
    self.executeButton.action = Selector("didClickExecuteButton")
    
    super.init(coder: coder)
    
    self.addButton.target = self
    self.executeButton.target = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.addButton.frame = NSMakeRect(10, self.view.frame.size.height - 40, 30, 30)
    self.view.addSubview(self.addButton)
    
    self.executeButton.frame = NSMakeRect(self.view.frame.size.width - 70, self.view.frame.size.height - 40, 60, 30)
    self.view.addSubview(self.executeButton)
    
    for i in 0..<INITIAL_PATHS.count {
      self.createTextField()
      self.createPopupButton()
      self.createCheckbox()
      self.textFields[i].stringValue = INITIAL_PATHS[i]
      self.popupButtons[i].selectItemWithTitle(INITIAL_AREAS[i])
    }
  }
  
  func didClickAddButton() {
    self.createTextField()
    self.createPopupButton()
    self.createCheckbox()
  }
  
  func didClickExecuteButton() {
    var configuration = SVApplicationsConfiguration()
    
    for i in 0..<INITIAL_PATHS.count {
      var textField = self.textFields[i]
      var path = textField.stringValue
      
      var checkbox = self.checkboxes[i]
      var fullScreen = checkbox.state == NSOnState
      if fullScreen {
        configuration.addApplicationConfiguration(.FullScreen(path))
      }
      else {
        var popupButton = self.popupButtons[i]
        var area = kSVScreenArea(rawValue: popupButton.titleOfSelectedItem!)
        configuration.addApplicationConfiguration(.Window(path, area!))
      }
    }
    
    self.applicationManager = SVApplicationsManager(configuration: configuration)
    applicationManager?.run()
  }
  
  private func createTextField() {
    var position = NSZeroPoint
    if let lastTextField = self.textFields.last {
      position = NSMakePoint(lastTextField.frame.origin.x, lastTextField.frame.origin.y - lastTextField.frame.size.height - MARGIN)
    }
    else {
      position = NSMakePoint(self.addButton.frame.origin.x + self.addButton.frame.size.width + MARGIN, self.view.frame.size.height - TEXT_FIELD_SIZE.height - MARGIN)
    }
    
    var newTextField = NSTextField(frame: NSMakeRect(position.x, position.y, TEXT_FIELD_SIZE.width, TEXT_FIELD_SIZE.height))
    self.textFields.append(newTextField)
    self.view.addSubview(newTextField)
  }
  
  private func createPopupButton() {
    var position = NSZeroPoint
    if let lastTextField = self.textFields.last {
      position = NSMakePoint(lastTextField.frame.origin.x + lastTextField.frame.size.width + MARGIN, lastTextField.frame.origin.y)
    }
    
    var newPopupButton = NSPopUpButton(frame: NSMakeRect(position.x, position.y, POPUP_BUTTON_SIZE.width, POPUP_BUTTON_SIZE.height))
    
    for area in kSVScreenArea.allValues {
      newPopupButton.addItemWithTitle(area.rawValue)
    }
    
    self.popupButtons.append(newPopupButton)
    self.view.addSubview(newPopupButton)
  }
  
  private func createCheckbox() {
    var position: NSPoint = NSZeroPoint
    if let lastPopupButton = self.popupButtons.last {
      position = NSMakePoint(lastPopupButton.frame.origin.x + lastPopupButton.frame.size.width + MARGIN, lastPopupButton.frame.origin.y)
    }
    
    var newCheckbox = NSButton(frame: NSMakeRect(position.x, position.y, 20, 30))
    newCheckbox.setButtonType(NSButtonType.SwitchButton)
    
    self.checkboxes.append(newCheckbox)
    self.view.addSubview(newCheckbox)
  }
}