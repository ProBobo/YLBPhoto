//
//  YULIBONavigationBarView.h
//  YLBPhoto_Example
//
//  Created by yulibo on 2020/9/27.
//  Copyright © 2020 ProBobo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YULIBONavigationBarView : UIView
@property(nonatomic, strong) UIButton *leftButton;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *rightButton;
+ (instancetype)createView;
@end

NS_ASSUME_NONNULL_END
