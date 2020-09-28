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
/**  照片类型  */
@property (assign, nonatomic) YLBPhotoModelMediaType type;
/**  照片PHAsset对象  */
@property (strong, nonatomic) PHAsset * _Nullable asset;
- (PHImageRequestID)highQualityRequestThumbImageWithSize:(CGSize)size completion:(YLBModelImageSuccessBlock)completion;

@end

NS_ASSUME_NONNULL_END
