//
//  YLBAlbumModel.m
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/27.
//

#import "YLBAlbumModel.h"

@implementation YLBAlbumModel
- (void)getResultWithCompletion:(void (^)(YLBAlbumModel *albumModel))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.collection options:self.option];
        self.result = result;
        self.count = result.count;
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(self);
            });
        }
    });
}
@end
