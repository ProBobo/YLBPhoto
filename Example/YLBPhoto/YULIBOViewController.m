//
//  YULIBOViewController.m
//  YLBPhoto
//
//  Created by ProBobo on 09/25/2020.
//  Copyright (c) 2020 ProBobo. All rights reserved.
//

#import "YULIBOViewController.h"
#import <YLBPhoto/YLBPhotoController.h>
#import <YLBCommon/YLBCommon.h>
@interface YULIBOViewController ()

@end

@implementation YULIBOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews {
    UIButton *selectedButton = [[UIButton alloc] init];
    selectedButton.frame = CGRectMake(0, 0, 100, 50);
    [selectedButton setTitle:@"图片&视频" forState:UIControlStateNormal];
    selectedButton.backgroundColor = UIColor.grayColor;
    selectedButton.center = CGPointMake(self.view.ylb_width/2.0, self.view.ylb_height/2.0);
    [self.view addSubview:selectedButton];
    
    [selectedButton addTarget:self action:@selector(selectedButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click
- (void)selectedButtonMethod:(id)sender {
    YLBPhotoController *vc = [[YLBPhotoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 

// 状态栏字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

@end
