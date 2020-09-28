//
//  YLBPhotoModel.m
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/28.
//

#import "YLBPhotoModel.h"

@implementation YLBPhotoModel

- (PHImageRequestOptions *)imageRequestOptionsWithDeliveryMode:(PHImageRequestOptionsDeliveryMode)deliveryMode {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = deliveryMode;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    return option;
}
- (PHImageRequestOptions *)imageHighQualityRequestOptions {
    return [self imageRequestOptionsWithDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
}
- (PHImageRequestID)requestImageWithOptions:(PHImageRequestOptions *)options targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler {
    
    return [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (resultHandler) {
            resultHandler(result, info);
        }
    }];
}
- (PHImageRequestID)highQualityRequestThumbImageWithSize:(CGSize)size completion:(YLBModelImageSuccessBlock)completion {
    PHImageRequestOptions *option = [self imageHighQualityRequestOptions];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    __weak __typeof(self)weakSelf = self;
    return [self requestImageWithOptions:option targetSize:size resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(result, weakSelf, info);
            });
        }
    }];
}

@end