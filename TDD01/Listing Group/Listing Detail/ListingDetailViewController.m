//
//  ListingDetailViewController.m
//  TDD01
//
//  Created by Bill Tsang on 16/12/2021.
//

#import "ListingDetailViewController.h"

@interface ListingDetailViewController ()

@property (nonatomic, strong) UIStackView *vStack;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ListingDetailViewController

- (instancetype)initWithViewModel:(ListingDetailViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self binding];
    
    [self.viewModel fetchData];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.secondarySystemBackgroundColor;
    [self.view addSubview:self.vStack];
    [self.vStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8);
        make.leading.equalTo(self.view.mas_leading).offset(8);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-8);
        make.trailing.equalTo(self.view.mas_trailing).offset(-8);
    }];
    [self.vStack addArrangedSubview:self.imageView];
    [self.vStack addArrangedSubview:self.contentLabel];
}

- (void)binding {
    RAC(self, title) = RACObserve(self.viewModel, pageTitle);
    RAC(self, imageView.image) = [RACObserve(self.viewModel, iconName) map:^id _Nullable(NSString * _Nullable value) {
        return [UIImage imageNamed:value];
    }];
    RAC(self, contentLabel.text) = RACObserve(self.viewModel, content);
}

#pragma mark - lazy properties

- (UIStackView *)vStack {
    if (_vStack == nil) {
        _vStack = [[UIStackView alloc] initWithFrame:CGRectZero];
        _vStack.axis = UILayoutConstraintAxisVertical;
        _vStack.spacing = 16.0;
    }
    return _vStack;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_imageView.mas_width);
        }];
    }
    return _imageView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
