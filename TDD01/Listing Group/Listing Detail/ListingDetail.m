//
//  ListingDetail.m
//  TDD01
//
//  Created by Bill Tsang on 16/12/2021.
//

#import "ListingDetail.h"

@implementation ListingDetail

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content iconName:(NSString *)iconName {
    self = [super init];
    if (self) {
        _title = title;
        _content = content;
        _iconName = iconName;
    }
    return self;
}

@end
