//
//  YLBPhotoPreviewViewController.h
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/29.
//

#import <UIKit/UIKit.h>
#import "YLBPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLBPhotoPreviewViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger currentModelIndex;
@end

NS_ASSUME_NONNULL_END
