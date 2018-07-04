//
//  ViewController.h
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property(nonatomic,assign)NSInteger AddShibie;//用于识别是半价板毛还是购物车或立即购买 1是购物车 2是立即购买 3是半价板毛
@property(nonatomic,strong)NSString *shangpinid;
@property(nonatomic,strong)NSString *shangpinUrl;
@property(nonatomic,strong)NSString *shangpingid;
@property(nonatomic,strong)NSString *daohanglanNamestring;
@property(nonatomic,strong)NSString *miaoshashibie;
@property(nonatomic,strong)NSString *shibie;
@property(nonatomic,assign)NSInteger tiaozhuanshibiezhi;

@end

