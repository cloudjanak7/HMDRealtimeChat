//
//  UIDevice.swift
//  Fitness
//
//  Created by Thinh Truong on 11/22/16.
//  Copyright © 2016 Reflect Apps Inc. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height {
        case 480.0:
            fallthrough
        case 960.0:
            return .iPhone4
        case 1136.0:
            return .iPhone5
        case 1334.0:
            return .iPhone6
        case 2208.0:
            return .iPhone6Plus
        default:
            return .Unknown
        }
    }
    
}

// MARK: - UIDevice Extension -

private let DeviceList = [
    /* iPod 5 */          "iPod5,1": "iPod Touch 5",
    /* iPhone 4 */        "iPhone3,1": "iPhone 4",
                          "iPhone3,2": "iPhone 4",
                          "iPhone3,3": "iPhone 4",
    /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
    /* iPhone 5 */        "iPhone5,1": "iPhone 5",
                          "iPhone5,2": "iPhone 5",
    /* iPhone 5C */       "iPhone5,3": "iPhone 5C",
                          "iPhone5,4": "iPhone 5C",
        /* iPhone 5S */ "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
    /* iPhone 6 */        "iPhone7,2": "iPhone 6",
  /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
/* iPhone 6S */       "iPhone8,1": "iPhone 6S",
                      /* iPhone 6S Plus */  "iPhone8,2": "iPhone 6S Plus",
                                            /* iPhone SE */       "iPhone8,4": "iPhone SE",
                                                                                                      /* iPhone 7 */        "iPhone9,1": "iPhone 7",
                                                                                                                            /* iPhone 7 */        "iPhone9,3": "iPhone 7",
                                                                                                                                                  /* iPhone 7 Plus */   "iPhone9,2": "iPhone 7 Plus",
                                                                                                                                                                        /* iPhone 7 Plus */   "iPhone9,4": "iPhone 7 Plus",
                                                                                                                                                                                              /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
                                                                                                                                                                                                                    /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3":     "iPad 3",
                                                                                                                                                                                                                                          /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
                                                                                                                                                                                                                                                                /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
                                                                                                                                                                                                                                                                                      /* iPad Air 2 */      "iPad5,1": "iPad Air 2", "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
                                                                                                                                                                                                                                                                                                            /* iPad Mini */       "iPad2,5": "iPad Mini 1", "iPad2,6": "iPad Mini 1", "iPad2,7": "iPad Mini 1",
                                                                                                                                                                                                                                                                                                                                  /* iPad Mini 2 */     "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2",
                                                                                                                                                                                                                                                                                                                                                        /* iPad Mini 3 */     "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3",
                                                                                                                                                                                                                                                                                                                                                                              /* iPad Pro 12.9 */   "iPad6,7": "iPad Pro 12.9", "iPad6,8": "iPad Pro 12.9",
                                                                                                                                                                                                                                                                                                                                                                                                    /* iPad Pro  9.7 */   "iPad6,3": "iPad Pro 9.7", "iPad6,4": "iPad Pro 9.7",
                                                                                                                                                                                                                                                                                                                                                                                                                          /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"
]

extension UIDevice {
    
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        
        var identifier = ""
        
        for child in mirror.children {
            if let value = child.value as? Int8, value != 0 {
                identifier += String(UnicodeScalar(UInt8(value)))
            }
        }
        return identifier
    }
    
    //check is enable UIImpactFeedbackGenerator
    static var isSupportHapticFeedback: Bool {
        
        var modelName = self.modelName
        
        if modelName.contains("iPad"){
            return false
        }
        
        modelName = modelName.replace(target: "iPhone", withString: "")
        let range = (modelName as NSString).range(of: ",")
        if range.location != NSNotFound{
            modelName = modelName.substringTo(index: range.location)
        }
        if let intValue = Int(modelName){
            if intValue > 8{
                return true
            }
        }
        
        return false
        
    }
    
    static func vibrate(){
        if #available(iOS 10.0, *) {
            if self.isSupportHapticFeedback{
                let feedbackGenerator = UIImpactFeedbackGenerator.init(style: .heavy)
                
                // Prepare the generator when the gesture begins.
                feedbackGenerator.prepare()
                feedbackGenerator.impactOccurred()
                return
            }
        }
        
        // Fallback on earlier versions
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    static var isIphone4: Bool {
        return modelName == "iPhone 4S" || modelName == "iPhone 4" || UIDevice.isSimulatorIPhone4
    }
    
    static var isIphone5: Bool {
        return modelName == "iPhone 5" || modelName == "iPhone 5C" || modelName == "iPhone 5S" || UIDevice.isSimulatorIPhone5
    }
    
    static var isIphone6: Bool {
        return modelName == "iPhone 6" || UIDevice.isSimulatorIPhone6
    }
    static var isIphone6Plus: Bool {
        return modelName == "iPhone 6 Plus" || UIDevice.isSimulatorIPhone6Plus
    }
    
    static var isIpad: Bool {
        if UIDevice.current.model.contains("iPad") {
            return true
        }
        return false
    }
    
    static var isIphone: Bool {
        return !self.isIpad
    }
    
    /// Check if current device is iPhone4S (and earlier) relying on screen heigth
    static var isSimulatorIPhone4: Bool {
        return UIDevice.isSimulatorWithScreenHeigth(480)
    }
    
    /// Check if current device is iPhone5 relying on screen heigth
    static var isSimulatorIPhone5: Bool {
        return UIDevice.isSimulatorWithScreenHeigth(568)
    }
    
    /// Check if current device is iPhone6 relying on screen heigth
    static var isSimulatorIPhone6: Bool {
        return UIDevice.isSimulatorWithScreenHeigth(667)
    }
    
    /// Check if current device is iPhone6 Plus relying on screen heigth
    static var isSimulatorIPhone6Plus: Bool {
        return UIDevice.isSimulatorWithScreenHeigth(736)
    }
    
    private static func isSimulatorWithScreenHeigth(_ heigth: CGFloat) -> Bool {
        let screenSize: CGRect = UIScreen.main.bounds
        return modelName == "Simulator" && screenSize.height == heigth
    }
    
    
}