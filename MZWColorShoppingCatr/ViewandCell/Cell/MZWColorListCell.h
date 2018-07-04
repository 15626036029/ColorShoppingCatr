//
//  MZWColorListCell.h
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface MZWColorListCell : UITableViewCell

//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
//商品名
@property (weak, nonatomic) IBOutlet UILabel *name;

//颜色值
@property (weak, nonatomic) IBOutlet UILabel *month_saled;
//减
@property (weak, nonatomic) IBOutlet UIButton *minus;
//加
@property (weak, nonatomic) IBOutlet UIButton *plus;
//数量
@property (weak, nonatomic) IBOutlet UILabel *orderCountTF;






@property (assign, nonatomic) NSInteger foodId;

@property (assign, nonatomic) NSUInteger amount;

//减少订单数量 不需要动画效果
/*
 *  count是添加了数量
 *  rowcount是识别改动哪一行的count
 *  animated是用于识别购物车数量加了还是见了   YES=+  NO=-
 *  countall
 */
@property (copy, nonatomic) void (^plusBlock)(NSInteger count,NSInteger rowcount,BOOL animated,BOOL countall);

@property (weak, nonatomic) IBOutlet UIImageView *plusImageView;
@property(nonatomic,strong) ViewController *vc;
-(void)JIAJIA:(NSInteger)count andButtontag:(NSInteger)tag;
@end
