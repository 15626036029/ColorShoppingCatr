//
//  MZWColorListCell.m
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//

#import "MZWColorListCell.h"
#import "Masonry.h"
#import "ViewController.h"
@implementation MZWColorListCell

- (void)awakeFromNib {
    // Initialization code
    
    self.amount = 0;
    self.foodImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.foodImageView.layer.cornerRadius = 5;
    self.foodImageView.layer.masksToBounds = YES;
    
    [self.minus setHidden:YES];
    [self.orderCountTF setHidden:YES];
    
    [self bringSubviewToFront:self.plusImageView];
    //    //减
    //    @property (weak, nonatomic) IBOutlet UIButton *minus;
    //    //加
    //    @property (weak, nonatomic) IBOutlet UIButton *plus;
    //    //数量
    //    @property (weak, nonatomic) IBOutlet UITextField *orderCountTFTF;
    [self.plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.mas_equalTo(self.foodImageView.mas_bottom);
        make.width.height.mas_equalTo(35);
    }];
    [self.orderCountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plus.mas_left).offset(-5);
        make.bottom.mas_equalTo(self.plus.mas_bottom);
        make.top.mas_equalTo(self.plus.mas_top);
        make.width.mas_equalTo(45);
    }];
    [self.minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderCountTF.mas_left).offset(-5);
        make.bottom.mas_equalTo(self.plus.mas_bottom);
        make.top.mas_equalTo(self.plus.mas_top);
        make.width.mas_equalTo(35);
    }];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)plus:(UIButton*)sender {
    NSLog(@"++:%ld",(long)self.amount);
    self.amount += 1;
    
    self.plusBlock(self.amount,sender.tag,YES,YES);
    
    [self showOrderNumbers:self.amount];//只是计算是否隐藏减少按钮和数量TF的作用
    
}
- (IBAction)minus:(UIButton*)sender {
    
    self.amount -= 1;
    
    self.plusBlock(self.amount,sender.tag,NO,YES);
    
    [self showOrderNumbers:self.amount];//只是计算是否隐藏减少按钮和数量TF的作用
}

-(void)JIAJIA:(NSInteger)count andButtontag:(NSInteger)tag{
    
    self.amount = count;
    self.plusBlock(self.amount,tag,YES,NO);
    
    [self showOrderNumbers:self.amount];//只是计算是否隐藏减少按钮和数量TF的作用
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self showOrderNumbers:self.amount];
    
}


-(void)showOrderNumbers:(NSUInteger)count
{
    self.orderCountTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.amount];
    if (self.amount > 0)
    {
        [self.minus setHidden:NO];
        [self.orderCountTF setHidden:NO];
    }
    else
    {
        [self.minus setHidden:YES];
        [self.orderCountTF setHidden:YES];
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return NO;
    
}

@end
