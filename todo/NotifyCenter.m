//
//  NotifyCenter.m
//  todo
//
//  Created by JUE DUKE on 2017/4/23.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "NotifyCenter.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>


static NotifyCenter *_sharedInstance;


@interface NotifyCenter()

@property (nonatomic, assign) NSInteger badgeCount;

@end

@implementation NotifyCenter



+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (NotifyCenter *)notifyCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NotifyCenter alloc]init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupNotify];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    return self;
}



- (void) setupNotify {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

- (void)resetTheBadge {
    self.badgeCount = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSMutableArray *requests2 = [NSMutableArray array];
    
    __block NSInteger tempBadge = 0;
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            UNMutableNotificationContent *content = [request.content mutableCopy];
            content.badge = @(++tempBadge);
            UNNotificationRequest *request2 = [UNNotificationRequest requestWithIdentifier:request.identifier content:content trigger:request.trigger];
            [requests2 addObject:request2];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [center removeAllPendingNotificationRequests];
    
    self.badgeCount = tempBadge;
    for (UNNotificationRequest *request in requests2) {
        [center addNotificationRequest:request withCompletionHandler:nil];
    }
}

- (void)test:(NSInteger)delay {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND ,0), ^{
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        for (int i = 0; i < 5 ; i++) {
            
            NSDate *nextMinite = [NSDate dateWithTimeIntervalSinceNow:delay*(1+i)];
            NSLog(@"nextMinute %@", nextMinite);
            NSDateComponents *components = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:nextMinite];

            
            UNCalendarNotificationTrigger *trigger3 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:false];
            NSString *index = [NSString stringWithFormat:@"index %@", @(i+1)];
            
            UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
            content.title = [NSString localizedUserNotificationStringForKey:index arguments:nil];
            content.body = [NSString localizedUserNotificationStringForKey:@"Hello_message_body"
                                                                 arguments:nil];
            content.sound = [UNNotificationSound soundNamed:@"Submarine.aiff"];
            self.badgeCount++;
            content.badge = @(self.badgeCount);
            UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:index content:content trigger:trigger3];
            [center addNotificationRequest:request withCompletionHandler:nil];
        }
    });
}


@end
