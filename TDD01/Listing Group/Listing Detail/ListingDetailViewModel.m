//
//  ListingDetailViewModel.m
//  TDD01
//
//  Created by Bill Tsang on 16/12/2021.
//

#import "ListingDetailViewModel.h"
#import "ListingDetail.h"

@interface ListingDetailViewModel ()

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) RACCommand *fetchListingDetail;

@property (nonatomic) id<ListingDetailService> listingDetailService;
@property (nonatomic, strong) ListingDetail *listingDetail;

@end

@implementation ListingDetailViewModel

NSString * const LoadingText = @"Loading...";

- (instancetype)initWithListingDetailService:(id<ListingDetailService>)listingDetailService ListingTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _listingDetailService = listingDetailService;
        _title = title;
        
        @weakify(self)
        _fetchListingDetail = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *title) {
            @strongify(self)
            self.pageTitle = LoadingText;
            return [[listingDetailService fetchListingDetailWithTitle:title] doNext:^(ListingDetail * _Nullable listingDetail) {
                self.pageTitle = listingDetail.title;
                self.content = listingDetail.content;
                self.iconName = listingDetail.iconName;
            }];
        }];
    }
    return self;
}

- (void)fetchData {
    [self.fetchListingDetail execute:self.title];
}

@end
