//
//  TagItem.m
//  todo
//
//  Created by JUE DUKE on 2017/4/16.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "TagItem.h"
#import "Tool.h"

@interface TagItem ()

@property (nonatomic, strong) NSString *uuid;

@end

@implementation TagItem

- (instancetype)initWithName:(NSString *)name {
    self = [self init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _uuid = [Tool uuidString];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_uuid forKey:@"uuid"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeInteger:_times forKey:@"times"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _uuid = [aDecoder decodeObjectForKey:@"uuid"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _times = [aDecoder decodeIntegerForKey:@"times"];
    }
    return self;
}

- (NSString *)description {
    return self.name;
}

#pragma mark - For sort 

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[TagItem class]]) {
        return false;
    }
    TagItem *compareItem = object;
    if (![self.uuid isEqualToString:compareItem.uuid]) {
        return false;
    }
    return true;
}

- (NSComparisonResult)compare:(id)other {
    TagItem *compareItem = other;
    if (compareItem.times < self.times ) {
        return NSOrderedDescending;
    }
    if (compareItem.times > self.times) {
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}


@end
