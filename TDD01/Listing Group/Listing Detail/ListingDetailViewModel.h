//
//  ListingDetailViewModel.h
//  TDD01
//
//  Created by Bill Tsang on 16/12/2021.
//

#import <Foundation/Foundation.h>
#import "ListingDetailService.h"

NS_ASSUME_NONNULL_BEGIN

@class RACCommand;

@interface ListingDetailViewModel : NSObject

@property (nonatomic, strong) NSString *pageTitle;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *content;

- (instancetype)initWithListingDetailService:(id<ListingDetailService>)listingDetailService ListingTitle:(NSString *)title;
- (void)fetchData;

@end

NS_ASSUME_NONNULL_END
