//
//  InterfaceController.swift
//  WatchKitAccelerometer WatchKit Extension
//
//  Created by Stéphane Lux on 21.04.16.
//  Copyright © 2016 LUXio IT-Solutions. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var xPicker: WKInterfacePicker!
    @IBOutlet var yPicker: WKInterfacePicker!
    @IBOutlet var zPicker: WKInterfacePicker!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    let motionMgr = CMMotionManager()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.xPicker.setItems(pickerItems)
        self.yPicker.setItems(pickerItems)
        self.zPicker.setItems(pickerItems)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        motionMgr.accelerometerUpdateInterval = 0.1
        
        if motionMgr.accelerometerAvailable {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
                self.setOffset(data!.acceleration.x, forPicker: self.xPicker)
                self.setOffset(data!.acceleration.y, forPicker: self.yPicker)
                self.setOffset(data!.acceleration.z, forPicker: self.zPicker)
                if (error == nil) {
                    self.statusLabel.setText("tracking")
                } else {
                    self.statusLabel.setText(error?.localizedDescription)
                }
            }
            motionMgr.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        } else {
            statusLabel.setText("no data available")
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        motionMgr.stopAccelerometerUpdates()
    }
    
    var pickerItems:[WKPickerItem] {
                var items: [WKPickerItem] = []
                var c = 100
                while c>=0 {
                    let name = String(format: "bar%d", c)
                    let img = WKImage.init(imageName: name)
                    let item = WKPickerItem()
                    item.contentImage = img
                    items.append(item)
                    c -= 1
                }
                return items
    }
    
    func setOffset(offs: Double, forPicker picker: WKInterfacePicker) {
        var idx: Int = Int(50.0 + (offs * 50.0))
        if idx < 0 {idx = 0}
        if idx > 100 {idx = 100}
        picker.setSelectedItemIndex(idx)
        
    }
}
