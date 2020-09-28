//
//  YLBPhotoController.h
//  YLBPhoto_Example
//
//  Created by yulibo on 2020/9/25.
//  Copyright © 2020 ProBobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLBAlbumModel.h"
#import "YLBPhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLBPhotoController : UIViewController
@property (strong, nonatomic) YLBPhotoManager *manager;
@property (strong, nonatomic) YLBAlbumModel *albumModel;
- (void)pushPhotoListViewControllerWithAlbumModel:(YLBAlbumModel *)albumModel animated:(BOOL) animated;
@end

NS_ASSUME_NONNULL_END
