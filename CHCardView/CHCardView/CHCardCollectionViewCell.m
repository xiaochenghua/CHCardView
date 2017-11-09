//
//  CHCardCollectionViewCell.m
//  CHCardView
//
//  Created by arnoldxiao on 09/11/2017.
//  Copyright © 2017 arnoldxiao. All rights reserved.
//

#import "CHCardCollectionViewCell.h"

@interface CHCardCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CHCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self addSubview:self.imageView];
}

- (void)refreshCardViewCellWithImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.cornerRadius = 10;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
