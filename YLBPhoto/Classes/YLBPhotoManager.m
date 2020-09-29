//
//  YLBPhotoManager.m
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/27.
//

#import "YLBPhotoManager.h"

@interface YLBPhotoManager ()

@end

@implementation YLBPhotoManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.loadAssetQueue = dispatch_queue_create("ylbLoadAssetQueue", NULL);
}

- (void)preloadData {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized) {
        return;
    }
    
    dispatch_async(self.loadAssetQueue, ^{
        __weak __typeof(self)weakSelf = self;
        [self getCameraRollAlbumCompletion:^(YLBAlbumModel *albumModel) {
            if (!albumModel.result && albumModel.collection) {
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:albumModel.collection options:albumModel.option];
                albumModel.result = result;
                albumModel.count = result.count;
                if (!weakSelf.getPhotoListing) {
                    [weakSelf getPhotoListWithAlbumModel:albumModel complete:nil];
                }
            }else {
                if (!weakSelf.getPhotoListing) {
                    [weakSelf getPhotoListWithAlbumModel:albumModel complete:nil];
                }
            }
        }];
    });
}

- (void)getCameraRollAlbumCompletion:(void (^)(YLBAlbumModel *albumModel))completion {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
//    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    
    BOOL addTempAlbum = YES;
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        if (collection.estimatedAssetCount <= 0) continue;
        if ([self isCameraRollAlbum:collection]) {
            YLBAlbumModel *model = [self albumModelWithCollection:collection option:option fetchAssets:YES];
//            model.cameraCount = self.cameraList.count;
            model.index = 0;
            self.cameraRollAlbumModel = model;
            if (self.getCameraRollAlbumModel) {
                self.getCameraRollAlbumModel(model);
            }
            if (completion) completion(model);
            self.getCameraRoolAlbuming = NO;
            addTempAlbum = NO;
            break;
        }
    }
}

- (BOOL)isCameraRollAlbum:(PHAssetCollection *)metadata {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    
    if (version >= 800 && version <= 802) {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
    } else {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
}

- (YLBAlbumModel *)albumModelWithCollection:(PHAssetCollection *)collection option:(PHFetchOptions *)option fetchAssets:(BOOL)fetchAssets {
    YLBAlbumModel *albumModel = [[YLBAlbumModel alloc] init];
//    albumModel.albumName = [self transFormAlbumNameWithCollection:collection];
    albumModel.albumName = collection.localizedTitle;
    if (fetchAssets) {
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        albumModel.result = result;
        albumModel.count = result.count;
    }else {
        albumModel.collection = collection;
        albumModel.option = option;
    }
    return albumModel;
}

- (void)getPhotoListWithAlbumModel:(YLBAlbumModel *)albumModel complete:(PhotoListBlock)complete {
    NSMutableArray *allArray = [NSMutableArray array];
    for (PHAsset *asset in albumModel.result) {
        YLBPhotoModel *photoModel = [self photoModelWithAsset:asset];//获取相册资源模型
        [allArray addObject:photoModel];//添加相册数据
    }
    if (self.photoListBlock) {
        self.photoListBlock(allArray);
    }
}

- (YLBPhotoModel *)photoModelWithAsset:(PHAsset *)asset {
    YLBPhotoModel *photoModel = [[YLBPhotoModel alloc] init];
    photoModel.asset = asset;
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        photoModel.type = YLBPhotoModelMediaTypeVideo;
    }
    return photoModel;
}

@end
