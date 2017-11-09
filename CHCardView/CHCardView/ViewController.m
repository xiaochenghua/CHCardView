//
//  ViewController.m
//  CHCardView
//
//  Created by arnoldxiao on 09/11/2017.
//  Copyright © 2017 arnoldxiao. All rights reserved.
//

#import "ViewController.h"
#import "CHCardView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"card%02d.jpg", i + 1]];
        [images addObject:image];
    }
    
    CHCardView *cardView = [[CHCardView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 150)
                                                 dataSources:^NSArray<UIImage *> * _Nonnull{
        return images;
    }];
    
    [self.view addSubview:cardView];
}


@end
