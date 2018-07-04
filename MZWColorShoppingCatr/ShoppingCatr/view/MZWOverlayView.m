//
//  MZWOverlayView.m
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//

#import "MZWOverlayView.h"
#import "ColorShoppingCatrView.h"
@implementation MZWOverlayView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        //        [self setAlpha:0.8];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    
    if (view == self) {
        
        [self.ColorShoppingCatrView dismissAnimated:YES];
    }
}


@end
