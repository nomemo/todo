//
//  TagItem.h
//  todo
//
//  Created by JUE DUKE on 2017/4/16.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagItem : NSObject<NSCoding>

@property (nonatomic, strong, readonly) NSString *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger times;

- (instancetype)initWithName:(NSString *)name;

@end
