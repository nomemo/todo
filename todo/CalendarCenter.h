//
//  CalendarCenter.h
//  todo
//
//  Created by JUE DUKE on 2017/5/1.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarCenter : NSObject


+(void)addEventNotify:(NSDate *)startTime
              endTime:(NSDate *)endTime
                title:(NSString *)title;


@end
