//
//  YLBPhotoViewCell.m
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/28.
//

#import "YLBPhotoViewCell.h"

@interface YLBPhotoViewCell ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation YLBPhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
//        _imageView.backgroundColor = [HXPhotoCommon photoCommon].isDark ? [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1] : [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    }
    return _imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)setModel:(YLBPhotoModel *)model {
    _model = model;
    __weak __typeof(self)weakSelf = self;
    [self.model highQualityRequestThumbImageWithSize:CGSizeMake(15, 15) completion:^(UIImage * _Nullable image, YLBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        if (weakSelf.model == model) {
//            weakSelf.maskView.hidden = NO;
            weakSelf.imageView.image = image;
//            weakSelf.requestID =
            [weakSelf.model requestThumbImageCompletion:^(UIImage *image, YLBPhotoModel *model, NSDictionary *info) {
                if (weakSelf.model == model) {
                    weakSelf.imageView.image = image;
                }
            }];
        }
    }];
}

@end
