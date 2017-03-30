//
//  FXBaseView.m
//  扫码自购
//
//  Created by 冯笑 on 17/2/28.
//  Copyright © 2017年 冯笑. All rights reserved.
//

#import "FXBaseView.h"

@implementation FXBaseView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self fx_initialize];
        [self fx_addSubviews];
        [self fx_bindViewModel];
    }
    return self;
}

-(void)fx_initialize{
    
}

-(void)fx_bindViewModel{
    
}

-(void)fx_addSubviews{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
