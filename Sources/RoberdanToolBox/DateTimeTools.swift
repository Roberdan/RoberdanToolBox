//  DateTimeTools.swift
//
//  Created by Roberto D’Angelo on 21/04/2020.
//  Copyright © 2020 FightTheStroke Foundation. All rights reserved.
//

import Foundation
import SwiftUI

// that's the main clock across the app as singleton.
// it simply publish a value of type Date called "now"

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
public class MainClock: ObservableObject {
    static public var shared = MainClock()
    
    @Published public var now : Date = Date()
    
    public init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            DispatchQueue.main.async {
                self.now = Date()
            }
        }
    }
}


// MARK: date and time formatters or modifiers
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
public let dateFormatter = DateFormatter()
public let timeStampFormatterHHmmss: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
}()

//extension for easily handle timeinterval outcomes in string and different formats
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
extension TimeInterval{
    public func timeClockFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    public func toTimeStampFormatter() -> String {
        return timeStampFormatterHHmmss.string(from:  Date(timeIntervalSince1970: self))
    }
    
    public func timeStampHHmmFormatter() -> String {
        return timeStampFormatterHHmmss.string(from: Date(timeIntervalSince1970: self))
    }
    
    public func ToHHmmssString() -> String {
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours   = (time / 3600)
        
        
        let returnedHs = (hours == 0 ? "00:" : (hours < 10 ? "0\(hours):" : "\(hours):"))
        let returnedStringMin = (minutes == 0 ? "00:" : (minutes < 10 ? "0\(minutes):" : "\(minutes):"))
        let returnedSeconds = (seconds == 0 ? "00" : (seconds < 10 ? "0\(seconds)" : "\(seconds)"))
        return (returnedHs + returnedStringMin + returnedSeconds)
    }
    
    public func ToSmartHHMMssString() -> String {
        var returnedStringMin : String
        var returnedStringHH : String
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours   = (time / 3600)
        if (hours > 0) {
            returnedStringHH = ((hours < 10) ? "0\(hours):" : "\(hours):")
        } else {
            returnedStringHH = ""
        }
        if (minutes > 0) {
            returnedStringMin = (minutes < 10 ? "0\(minutes):" : "\(minutes):")
        } else {
            returnedStringMin = ""
        }
        
        let returnedSeconds = ((seconds < 10 && minutes > 0) ? "0\(seconds)" : "\(seconds)")
        return (returnedStringHH + returnedStringMin + returnedSeconds)
    }
    
    
    
    public func ToFullHHMMssString() -> String {
        var returnedStringMin : String
        var returnedStringHH : String
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours   = (time / 3600)
        if (minutes > 0) {
            returnedStringMin = (minutes < 10 ? "0\(minutes):" : "\(minutes):")
        } else {
            returnedStringMin = "00:"
        }
        
        if (hours > 0) {
            returnedStringHH = ((hours < 10) ? "0\(hours):" : "\(hours):")
        } else {
            returnedStringHH = "00:"
        }
        let returnedSeconds = ((seconds < 10) ? "0\(seconds)" : "\(seconds)")
        return (returnedStringHH + returnedStringMin + returnedSeconds)
    }
    
    public func ToMMssStringWatch() -> String {
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let returnedStringMin = (minutes < 10 ? "0\(minutes):" : "\(minutes):")
        let returnedSeconds = (seconds < 10 ? "0\(seconds)" : "\(seconds)")
        return ((minutes > 0 ? returnedStringMin :  "") + returnedSeconds)
    }
    
    
    public func ToFullText() -> String {
        let time = Int(self)
        let milliSeconds = String(Int((self.truncatingRemainder(dividingBy: 1)) * 1000))
        let seconds = String(time % 60)
        let minutes = String((time / 60) % 60)
        let hours   = String(time / 3600)
        return (hours + ":" + minutes + ":" + seconds + ":" + milliSeconds)
    }
    
    public func ToHHmmss() -> String {
        let time = Int(self)
        let seconds = String(time % 60)
        let minutes = String((time / 60) % 60)
        let hours   = String(time / 3600)
        return (hours + ":" + minutes + ":" + seconds )
    }
    
    public func ToHHmm() -> String {
        let time = Int(self)
        let minutes = String((time / 60) % 60)
        let hours   = String(time / 3600)
        return (hours + " hs : " + minutes + " min")
    }
    
    public func toHistoryViewFormat() -> String {
        let dateTmp = Date(timeIntervalSince1970: self)
        return dateTmp.returnDDmmYY()
    }
}

// it enables to easily have date in string formats
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
extension Date {
    //    Date.yesterday    // "Oct 28, 2018 at 12:00 PM"
    //    Date()            // "Oct 29, 2018 at 11:01 AM"
    //    Date.tomorrow     // "Oct 30, 2018 at 12:00 PM"
    //
    //    Date.tomorrow.month   // 10
    //    Date().isLastDayOfMonth  // false
    
    static public var yesterday: Date { return Date().dayBefore }
    static public var tomorrow:  Date { return Date().dayAfter }
    static public var todayDiary: Date { return Date().today }
    static public let stdDateFormat = "dd-MM-yyyy HH:mm:ss"
    static public let nightInterval = [21,8]
    
    public var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    public var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    public var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    public var today: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    public var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    public func toStdString() -> String {
        dateFormatter.dateFormat = Date.stdDateFormat
        return dateFormatter.string(from: self)
    }
    
    public var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    public var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    public func returnHHmm () -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    static public func fromStdDateString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.stdDateFormat
        return dateFormatter.date(from: dateString)
    }
    
    public func returnDDmmYY () -> String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let day = components.day!
        let month = components.month!
        let year = components.year!
        let monthName = DateFormatter().monthSymbols[month - 1]
        return "\(day), \(monthName) \(year)"
    }
    
    
    public func returnCloudPathForML () -> String{
        dateFormatter.dateFormat = "/yyyy/MM/dd/"
        
        //        dateFormatter.dateFormat = "dd_MM_yyyy_HH_mm_ss"
        return dateFormatter.string(from: self)
    }
    
    public func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    public func addDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self)!
    }
    public func addSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self)!
    }
    public func monthsAgo(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: -n, to: self)!
    }
    public func daysAgo(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: -n, to: self)!
    }
    
    public func secsAgo(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: -n, to: self)!
    }
    
    public func lastDays(_ n: Int) -> Date {
        let x = TimeInterval(n*24*60*60)
        let newTime = self.timeIntervalSince1970 - x
        return Date(timeIntervalSince1970: newTime)
    }
    
    public func deltaHours(_ n: Int) -> Date {
        let x = TimeInterval(n*60*60)
        let newTime = self.timeIntervalSince1970 + x
        return Date(timeIntervalSince1970: newTime)
    }
    
    public func hours2Int() -> Int {
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    public func minutes() -> String {
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
    
    public func seconds() -> String {
        dateFormatter.dateFormat = "ss"
        return dateFormatter.string(from: self)
    }
    
    #if os(iOS)
    public func isNight() -> Bool {
        var isNight = false
        if (self.hours2Int() < Date.nightInterval[1] || self.hours2Int() > Date.nightInterval[0] ) {
            isNight = true
        }
        return isNight
    }
    
    public func isDay() -> Bool {
        var isDay = false
        if (self.hours2Int() >= Date.nightInterval[1] || self.hours2Int() <= Date.nightInterval[0] ) {
            isDay = true
        }
        return isDay
    }
    #endif
}



