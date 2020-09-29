//
//  YLBPhotoPreviewViewCell.h
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/29.
//

#import <UIKit/UIKit.h>
#import "YLBPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLBPhotoPreviewViewCell : UICollectionViewCell
@property (strong, nonatomic) YLBPhotoModel *model;
@property (strong, nonatomic) UIImageView *imageView;
#pragma mark - 播放
- (void)requestHDImage:(YLBPhotoModel *)model;
@end

NS_ASSUME_NONNULL_END
