
//  ViewController.m
//  FXCycleScrollView
//
//  Created by 冯笑 on 17/3/16.
//  Copyright © 2017年 冯笑. All rights reserved.
//

#import "ViewController.h"
#import "FXCycleScrollView.h"

#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width [[UIScreen mainScreen] bounds].size.width


@interface ViewController ()<FXCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        FXCycleScrollView *view = [[FXCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 180)];
    NSArray *imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg" // 本地图片请填写全名
                            ];
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];

    view.imagePathGroup = [NSMutableArray arrayWithArray:imagesURLStrings];
    view.autoCycle = YES;

    view.delegate = self;
    [self.view addSubview:view];
}

-(void)fxCycleScrollView:(FXCycleScrollView *)cycleScrollView didSelectItemAtIndexPath:(NSInteger )index
{
    NSLog(@"%ld",(long)index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
