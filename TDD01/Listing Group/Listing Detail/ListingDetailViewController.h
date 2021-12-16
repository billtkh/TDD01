//
//  ListingDetailViewController.h
//  TDD01
//
//  Created by Bill Tsang on 16/12/2021.
//

#import <UIKit/UIKit.h>
#import "ListingDetailViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListingDetailViewController : UIViewController

@property (nonatomic, strong, readonly) ListingDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(ListingDetailViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
