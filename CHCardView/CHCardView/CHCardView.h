//
//  CHCardView.h
//  CHCardView
//
//  Created by arnoldxiao on 09/11/2017.
//  Copyright © 2017 arnoldxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN

@interface CHCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame dataSources:(NSArray<UIImage *> *(^)(void))dataSourceBlock;

@end

NS_ASSUME_NONNULL_END
