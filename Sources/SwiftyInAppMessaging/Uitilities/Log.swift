//
//  File.swift
//
//
//  Created by 伊藤史 on 2021/01/07.
//
#if os(iOS) || os(tvOS)
    import Foundation

    func debugLog(
        _ obj: Any?,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {

        let fileName = URL(string: file)?.lastPathComponent ?? "unknown"

        #if DEBUG
            if let obj = obj {
                print("[\(fileName):\(function) Line:\(line)] : \(obj)")
            } else {
                print("[\(fileName):\(function) Line:\(line)]")
            }
        #endif
    }
#endif
