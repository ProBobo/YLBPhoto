//
//  YLBPhotoTools.m
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/27.
//

#import "YLBPhotoTools.h"

CG_INLINE UIAlertController * ylb_showAlert(UIViewController *vc,
                                          NSString *title,
                                          NSString *message,
                                          NSString *buttonTitle1,
                                          NSString *buttonTitle2,
                                          dispatch_block_t buttonTitle1Handler,
                                          dispatch_block_t buttonTitle2Handler) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *pop = [alertController popoverPresentationController];
        pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
        pop.sourceView = vc.view;
        pop.sourceRect = vc.view.bounds;
    }
    
    if (buttonTitle1) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:buttonTitle1
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 if (buttonTitle1Handler) buttonTitle1Handler();
                                                             }];
        [alertController addAction:cancelAction];
    }
    if (buttonTitle2) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:buttonTitle2
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (buttonTitle2Handler) buttonTitle2Handler();
                                                         }];
        [alertController addAction:okAction];
    }
    [vc presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

@implementation YLBPhotoTools
#pragma mark - 1、判断权限
+ (void)requestAuthorization:(UIViewController *)viewController
                        handler:(void (^)(PHAuthorizationStatus status))handler {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        if (handler) handler(status);
    }else if (status == PHAuthorizationStatusDenied ||
              status == PHAuthorizationStatusRestricted) {
                  if (handler) handler(status);
        [self showNoAuthorizedAlertWithViewController:viewController];
    }else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(status);
                if (status != PHAuthorizationStatusAuthorized) {
                    [self showNoAuthorizedAlertWithViewController:viewController];
                }else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoRequestAuthorizationCompletion" object:nil];
                }
            });
        }];
    }
}
+ (void)showNoAuthorizedAlertWithViewController:(UIViewController *)viewController {
    ylb_showAlert(viewController, @"无法访问相册", @"请在设置-隐私-相册中允许访问相册", @"取消", @"设置", nil, ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    });
}
@end
