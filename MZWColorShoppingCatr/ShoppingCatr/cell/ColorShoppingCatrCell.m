//
//  ColorShoppingCatrCell.m
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//

#import "ColorShoppingCatrCell.h"

@implementation ColorShoppingCatrCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)minus:(UIButton*)sender {
    
    self.number -= 1;
    
    [self showNumber:self.number];
    self.operationBlock(self.number,sender.tag,NO);
}

- (IBAction)plus:(UIButton*)sender {
    
    self.number += 1;
    [self showNumber:self.number];
    self.operationBlock(self.number,sender.tag,YES);
}
-(void)ShoppingCatr:(NSInteger)count androwcount:(NSInteger)rowcount{
    self.number = count;
    [self showNumber:self.number];
    self.operationBlock(12,0,YES);
}
-(void)showNumber:(NSUInteger)count
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.number];
    if (self.number > 0)
    {
        [self.minus setHidden:NO];
        [self.numberLabel setHidden:NO];
    }
    else
    {
        [self.minus setHidden:YES];
        [self.numberLabel setHidden:YES];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self showNumber:self.number];
    
}


@end
