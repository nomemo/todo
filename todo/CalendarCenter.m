

//
//  CalendarCenter.m
//  todo
//
//  Created by JUE DUKE on 2017/5/1.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "CalendarCenter.h"
#import <EventKit/EventKit.h>

@implementation CalendarCenter


+(void)addEventNotify:(NSDate *)startTime endTime:(NSDate *)endTime title:(NSString *)title {
    
//    http://stackoverflow.com/questions/246249/programmatically-add-custom-event-in-the-iphone-calendar
    
    
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:eventDB];
    calendar.title = @"For Nomemo";
    
    [eventDB requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) { //授权是否成功
            
            EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB]; //创建一个日历事件
            
            myEvent.title     = title;
            
            myEvent.startDate = startTime;
            
            myEvent.endDate   = endTime?endTime:startTime ;  //结束date    required
            
            EKAlarm *alram = [EKAlarm alarmWithAbsoluteDate:startTime];
            [myEvent addAlarm:alram]; //添加一个闹钟  optional
            
            [myEvent setCalendar:calendar]; //添加calendar  required
            NSError *err;
            [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err]; //保存
            NSLog(@"error %@", error);
            
        }
    }];

}
@end
