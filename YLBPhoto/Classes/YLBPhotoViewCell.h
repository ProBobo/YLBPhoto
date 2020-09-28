//
//  YLBPhotoViewCell.h
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/28.
//

#import <UIKit/UIKit.h>
#import "YLBPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLBPhotoViewCell : UICollectionViewCell
@property (strong, nonatomic) YLBPhotoModel *model;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
