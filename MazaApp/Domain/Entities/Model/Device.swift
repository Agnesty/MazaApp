//
//  Device.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 15/09/25.
//

import Foundation
import UIKit

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6_7_8         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P_7P_8P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_12P        = IS_IPHONE && SCREEN_MAX_LENGTH == 844
    static let IS_IPHONE_X_OR_XS    = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_X_OR_XS_PRO    = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 852
    static let IS_IPHONE_XR_OR_XS_MAX = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 896
    static let IS_IPHONE_PRO_MAX = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 932
    static let IS_IPAD_MINI = IS_IPAD && SCREEN_MAX_LENGTH == 1024
    static let IS_IPAD_AIR = IS_IPAD && SCREEN_MAX_LENGTH == 1180
    static var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    static var hasHomeButton: Bool {
        guard let window = UIApplication.shared.windows.first else { return false }
        return window.safeAreaInsets.bottom <= 0
    }
}
