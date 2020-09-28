//
//  YLBPhotoTools.h
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/27.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLBPhotoTools : NSObject
+ (void)requestAuthorization:(UIViewController *)viewController
                     handler:(void (^)(PHAuthorizationStatus status))handler;
@end

NS_ASSUME_NONNULL_END
