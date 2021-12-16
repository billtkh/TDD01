//
//  ListingDetail.h
//  TDD01
//
//  Created by Bill Tsang on 16/12/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListingDetail : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *content;
@property (nonatomic, strong, readonly) NSString *iconName;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content iconName:(NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
