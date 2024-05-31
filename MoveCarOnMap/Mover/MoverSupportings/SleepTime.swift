//
//  SleepTime.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 31/05/24.
//

import Foundation

struct SleepTime {
    static let oneSecond = useconds_t(1000000)
    
    static var sleepTime: UInt32 {
        get {
            return oneSecond * 60 // 60 Seconds
        }
    }
    
}
