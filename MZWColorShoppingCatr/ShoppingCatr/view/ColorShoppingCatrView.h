//
//  ColorShoppingCatrView.h
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZWReordeTable.h"
@class MZWBadgeView;
@interface ColorShoppingCatrView : UIView
@property (nonatomic,strong) MZWBadgeView *badge;
@property (nonatomic,strong) UIButton *shoppingCartBtn;

@property (nonatomic,strong) UIView *parentView;

@property (nonatomic,strong) MZWReordeTable *OrderList;


-(instancetype) initWithFrame:(CGRect)frame inView:(UIView *)parentView withObjects:(NSMutableArray *)objects;

-(void)updateFrame:(UIView *)view;

-(void)setTotalMoney:(NSInteger)nTotal andmutablearr:(NSMutableArray*)mutablearr;

-(void)setCartImage:(NSString *)imageName;

-(void)dismissAnimated:(BOOL) animated;
@end
