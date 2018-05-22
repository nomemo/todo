//
//  NotifyCenter.h
//  todo
//
//  Created by JUE DUKE on 2017/4/23.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyCenter : NSObject

+ (NotifyCenter *)notifyCenter;

- (void)test:(NSInteger)delay;

- (void)resetTheBadge;
- (void)createTomorrowNotify;
- (void)createNightNofity;

@end
