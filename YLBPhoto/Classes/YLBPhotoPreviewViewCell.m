//
//  YLBPhotoPreviewViewCell.m
//  Pods-YLBPhoto_Example
//
//  Created by yulibo on 2020/9/29.
//

#import "YLBPhotoPreviewViewCell.h"

@interface YLBPhotoPreviewViewCell ()

@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayer *player;

@end

@implementation YLBPhotoPreviewViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView.layer addSublayer:self.playerLayer];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.playerLayer.frame = self.imageView.frame;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [[AVPlayerLayer alloc] init];
        _playerLayer.hidden = YES;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _playerLayer;
}

- (void)setModel:(YLBPhotoModel *)model {
    _model = model;
    self.playerLayer.player = nil;
    self.player = nil;
    
    if (model.type == YLBPhotoModelMediaTypeVideo) {
        __weak __typeof(self)weakSelf = self;
        
        [self.model requestAVAssetStartRequestICloud:^(PHImageRequestID iCloudRequestId, YLBPhotoModel * _Nullable model) {
            
        } progressHandler:^(double progress, YLBPhotoModel * _Nullable model) {
            
        } success:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, YLBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
            weakSelf.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:avAsset]];
            weakSelf.playerLayer.player = weakSelf.player;
        } failed:^(NSDictionary * _Nullable info, YLBPhotoModel * _Nullable model) {
            
        }];
    }
    else {
        __weak __typeof(self)weakSelf = self;
            [self.model highQualityRequestThumbImageWithSize:CGSizeMake(15, 15) completion:^(UIImage * _Nullable image, YLBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                if (weakSelf.model == model) {
        //            weakSelf.maskView.hidden = NO;
                    weakSelf.imageView.image = image;
        //            weakSelf.requestID =
                    [weakSelf.model requestThumbImageCompletion:^(UIImage *image, YLBPhotoModel *model, NSDictionary *info) {
                        if (weakSelf.model == model) {
                            weakSelf.imageView.image = image;
                        }
                    }];
                }
            }];
    }
    
}
#pragma mark - 播放
- (void)pausePlayerAndShowNaviBar {
    [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

- (void)requestHDImage:(YLBPhotoModel *)model {
    if (model.type == YLBPhotoModelMediaTypeVideo) {
        self.playerLayer.hidden = NO;
        [self pausePlayerAndShowNaviBar];
    }
    else {
        self.playerLayer.hidden = YES;
        __weak __typeof(self)weakSelf = self;
            [self.model highQualityRequestThumbImageWithSize:CGSizeMake(15, 15) completion:^(UIImage * _Nullable image, YLBPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                if (weakSelf.model == model) {
        //            weakSelf.maskView.hidden = NO;
                    weakSelf.imageView.image = image;
        //            weakSelf.requestID =
                    [weakSelf.model requestThumbImageCompletion:^(UIImage *image, YLBPhotoModel *model, NSDictionary *info) {
                        if (weakSelf.model == model) {
                            weakSelf.imageView.image = image;
                        }
                    }];
                }
            }];
    }
}

- (void)dealloc {
    self.playerLayer.player = nil;
    self.player = nil;
}

@end
