//
//  MZWReordeTable.h
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MZWReordeTableViewDelegate <NSObject>

@optional

-(void) updateDataSource:(NSMutableArray *)dataArrays;
-(void) mergeRowsInSection:(NSInteger)section splitRowIdentifier:(NSString *)identifier;

@end
@interface MZWReordeTable : UIView
@property (nonatomic,strong) NSMutableArray *objects;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,weak) id <MZWReordeTableViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects;

-(instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects canReorder:(BOOL)reOrder;
@end
