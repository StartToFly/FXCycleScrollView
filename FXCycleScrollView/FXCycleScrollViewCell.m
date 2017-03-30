//
//  FXCycleScrollViewCell.m
//  FXCycleScrollView
//
//  Created by 冯笑 on 17/3/20.
//  Copyright © 2017年 冯笑. All rights reserved.
//

#import "FXCycleScrollViewCell.h"


@implementation FXCycleScrollViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.adImageView];
    }
    return self;
}

-(UIImageView *)adImageView
{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    }
    return _adImageView;
}

@end
