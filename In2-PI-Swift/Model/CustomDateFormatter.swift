//
//  CustomDateFormatter.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/16/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

class CustomDateFormatter {
    
    static let sharedInstance = CustomDateFormatter()
    let dateFormatter = NSDateFormatter()
    
//    init() {
//        
//    }
    
    func convertFBCreatedTimeDateToOurFormattedString(feedObject: FBFeedObject) -> String? {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let date = dateFormatter.dateFromString(feedObject.created_time)
        if let date = date {
            dateFormatter.dateFormat = "yyyy-MM-dd EEE hh:mm a"
            return dateFormatter.stringFromDate(date)
        }
        return nil
    }
    
}