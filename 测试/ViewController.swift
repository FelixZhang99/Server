//
//  ViewController.swift
//  测试
//
//  Created by Zhangfutian on 15/12/22.
//  Copyright © 2015年 Zhangfutian. All rights reserved.
//

import UIKit
var width :CGFloat!
var height : CGFloat!
var text = ""
class ViewController: UIViewController,UITextFieldDelegate {

    var log = UITextView()
    let tf = UITextField()
    var label = UILabel()
    var connect = [wificonnect]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        width = self.view.bounds.width
        height = self.view.bounds.height
        
        label = UILabel(frame: CGRectMake(width/4, height/10, width/3, 30))
        label.text = IP.deviceIPAddress()
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
      
        
        log = UITextView(frame: CGRectMake(width/6, height/6, 2*width/3, 7*height/12))
        log.editable = false
        log.layer.borderWidth = 1
        log.layer.borderColor = UIColor.blackColor().CGColor
        log.text = "Hello\n"
        self.view.addSubview(log)
        text = log.text
        
        tf.frame = CGRectMake(width/6, 13*height/16, 2*width/3, height/16)
        tf.layer.borderColor = UIColor.blackColor().CGColor
        tf.layer.borderWidth = 1
        tf.keyboardType = UIKeyboardType.Default
        tf.delegate = self
        self.view.addSubview(tf)
        
       
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "read", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning () {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.tf.transform = CGAffineTransformMakeTranslation(0, -200)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
      tf.frame = CGRectMake(width/6, 13*height/16, 2*width/3, height/16)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == tf{
        tf.resignFirstResponder()
        for c in connect{
            c.write(tf.text!)
        }
        tf.text = ""
        }else{
            for i in 0...9{
                let newc = wificonnect()
                connect.append(newc)
                connect[i].setsocket(56660+i)
            }
        }
        return true
    }
    
    func read(){
        if log.text != text{
            log.text = text
            
        }
    }

    func send(){
        
    }

}

