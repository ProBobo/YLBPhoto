//
//  YLBPhotoManager.h
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/27.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "YLBAlbumModel.h"
#import "YLBPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLBPhotoManager : NSObject
typedef void (^ PhotoListBlock)(NSArray *allList);
/**
 线程
 */
@property (strong, nonatomic) dispatch_queue_t loadAssetQueue;
/**
 预加载数据
 */
- (void)preloadData;
/**
 获取所有照片的相册
 */
- (void)getCameraRollAlbumCompletion:(void (^)(YLBAlbumModel *albumModel))completion;
@property (copy, nonatomic) void (^ getCameraRollAlbumModel)(YLBAlbumModel *albumModel);
@property (assign, nonatomic) BOOL getCameraRoolAlbuming;
@property (strong, nonatomic) YLBAlbumModel *cameraRollAlbumModel;

#pragma mark - < 辅助属性 >
@property (assign, nonatomic) BOOL getPhotoListing;
@property(nonatomic, copy) PhotoListBlock photoListBlock;
#pragma mark - < 辅助方法 >
- (void)getPhotoListWithAlbumModel:(YLBAlbumModel *)albumModel complete:(PhotoListBlock)complete;

@end

NS_ASSUME_NONNULL_END
