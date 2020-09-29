//
//  YLBPhotoModel.m
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/28.
//

#import "YLBPhotoModel.h"

@implementation YLBPhotoModel

#pragma mark - 图片
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

- (PHImageRequestID)requestThumbImageCompletion:(YLBModelImageSuccessBlock)completion {
    return [self requestThumbImageWithSize:self.requestSize completion:completion];
}

- (CGSize)requestSize {
    if (_requestSize.width == 0 || _requestSize.height == 0) {
        NSInteger rowCount = 2;
        CGFloat clarityScale = 2.0;
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 1 * rowCount - 1 ) / rowCount;
        CGSize size = CGSizeMake(width * clarityScale, width * clarityScale);
        
        _requestSize = size;
    }
    return _requestSize;
}

- (PHImageRequestID)requestThumbImageWithSize:(CGSize)size completion:(YLBModelImageSuccessBlock)completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
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

#pragma mark - 视频
- (PHImageRequestID)requestAVAssetStartRequestICloud:(YLBModelStartRequestICloud)startRequestICloud
                                     progressHandler:(YLBModelProgressHandler)progressHandler
                                             success:(YLBModelAVAssetSuccessBlock)success
                                              failed:(YLBModelFailedBlock)failed {
    return [self requestAVAssetStartRequestICloud:startRequestICloud deliveryMode:PHVideoRequestOptionsDeliveryModeFastFormat progressHandler:progressHandler success:success failed:failed];
}
- (PHImageRequestID)requestAVAssetStartRequestICloud:(YLBModelStartRequestICloud)startRequestICloud
                                        deliveryMode:(PHVideoRequestOptionsDeliveryMode)deliveryMode
                                     progressHandler:(YLBModelProgressHandler)progressHandler
                                             success:(YLBModelAVAssetSuccessBlock)success
                                              failed:(YLBModelFailedBlock)failed
 {
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = deliveryMode;
    options.networkAccessAllowed = NO;
    PHImageRequestID requestId = 0;
    __weak __typeof(self)weakSelf = self;
    requestId = [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        [weakSelf requestDataWithResult:asset info:info size:CGSizeZero resultClass:[AVAsset class] orientation:0 audioMix:audioMix startRequestICloud:startRequestICloud progressHandler:progressHandler success:^(id result, NSDictionary *info, UIImageOrientation orientation, AVAudioMix *audioMix) {
            if (success) {
                success(result, audioMix, weakSelf, info);
            }
        } failed:failed];
    }];
    return requestId;
}
- (void)requestDataWithResult:(id)results
                         info:(NSDictionary *)info
                         size:(CGSize)size
                  resultClass:(Class)resultClass
                  orientation:(UIImageOrientation)orientation
                     audioMix:(AVAudioMix *)audioMix
           startRequestICloud:(YLBModelStartRequestICloud)startRequestICloud
              progressHandler:(YLBModelProgressHandler)progressHandler
                      success:(void (^)(id result, NSDictionary *info, UIImageOrientation orientation, AVAudioMix *audioMix))success
                       failed:(YLBModelFailedBlock)failed {
    __weak __typeof(self)weakSelf = self;
    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
    if (downloadFinined && results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(results, info, orientation, audioMix);
            }
        });
        return;
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failed) {
                failed(info, weakSelf);
            }
        });
    }
}
@end
