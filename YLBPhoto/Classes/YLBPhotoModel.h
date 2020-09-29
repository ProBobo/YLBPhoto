//
//  YLBPhotoModel.h
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/28.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YLBPhotoModelMediaType) {
    YLBPhotoModelMediaTypePhoto          = 0,    //!< 照片
    YLBPhotoModelMediaTypeLivePhoto      = 1,    //!< LivePhoto
    YLBPhotoModelMediaTypePhotoGif       = 2,    //!< gif图
    YLBPhotoModelMediaTypeVideo          = 3,    //!< 视频
    YLBPhotoModelMediaTypeAudio          = 4,    //!< 预留
    YLBPhotoModelMediaTypeCameraPhoto    = 5,    //!< 通过相机拍的临时照片、本地/网络图片
    YLBPhotoModelMediaTypeCameraVideo    = 6,    //!< 通过相机录制的视频、本地视频
    YLBPhotoModelMediaTypeCamera         = 7     //!< 跳转相机
};

@interface YLBPhotoModel : NSObject
typedef void (^ YLBModelImageSuccessBlock)(UIImage * _Nullable image, YLBPhotoModel * _Nullable model, NSDictionary * _Nullable info);
/**  照片列表请求的资源的大小 */
@property (assign, nonatomic) CGSize requestSize;
/**  照片类型  */
@property (assign, nonatomic) YLBPhotoModelMediaType type;
/**  照片PHAsset对象  */
@property (strong, nonatomic) PHAsset * _Nullable asset;
- (PHImageRequestID)highQualityRequestThumbImageWithSize:(CGSize)size completion:(YLBModelImageSuccessBlock)completion;
/**
请求获取缩略图，主要用在列表上展示。此方法会回调多次，如果为视频的话就是视频封面

@param completion 完成后的回调
@return 请求的id，本地/网络图片返回 0
        可用于取消请求 [[PHImageManager defaultManager] cancelImageRequest:(PHImageRequestID)];
*/
- (PHImageRequestID)requestThumbImageCompletion:(YLBModelImageSuccessBlock)completion;

@end

NS_ASSUME_NONNULL_END
