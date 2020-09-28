//
//  YLBAlbumModel.h
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/27.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/**
*  每个相册的模型
*/
@interface YLBAlbumModel : NSObject

/**  相册名称  */
@property (copy, nonatomic) NSString *albumName;
/**  照片数量  */
@property (assign, nonatomic) NSInteger count;
/**  封面Asset  */
@property (strong, nonatomic) PHAsset *asset;
/**  单选时的第二个资源  */
@property (strong, nonatomic) PHAsset *asset2;
/**  单选时的第三个资源  */
@property (strong, nonatomic) PHAsset *asset3;
/**  照片集合对象  */
@property (strong, nonatomic) PHFetchResult *result;
@property (strong, nonatomic) PHAssetCollection *collection;
@property (strong, nonatomic) PHFetchOptions *option;
/**  标记  */
@property (assign, nonatomic) NSInteger index;
/**  选中的个数  */
@property (assign, nonatomic) NSInteger selectedCount;
@property (assign, nonatomic) NSUInteger cameraCount;
@property (strong, nonatomic) UIImage *tempImage;


- (void)getResultWithCompletion:(void (^)(YLBAlbumModel *albumModel))completion;

@end

NS_ASSUME_NONNULL_END
