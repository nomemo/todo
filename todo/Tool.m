//
//  Tool.m
//  todo
//
//  Created by JUE DUKE on 2017/4/11.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (NSString *)uuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}



@end
