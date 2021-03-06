//
//  CalcViewController.swift
//  TinyCalc
//
//  Created by Braeden Atlee on 4/21/17.
//  Copyright © 2017 Braeden Atlee. All rights reserved.
//

import Cocoa

class CalcViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var inputField: NSTextField!
    @IBOutlet weak var answerField: NSTextField!
    
    @IBOutlet weak var CopyOnReturn: NSMenuItem!
    
    var popover: NSPopover? = nil
    
    override func viewDidAppear() {
        inputField.selectText(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputField.becomeFirstResponder()
        inputField.delegate = self
        
        if UserDefaults.standard.object(forKey: "copyOnEnter") == nil{
            UserDefaults.standard.set(false, forKey: "copyOnEnter")
        }else{
            if UserDefaults.standard.bool(forKey: "copyOnEnter") {
                CopyOnReturn.state = NSControl.StateValue.on
            }else{
                CopyOnReturn.state = NSControl.StateValue.off
            }
        }
    
    }
    
    @IBAction func quitOption(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func controlTextDidChange(_ obj: Notification) {
        do{
            try answerField.stringValue = Evaluator.evaluate(input: inputField.stringValue)
            //answerField.textColor = NSColor.controlTextColor
        }catch{
            answerField.stringValue = "..."
        }
    }
    
    override func cancelOperation(_ sender: Any?) {
        if (popover?.isShown)! {
            popover?.performClose(sender)
        }
    }
    
    @IBAction func copyOnReturnToggle(_ sender: NSMenuItem) {
        
        if CopyOnReturn.state == NSControl.StateValue.on {
            CopyOnReturn.state = NSControl.StateValue.off
            UserDefaults.standard.set(false, forKey: "copyOnEnter")
        } else if CopyOnReturn.state == NSControl.StateValue.off {
            CopyOnReturn.state = NSControl.StateValue.on
            UserDefaults.standard.set(true, forKey: "copyOnEnter")
        }
    }
    
    @IBAction func copyAnswer(_ sender: NSMenuItem?) {
        let pasteboard = NSPasteboard.general;
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(answerField.stringValue, forType: NSPasteboard.PasteboardType.string)
    }
    
    @IBAction func textChanged(_ sender: NSTextField) {
        if inputField.stringValue == "quit" {
            NSApplication.shared.terminate(self)
        }
        do{
            try answerField.stringValue = Evaluator.evaluate(input: inputField.stringValue)
            
            if UserDefaults.standard.bool(forKey: "copyOnEnter") {
                copyAnswer(nil)
            }
            
        }catch let e as String{
            answerField.stringValue = e
        }catch{
            answerField.stringValue = "Unknown Error"
        }
    }
    
    
    
    
}
