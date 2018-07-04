//
//  ColorShoppingCatrCell.h
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorShoppingCatrCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dotLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *minus;

@property (weak, nonatomic) IBOutlet UIButton *plus;

@property (nonatomic,copy) void (^operationBlock)(NSUInteger number,NSUInteger rowcount,BOOL isPlus);

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger number;
-(void)ShoppingCatr:(NSInteger)count androwcount:(NSInteger)rowcount;
@end
