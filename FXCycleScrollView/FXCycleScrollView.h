//
//  FXCycleScrollView.h
//  FXCycleScrollView
//
//  Created by 冯笑 on 17/3/20.
//  Copyright © 2017年 冯笑. All rights reserved.
//

#import "FXBaseView.h"


@class FXCycleScrollView;

@protocol FXCycleScrollViewDelegate <NSObject>

@optional

/**
 *  点击图片回调
 */
-(void)fxCycleScrollView:(FXCycleScrollView *)cycleScrollView didSelectItemAtIndexPath:(NSInteger )index;

@end



@interface FXCycleScrollView : FXBaseView


/**
 *  加载网络图片时的背景图
 */
@property (nonatomic,strong) UIImage *placehoderImage;

/**
 *  图片数组，无论传入URL或者本地图片都可以，本地图片传入完整图片名
 */
@property (nonatomic,strong) NSMutableArray *imagePathGroup;

/**
 *  自动滚动时间间隔，默认时间为2秒钟(设置优先级先于autoCycle)
 */
@property (nonatomic,assign) CGFloat autoScrollTimeInterval;



/**
 *  是否无限循环,默认为YES(设置优先级尽量先于imagePathGroup)
 */
@property (nonatomic,assign) BOOL cycle;
/**
 *  是否自动循环,默认为YES(设置优先级尽量先于imagePathGroup)
 */
@property (nonatomic,assign) BOOL autoCycle;


/**
 *  初始化方法
 *
 *  @param frame          frame
 *  @param imagePathGroup 图片名称/地址数组
 *
 */
+(instancetype)fxCycleScrollViewWithFrame:(CGRect)frame imagePathGroup:(NSMutableArray *)imagePathGroup;

@property (nonatomic,weak) id<FXCycleScrollViewDelegate>delegate;

@end
