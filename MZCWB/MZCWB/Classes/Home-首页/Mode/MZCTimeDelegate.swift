//
//  MZCTimeDelegate.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/30.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import Foundation

protocol MZCTimeDelegate {
    
    func handleRequest(time : NSDate) -> String
}

class MZCBaseTimer : MZCTimeDelegate {
    
    var formatterStr = "HH:mm"
    
    let calendar = NSCalendar.currentCalendar()
    
    private func timeString(dateFormat : String , date : NSDate) -> String {
        // 昨天
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        formatterStr = dateFormat + formatterStr
        formatter.dateFormat = formatterStr
        return formatter.stringFromDate(date)
    }
    
    var nextSuccessor: MZCTimeDelegate?
    
    func handleRequest(time : NSDate) -> String{
        guard let t_nextSuccessor = nextSuccessor else {
            return "责任对象错误"
        }
        return t_nextSuccessor.handleRequest(time)
    }
}

//MARK:- 头
class MZCTimeHead: MZCBaseTimer{
    
}


//MARK:- 当天 X小时前(当天)
class MZCToday: MZCBaseTimer{
    
    override func handleRequest(time : NSDate) -> String{
        
        let interval = Int(NSDate().timeIntervalSinceDate(time))
        
        if !calendar.isDateInToday(time) {
            return (self.nextSuccessor?.handleRequest(time))!
        }
        
        if interval < 60
        {
            return "刚刚"
        }else if interval < 60 * 60
        {
            return "\(interval / 60)分钟前"
        }else
        {
            return "\(interval / (60 * 60))小时前"
        }
    }
}

//MARK:- 昨天 HH:mm(昨天)
class MZCYesterday: MZCBaseTimer{
    

    override func handleRequest(time : NSDate) -> String{
        
        if !calendar.isDateInYesterday(time)
        {
            return (self.nextSuccessor?.handleRequest(time))!
        }
        
        // 昨天
        return self.timeString("昨天: ", date: time)
        
    }
}
//MARK:- MM-dd HH:mm(一年内)
class MZCYear: MZCBaseTimer{
    
    override func handleRequest(time : NSDate) -> String{
        
        let comps  = calendar.components(NSCalendarUnit.Year, fromDate: time, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        
        if comps.year >= 1
        {
            return (self.nextSuccessor?.handleRequest(time))!
        }
    
        return self.timeString("MM-dd ", date: time)
        
    }
}
//MARK:- yyyy-MM-dd HH:mm(更早期)
class MZCYearAgo: MZCBaseTimer{
    
    
    override func handleRequest(time : NSDate) -> String{
        
        let comps  = calendar.components(NSCalendarUnit.Year, fromDate: time, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        
        if comps.year >= 1
        {
            return self.timeString("yyyy-MM-dd ", date: time)
        }
        
        return (self.nextSuccessor?.handleRequest(time))!
        
    }
    

}

//MARK:- 尾
class MZCTimeEnd: MZCBaseTimer{
    
    override func handleRequest(time : NSDate) ->String {
        return "无法获取到正确的时间"
    }
}