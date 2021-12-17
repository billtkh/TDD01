//
//  ListingDetailService.m
//  TDD01
//
//  Created by Bill Tsang on 16/12/2021.
//

#import "ListingDetailServiceStub.h"
#import "ListingDetail.h"

@implementation ListingDetailServiceStub

- (RACSignal *)fetchListingDetailWithTitle:(NSString *)title {
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        ListingDetail *detail = [[ListingDetail alloc] initWithTitle:[NSString stringWithFormat:@"%@%@", @"This is the title of ", title]
                                                             content:[NSString stringWithFormat:@"%@%@", @"This is the content of ", title]
                                                            iconName:[NSString stringWithFormat:@"contact_detail_ic_email"]];
        [subscriber sendNext:detail];
        [subscriber sendCompleted];
        return nil;
    }] delay:1];
}

@end
