//
//  FontSize.swift
//  
//
//  Created by 伊藤史 on 2022/01/25.
//
#if os(iOS) || os(tvOS)
import Foundation
import UIKit

struct FontSize {
    static var label: CGFloat {
        #if os(tvOS)
        return 38
        #else
        return UIFont.labelFontSize
        #endif
    }

    static var body: CGFloat {
        #if os(tvOS)
        return 29
        #else
        return UIFont.systemFontSize
        #endif
    }

    static var button: CGFloat {
        #if os(tvOS)
        return 53
        #else
        return UIFont.buttonFontSize
        #endif
    }
}
#endif
