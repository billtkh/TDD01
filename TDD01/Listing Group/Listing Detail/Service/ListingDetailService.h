//
//  ListingDetailService.h
//  TDD01
//
//  Created by Bill Tsang on 16/12/2021.
//

#ifndef ListingDetailService_h
#define ListingDetailService_h

@class RACSignal;

@protocol ListingDetailService

- (RACSignal *)fetchListingDetailWithTitle:(NSString *)title;

@end

#endif /* ListingDetailService_h */
