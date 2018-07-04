//
//  ViewController.m
//  MZWColorShoppingCatr
//
//  Created by 毛织网 on 2018/3/8.
//  Copyright © 2018年 帝步凡. All rights reserved.
//
#define NEWBeginning_Head @""//通用前缀
#define Beginning_Head @""//通用前缀
#define imageBeginning_Head @""//通用前缀
#import "ViewController.h"
#import "MZWColorListCell.h"
#import "ColorShoppingCatrCell.h"
#import "MZWOverlayView.h"
#import "ColorShoppingCatrView.h"
#import "MZWBadgeView.h"
#import "LDXNetWork.h"
//#import "XHWebImageAutoSize.h"
#import "UIImageView+WebCache.h"
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,MZWReordeTableViewDelegate,UITextFieldDelegate,CAAnimationDelegate>{
    NSInteger rowcount;
    NSInteger addjiajia;
    NSInteger addrow;//用于记录tableview是否加载完了
}
@property(nonatomic,strong) NSString *showLabel;//色号与数量
@property(nonatomic,strong) NSString *zongshu;//购买的总数量
@property (nonatomic,strong) NSMutableArray *dataArray;//tableview数据数组
@property (nonatomic,strong) NSMutableArray *ordersArray;//购物车table数据数组
@property (nonatomic,strong) NSArray *historyArray;//本地缓存的数据获取
@property (nonatomic,strong) NSMutableArray *addshoppingid;//缓存这个商品下曾经加到购物车里的商品里的ID
@property (nonatomic,strong) NSMutableArray *addshoppinshuliang;//缓存这个商品下曾经加到购物车里的商品里的数量
@property (nonatomic,strong) CALayer *dotLayer;

@property (nonatomic,assign) CGFloat endPointX;

@property (nonatomic,assign) CGFloat endPointY;

@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic,strong) UITableView *tableView ;

@property (nonatomic,assign) NSUInteger totalOrders;

@property BOOL up;

@property (nonatomic,strong) ColorShoppingCatrView *ShopCartView;

@property(nonatomic, strong) NSIndexPath *selectIndexPath;//用于记录下哪行Cell
@property(nonatomic, assign) NSInteger rowIndexPath;//用于记录下哪行Cell

@property(nonatomic,strong) NSString *URLString;
@property(nonatomic,strong) NSDictionary *Dic;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    _rowIndexPath= 0;
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    [userDefaults1 setObject:@"No" forKey:@"MaoYiAddShibie"];
    
    _AddShibie=2;
    // Do any additional setup after loading the view, typically from a nib.
    /*
     这只是一个demo,用于显示界面效果,实际的数据请结合项目（如Json 解析放到数据模型里更方便一些）
     */
    self.addshoppingid = [[NSMutableArray alloc]init];
    self.addshoppinshuliang = [[NSMutableArray alloc]init];
    if ([self.ordersArray count] <=0) {
        [self.ordersArray addObject:[NSMutableArray array]];
        [self.ordersArray addObject:[NSMutableArray array]];
    }
    NSString *string=[NSString stringWithFormat:@"id%@",_shangpingid];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults arrayForKey:string] ==nil) {
        NSLog(@"数据为空,id%@",_shangpingid);
    }else{
        NSLog(@"数据不为空,id%@",_shangpingid);
        if (_AddShibie==3) {//如果是半价板毛过来的 就不显示普通购买时的数据
            
        }else{
            self.historyArray =[userDefaults arrayForKey:string];
        }
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20 - 50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    
    _ShopCartView = [[ColorShoppingCatrView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, CGRectGetWidth(self.view.bounds), 50) inView:self.view withObjects:nil];
    _ShopCartView.parentView = self.view;
    _ShopCartView.OrderList.delegate = self;
    _ShopCartView.OrderList.tableView.delegate = self;
    _ShopCartView.OrderList.tableView.dataSource = self;
    _ShopCartView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_ShopCartView];
    
    
    CGRect rect = [self.view convertRect:_ShopCartView.shoppingCartBtn.frame fromView:_ShopCartView];
    
    _endPointX = rect.origin.x + 15;
    _endPointY = rect.origin.y + 35;
    
    [self jiazaishuju];
}
-(void)jiazaishuju{
    NSDictionary *dic1 = @{@"seka_id": @9323283,
                           @"seka_name": @"红色",
                           @"seka_no": @12.0,
                           @"praise_num": @20,
                           @"seka_img":@"1.png",
                           @"month_saled":@12};

    NSDictionary *dic2 = @{@"seka_id": @9323284,
                           @"seka_name": @"黄色",
                           @"seka_no": @28.0,
                           @"praise_num": @6,
                           @"seka_img":@"2.png",
                           @"month_saled":@34};

    NSDictionary *dic3 = @{@"seka_id": @9323285,
                           @"seka_name": @"橙色",
                           @"seka_no": @28.0,
                           @"praise_num": @8,
                           @"seka_img":@"3.png",
                           @"month_saled":@16};

    NSDictionary *dic4 = @{@"seka_id": @26844943,
                           @"seka_name": @"绿色",
                           @"seka_no": @32.0,
                           @"praise_num": @1,
                           @"seka_img":@"4.png",
                           @"month_saled":@56};

    NSDictionary *dic5 = @{@"seka_id": @9323279,
                           @"seka_name": @"青色",
                           @"seka_no": @29.0,
                           @"praise_num": @11,
                           @"seka_img":@"5.png",
                           @"month_saled":@11};

    NSDictionary *dic6 = @{@"seka_id": @9323289,
                           @"seka_name": @"蓝色",
                           @"seka_no": @22.0,
                           @"praise_num": @2,
                           @"seka_img":@"6.png",
                           @"month_saled":@5};

    NSDictionary *dic7 = @{@"seka_id": @9323243,
                           @"seka_name": @"紫色",
                           @"seka_no": @72.0,
                           @"praise_num": @0,
                           @"seka_img":@"7.png",
                           @"month_saled":@19};

    NSDictionary *dic8 = @{@"seka_id": @9323220,
                           @"seka_name": @"核红",
                           @"seka_no": @64.0,
                           @"praise_num": @28,
                           @"seka_img":@"8.png",
                           @"month_saled":@7};

    NSDictionary *dic9 = @{@"seka_id": @9323280,
                           @"seka_name": @"桃红",
                           @"seka_no": @30.0,
                           @"praise_num": @48,
                           @"seka_img":@"9.png",
                           @"month_saled":@0};

    NSDictionary *dic10 = @{@"seka_id": @9323267,
                            @"seka_name": @"屌丝绿",
                            @"seka_no": @16.0,
                            @"praise_num": @9,
                            @"seka_img":@"10.png",
                            @"month_saled":@136};
        
    //这样书写的定义数据，用于后面的动态添加订单个数的key：orderCountTF。 实际项目中没有这么复杂
    _dataArray = [@[[dic1 mutableCopy],[dic2 mutableCopy],[dic3 mutableCopy],[dic4 mutableCopy],[dic5 mutableCopy],[dic6 mutableCopy],[dic7 mutableCopy],[dic8 mutableCopy],[dic9 mutableCopy],[dic10 mutableCopy]] mutableCopy];
         NSLog(@"内容：%@",_dataArray);


    
//    [LDXNetWork GetThePHPWithURL:string par:nil success:^(id responseObject) {
//        NSLog(@"GET数据%@",responseObject);
//        _dataArray = [responseObject valueForKeyPath:@"info.seka"];
        NSLog(@"数据个数:%lu",(unsigned long)_dataArray.count);
        for (NSInteger i =0; i<_dataArray.count; i++) {//循环数据  获取ID相同的数据改变数量然后再加载到tableview上
            for (NSInteger j = 0; j<_historyArray.count; j++) {//这一层拿出historyarray
                NSInteger int1 = [_historyArray[j][@"seka_id"]integerValue];
                NSInteger int2 = [_dataArray[i][@"seka_id"]integerValue];
                if (int1==int2) {//用于缓存的数据和请求到的数据的ID相比 如果相同 就改变相对应id的商品数量
                    NSMutableDictionary * dic = _dataArray[i];//从数组中取出那一行
                    NSInteger nCount = [_historyArray[j][@"orderCountTF"]integerValue];//强转
                    [dic setObject:[NSNumber numberWithInteger:nCount] forKey:@"orderCountTF"];//把指定那一行数量变更//
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];//改成可变字典
                    [self storeOrders:dict isAdded:YES withSectionIndex:0 withRowIndex:0];//添加
                    NSLog(@"改变后:%@",_dataArray[i][@"orderCountTF"]);
                    _totalOrders +=[_dataArray[i][@"orderCountTF"]integerValue];//用于在购物车上显示的数量
                    _ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)_totalOrders];
                    [self setCartImage];
                    [self setTotalMoney];
                    
                    //                self.ShopCartView.OrderList.objects = self.ordersArray;
                    [self.ShopCartView.OrderList.tableView reloadData];
                }else{
                    
                }
            }
            if (i>=_dataArray.count-1) {
                [_tableView reloadData];
            }
        }
//    } error:^(NSError *error) {
//        NSLog(@"错误%@",error);
//    }];
//    NSLog(@"网址：%@",string);
    
    
   
    
}

#pragma mark - setter and getter

-(NSMutableArray *)ordersArray
{
    if (!_ordersArray) {
        _ordersArray = [NSMutableArray array];
    }
    return _ordersArray;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    if ([tableView isEqual:self.tableView]) {
        //        count = [_dataArray count];
        return 1;
    }
    else if ([tableView isEqual:self.ShopCartView.OrderList.tableView])
    {
        count = [self.ordersArray[section] count];
        
    }
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{NSUInteger count = 0;
    if ([tableView isEqual:self.ShopCartView.OrderList.tableView])
    {
        
        return [self.ordersArray count];
        
    }
    if ([tableView isEqual:self.tableView]) {
        count = [_dataArray count];
        
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    
    MZWColorListCell *cell = nil;
    if ([tableView isEqual:self.tableView]) {
        static NSString *cellID = @"MZWColorListCell";
        
        cell = (MZWColorListCell *) [tableView dequeueReusableCellWithIdentifier:cellID];
        //        _cell = (MZWColorListCell*) [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.name.text = _dataArray[indexPath.section][@"seka_name"];
            cell.month_saled.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"seka_no"]];
            cell.foodImageView.image = [UIImage imageNamed:_dataArray[indexPath.section][@"seka_img"]];
//            NSString *url = [NSString stringWithFormat:@"%@%@",imageBeginning_Head,_dataArray[indexPath.section][@"seka_img"]];
//            NSLog(@"图片地址:%@",url);
//            [cell.foodImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            }];
            
            cell.foodId = [_dataArray[indexPath.section][@"seka_id"] integerValue];
            cell.amount = _dataArray[indexPath.section][@"orderCountTF"]?[_dataArray[indexPath.section][@"orderCountTF"] integerValue]:0;
            
            
            
            // 1. 创建一个点击事件，点击时触发labelClick方法
            UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
            // 2. 将点击事件添加到label上
            [cell.orderCountTF addGestureRecognizer:labelTapGestureRecognizer];
            cell.orderCountTF.userInteractionEnabled = YES; // 可以理解为设置label可被点击
            cell.orderCountTF.tag=indexPath.section;
            
            cell.plus.tag =indexPath.section;//加号Btn
            cell.minus.tag =indexPath.section;//减号BTN
            //            userInteractionEnabled=NO   可以关闭Btn的交互
            
            __weak __typeof(&*cell)weakCell =cell;
            cell.plusBlock = ^(NSInteger nCount,NSInteger rowcount,BOOL animated,BOOL countall)
            {
                
                NSMutableDictionary * dic = _dataArray[rowcount];//从数组中取出那一行
                NSInteger numberint=  [[dic objectForKey:@"orderCountTF"] integerValue];//获取被改变之前的数量 用于计算购物车数量
                [dic setObject:[NSNumber numberWithInteger:nCount] forKey:@"orderCountTF"];//把指定那一行数量变更
                CGRect parentRect = [weakCell convertRect:weakCell.plus.frame toView:self.view];
                
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
                
                [self storeOrders:dict isAdded:animated withSectionIndex:0 withRowIndex:0];
                if (countall) {//是用于识别点击了加减按钮加的还是点击了数量的点击事件加的 YES是加减  NO是数量点击事件
                    if (animated) {
                        if (_AddShibie==3) {
                            [userDefaults1 setObject:@"Yes" forKey:@"MaoYiAddShibie"];
                        }
                        _totalOrders ++;
                    }
                    else
                    {
                        if (_AddShibie==3) {
                            [userDefaults1 setObject:@"No" forKey:@"MaoYiAddShibie"];
                        }
                        _totalOrders --;
                    }
                }else{
                    NSInteger numberindex = 0;//用于记录数量label点击后输入的数量加或减原有数量的和
                    if (numberint<nCount) {//当原有的numberint的数量小于修改后的nCount的数量的时候 需要用nCount-numberint得出加了N个 然后totalOrders加上这N个
                        //                                [self JoinCartAnimationWithRect:parentRect];不需要动画效果
                        numberindex=nCount-numberint;
                        _totalOrders +=numberindex;
                    }else if (numberint>nCount){//当原有的numberint的数量大于修改后的nCount的数量的时候 需要用numberint-nCount得出减少了N个 然后totalOrders减去这N个
                        numberindex=numberint-nCount;
                        _totalOrders -=numberindex;
                    }
                }
                
                _ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)_totalOrders];//显示购物车有多少订单
                
                [self setCartImage];
                [self setTotalMoney];
                NSIndexSet *indexSetA = [[NSIndexSet alloc]initWithIndex:rowcount];    //刷新第3段
                
                [tableView reloadSections:indexSetA withRowAnimation:UITableViewRowAnimationAutomatic];
                
                
                
            };
            
            
        }
        
        return cell;
    }
    else if ([tableView isEqual:_ShopCartView.OrderList.tableView])
    {
        static NSString *cellID = @"ColorShoppingCatrCell";
        
        ColorShoppingCatrCell *cell = (ColorShoppingCatrCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
        }
        NSMutableArray *sectionArray =[NSMutableArray array];
        sectionArray = [self.ordersArray objectAtIndex:indexPath.section];
        
        //
        cell.id = [sectionArray[indexPath.row][@"seka_id"] integerValue];
        cell.nameLabel.text = sectionArray[indexPath.row][@"seka_name"];
        
        cell.priceLabel.text = [NSString stringWithFormat:@"%@",sectionArray[indexPath.row][@"seka_no"]] ;
        
        NSInteger count = [sectionArray[indexPath.row][@"orderCountTF"] integerValue];
        
        // 1. 创建一个点击事件，点击时触发labelClick方法
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShoppingCatrcount:)];
        // 2. 将点击事件添加到label上
        [cell.numberLabel addGestureRecognizer:labelTapGestureRecognizer];
        cell.numberLabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
        cell.numberLabel.tag=[sectionArray[indexPath.row][@"seka_id"] integerValue];
        cell.minus.tag=indexPath.row;
        cell.plus.tag=indexPath.row;
        cell.number = count;
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section % 3 == 0) {
            cell.dotLabel.textColor = [UIColor greenColor];
        }
        else if (indexPath.section % 3 == 1)
        {
            cell.dotLabel.textColor = [UIColor yellowColor];
        }
        else if (indexPath.section % 3 == 2)
        {
            cell.dotLabel.textColor = [UIColor redColor];
        }
        
        cell.operationBlock = ^(NSUInteger nCount,NSUInteger rowcount,BOOL plus)
        {
            
            NSMutableDictionary * dic = sectionArray[rowcount];
            
            //更新订单列表中的数量
            [dic setObject:[NSNumber numberWithInteger:nCount] forKey:@"orderCountTF"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            //获取当前id的所有数量
            NSInteger nTotal = [self CountAllSections:[NSString stringWithFormat:@"%ld",[dic[@"seka_id"] integerValue]]];
            [dict setObject:[NSNumber numberWithInteger:nTotal] forKey:@"orderCountTF"];
            
            [self storeOrders:dict isAdded:plus withSectionIndex:indexPath.section withRowIndex:indexPath.row];
            if (plus==NO) {
                if (_AddShibie==3) {
                    [userDefaults1 setObject:@"No" forKey:@"MaoYiAddShibie"];
                }
            }
            _totalOrders = plus ? ++_totalOrders : --_totalOrders;
            
            _ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)_totalOrders];//显示购物车有多少订单
            //刷新tableView
            [self.tableView reloadData];
            [self setCartImage];
            [self setTotalMoney];
            if (_totalOrders <=0) {
                [_ShopCartView dismissAnimated:YES];
            }
            
        };
        
        return cell;
    }
    return cell;
    
}



//  在此方法中设置点击label后要触发的操作 (选色列表label手势)
- (void)labelClick:(UITapGestureRecognizer*)gestureRecognizer {
    
    //首先获取哪一行的Cell被点击了
    self.selectIndexPath =[NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    _rowIndexPath=1;//用于在获取到TF的内容后识别是Food还是shoppingCatr的
    //    创建一个有输入框的提醒框作为数量的输入
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入您需要多少公斤";
    txtName.delegate =self;
    txtName.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

//  在此方法中设置点击label后要触发的操作 (购物车列表label手势)
- (void)ShoppingCatrcount:(UITapGestureRecognizer*)gestureRecognizer {
    
    NSUInteger index=0;
    for (int i=0; i<_dataArray.count; i++) {//用于寻找出数组中哪一行的ID与rowcountstr的id一样  那需要改动的就是哪一行的数据
        NSString *string = [NSString stringWithFormat:@"%@",_dataArray[i][@"seka_id"]];
        NSString *tgrstr =[NSString stringWithFormat:@"%ld",(long)gestureRecognizer.view.tag];
        NSLog(@"啦啦啦%@",string);
        if ([string isEqualToString:tgrstr]) {
            index = i;
            NSLog(@"找到啦：是第%ld个是",(long)index);
            break;
        }
        
    }
    //首先获取哪一行的Cell被点击了
    self.selectIndexPath =[NSIndexPath indexPathForRow:0 inSection:index];
    _rowIndexPath=2;//用于在获取到TF的内容后识别是Food还是shoppingCatr的
    //    创建一个有输入框的提醒框作为数量的输入
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入您需要多少公斤";
    txtName.delegate =self;
    txtName.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        if (txt.text.length>0) {//保证有数量的情况下才做修改
            //            //获取txt内容写入到JIAJIA就可以了
            NSInteger sectioncount = [txt.text integerValue];
            //            if (_rowIndexPath==1) {
            MZWColorListCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndexPath];
            [cell JIAJIA:sectioncount andButtontag:self.selectIndexPath.section];
            //            }else if (_rowIndexPath==2){
            //                ColorShoppingCatrCell *cell  =[self.tableView cellForRowAtIndexPath:self.selectIndexPath];
            //                NSLog(@"行数%ld：%ld",(long)self.selectIndexPath.row,sectioncount);
            //                [cell ShoppingCatr:sectioncount androwcount:self.selectIndexPath.row];
            //            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:self.tableView]) {
        NSLog(@"组%ld,行%ld",(long)indexPath.section,(long)indexPath.row);
    }
}

#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect
{
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(_endPointX, _endPointY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor redColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 15, 15);
    _dotLayer.cornerRadius = (15 + 15) /4;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
    
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.8f];
    
}
- (void)removeFromLayer:(CALayer *)layerAnimation{
    
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1];
        shakeAnimation.autoreverses = YES;
        [_ShopCartView.shoppingCartBtn.layer addAnimation:shakeAnimation forKey:nil];
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView])
    {
        return 70;
    }
    else if ([tableView isEqual:self.ShopCartView.OrderList.tableView])
    {
        return 50;
    }
    return 70;
}

#define SECTION_HEIGHT 30.0
// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:self.ShopCartView.OrderList.tableView])
    {
        if (section==0) {
            return SECTION_HEIGHT;
        }else return 0;
    }
    else
        return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SECTION_HEIGHT)];
    UILabel *leftLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 3, SECTION_HEIGHT)];
    [view addSubview:leftLine];
    if (section == 0) {
        
        
        UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, SECTION_HEIGHT)];
        headerTitle.text = [NSString stringWithFormat:@"%ld号口袋",section +1];
        headerTitle.font = [UIFont systemFontOfSize:12];
        [view addSubview:headerTitle];
        leftLine.backgroundColor = [UIColor greenColor];
        UIButton *clear = [UIButton buttonWithType:UIButtonTypeCustom];
        clear.frame= CGRectMake(self.view.bounds.size.width - 100, 0, 100, SECTION_HEIGHT);
        [clear setTitle:@"清空购物车" forState:UIControlStateNormal];
        [clear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        clear.titleLabel.textAlignment = NSTextAlignmentCenter;
        clear.titleLabel.font = [UIFont systemFontOfSize:12];
        [clear addTarget:self action:@selector(clearShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:clear];
    }
    else{
        
        if (section % 3 == 0) {
            leftLine.backgroundColor = [UIColor greenColor];
        }
        else if (section % 3 == 1)
        {
            leftLine.backgroundColor = [UIColor yellowColor];
        }
        else if (section % 3 == 2)
        {
            leftLine.backgroundColor = [UIColor redColor];
        }
        
    }
    
    //    view.backgroundColor = kUIColorFromRGB(0x9BCB3D);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}




#pragma mark - private method

-(void)clearShoppingCart:(UIButton *)sender
{
    [self.ordersArray removeAllObjects];
    
    
    _totalOrders = 0;
    _ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)_totalOrders];
    
    
    [self setTotalMoney];
    [self setCartImage];
    [self.ShopCartView dismissAnimated:YES];
    
    for (NSMutableDictionary *dic in self.dataArray) {
        
        [dic setObject:@"0" forKey:@"orderCountTF"];
        
    }
    [self.tableView reloadData];
}

-(void)setCartImage
{
    if (_totalOrders) {
        [_ShopCartView setCartImage:@"cart_1"];
    }
    else{
        [_ShopCartView setCartImage:@"cart"];
    }
    
}
//计算总金额
-(void)setTotalMoney
{
    
    NSInteger nTotal = 0;
    NSInteger count=0;
    NSMutableArray *mutablearr = [[NSMutableArray alloc]init];
    for (NSMutableArray *array in self.ordersArray) {
        for (NSMutableDictionary *dic in array) {
//            nTotal += [dic[@"orderCountTF"] integerValue] * [dic[@"seka_no"] integerValue];
            nTotal += [dic[@"orderCountTF"] integerValue] * 2;
            NSLog(@"进来次数%ld",(long)count++);
            [mutablearr  addObject:[NSString stringWithFormat:@"%@#%@公斤",dic[@"seka_name"],dic[@"orderCountTF"]]];
        }
    }
    
    //    [_ShopCartView setTotalMoney:nTotal];
    [_ShopCartView setTotalMoney:nTotal andmutablearr:mutablearr];
    
}
#pragma mark - store orders 存放订单


-(void)storeOrders:(NSMutableDictionary *)dictionary isAdded:(BOOL)added withSectionIndex:(NSInteger)sectionID withRowIndex:(NSInteger)rowID
{
    NSLog(@"进来存放订单了");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    if (added) {
        //如果订单数组是空（无商品） 则需创建两个section (1号口袋，2号口袋（被添加）)
        if ([self.ordersArray count] <=0) {
            [self.ordersArray addObject:[NSMutableArray array]];
            [self.ordersArray addObject:[NSMutableArray array]];
        }else if ([self.ordersArray count] <=1) {
            [self.ordersArray addObject:[NSMutableArray array]];
        }
        //如果是从商品列表中添加，传人的sectionID为0
        //如果是从订单列表中添加，传人的sectionID是订单中实际的section
        
        for (NSMutableDictionary *dic in self.ordersArray[sectionID]) {
            if (dic[@"seka_id"] == dict[@"seka_id"]){
                
                NSInteger count = [self CountOthersWithoutSection:sectionID foodID:dictionary[@"seka_id"]];
                NSInteger nCount = [dict[@"orderCountTF"] integerValue] - count;
                
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCountTF"];
                if (_AddShibie==3) {//如果是半价板毛过来的 就不替换普通购买时的数据
                    
                }else{
                    NSString *idstring = [NSString stringWithFormat:@"id%@",_shangpingid];//用于本地缓存  保留数据下次进来还存在
                    NSArray *arr =_ordersArray[sectionID];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:arr forKey:idstring];
                    
                }
                self.ShopCartView.OrderList.objects = self.ordersArray;
                [self.ShopCartView.OrderList.tableView reloadData];
                
                return;
            }
        }
        
        NSInteger count = [self CountOthersWithoutSection:sectionID foodID:dictionary[@"seka_id"]];
        count = [dictionary[@"orderCountTF"] integerValue] - count;
        [dictionary setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"orderCountTF"];
        [self.ordersArray[sectionID] addObject:dictionary];
        if (_AddShibie==3) {//如果是半价板毛过来的 就不替换普通购买时的数据
            
        }else{
            NSString *idstring = [NSString stringWithFormat:@"id%@",_shangpingid];//用于本地缓存  保留数据下次进来还存在
            NSArray *arr =_ordersArray[sectionID];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:arr forKey:idstring];
            
        }
        self.ShopCartView.OrderList.objects = self.ordersArray;
        [self.ShopCartView.OrderList.tableView reloadData];
    }
    else{
        //从商品列表删除，传人的section =0;优先section：0移除商品，然后再从其他section移除商品
        //从订单列表删除，就从指定的section移除相同的商品
        
        //block 代码段
        void(^block)(NSInteger,NSInteger) = ^(NSInteger section,NSInteger row){
            
            NSDictionary *dic = self.ordersArray[section][row];
            NSInteger count = [dic[@"orderCountTF"] integerValue];
            if (count <= 0) {
                
                [self.ordersArray[section] removeObjectAtIndex:row];
                self.ShopCartView.OrderList.objects = self.ordersArray;
                [self.ShopCartView.OrderList.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:section]]  withRowAnimation:UITableViewRowAnimationBottom];
                
                //section
                if ([self.ordersArray[section] count] <=0) {
                    [self.ordersArray removeObjectAtIndex:section];
                    [self.ShopCartView.OrderList.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationBottom];
                }
                
                [self.ShopCartView.OrderList.tableView reloadData];
                [self.ShopCartView updateFrame:self.ShopCartView.OrderList];
            }
            else{
                
            }
        };
        
        
        if (!sectionID && !rowID) {
            NSMutableDictionary *dic = self.ordersArray[sectionID][rowID];
            
            if (dic[@"seka_id"] == dict[@"seka_id"]) {
                NSInteger nCount = [dict[@"orderCountTF"] integerValue];
                //                nCount -= 1;
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCountTF"];
                block(sectionID,rowID);
                
                self.ShopCartView.OrderList.objects = self.ordersArray;
                
                [self.ShopCartView.OrderList.tableView reloadData];
            }
            else{
                //section:0 有该商品
                NSMutableArray *sectionArray = self.ordersArray[sectionID];
                NSInteger row = 0;
                for (NSMutableDictionary *dic in sectionArray)
                {
                    if (dict[@"seka_id"] == dic[@"seka_id"]) {
                        NSInteger nCount = [dic[@"orderCountTF"] integerValue];
                        nCount -= 1;
                        [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCountTF"];
                        block(sectionID,row);
                        
                        self.ShopCartView.OrderList.objects = self.ordersArray;
                        
                        [self.ShopCartView.OrderList.tableView reloadData];
                        
                        return;
                    }
                    row ++;
                }
                
                //section:0 没有该商品
                for (NSInteger i = sectionID + 1; i < [self.ordersArray count]; i ++) {
                    
                    sectionArray = self.ordersArray[i];
                    row = 0;
                    for (NSMutableDictionary *dic in sectionArray) {
                        if (dict[@"seka_id"] == dic[@"seka_id"]) {
                            NSInteger nCount = [dic[@"orderCountTF"] integerValue];
                            nCount -= 1;
                            [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCountTF"];
                            
                            if (nCount <= 0) {
                                
                                block(i,row);
                                self.ShopCartView.OrderList.objects = self.ordersArray;
                                
                                [self.ShopCartView.OrderList.tableView reloadData];
                                return;
                            }
                            
                            //刷新当前row
                            [self.ShopCartView.OrderList.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:i],nil] withRowAnimation:UITableViewRowAnimationNone];
                            
                            self.ShopCartView.OrderList.objects = self.ordersArray;
                            
                        }
                        row ++;
                    }
                }
            }
        }
        else{
            
            block(sectionID,rowID);
            
        }
        
        
    }
    if (_AddShibie==3) {//如果是半价板毛过来的 就不替换普通购买时的数据
        
    }else{
        NSString *idstring = [NSString stringWithFormat:@"id%@",_shangpingid];//用于本地缓存  保留数据下次进来还存在
        NSArray *arr =_ordersArray[0];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:arr forKey:idstring];
    }
    
    
}
//计算在其他section中的指定fooid的个数
-(NSInteger)CountOthersWithoutSection:(NSInteger)sectionID foodID:(NSString *)foodID
{
    NSInteger count = 0;
    for (int i = 0; i< self.ordersArray.count; i++) {
        if (sectionID == i) {
            continue;
        }
        NSMutableArray *array = self.ordersArray[i];
        for (NSMutableDictionary *dic in array) {
            if ([dic[@"seka_id"] integerValue] == [foodID integerValue]) {
                count += [dic[@"orderCountTF"] integerValue];
            }
        }
    }
    
    return count;
}
//计算所有section中指定fooid的个数
-(NSInteger)CountAllSections:(NSString *)foodID
{
    int nCount = 0;
    for (NSMutableArray *array in self.ordersArray) {
        for (NSMutableDictionary *dic in array)
        {
            if ([dic[@"seka_id"] integerValue] == [foodID integerValue]) {
                nCount += [dic[@"orderCountTF"] integerValue];
            }
        }
    }
    NSMutableDictionary *dic = [self GetDictionaryFromID:[foodID integerValue]];
    
    [dic setObject:[NSNumber numberWithInt:nCount] forKey:@"orderCountTF"];
    return nCount;
}

//foodid 获取其模型model 或者字典

-(NSMutableDictionary *)GetDictionaryFromID:(NSInteger)foodID
{
    for (NSMutableDictionary *dic in self.dataArray) {
        if ([dic[@"seka_id"] integerValue] == foodID) {
            return dic;
        }
    }
    return nil;
}


#pragma mark - ZFOrderListsViewDelegate

-(void) updateDataSource:(NSMutableArray *)dataArrays
{
    if ([self.ShopCartView.OrderList.delegate respondsToSelector:@selector(updateDataSource:)]) {
        
        
        self.ordersArray = dataArrays;
        
        //        [self.delegate updateDataSource:dataArrays];
        [self.ShopCartView updateFrame:self.ShopCartView.OrderList];
        [self.ShopCartView.OrderList.tableView reloadData];
        
    }
}

//合并相同的row
-(void) mergeRowsInSection:(NSInteger)section splitRowIdentifier:(NSString *)identifier
{
    if ([self.ShopCartView.OrderList.delegate respondsToSelector:@selector(mergeRowsInSection:splitRowIdentifier:)]) {
        
        NSMutableArray *array = [self.ordersArray objectAtIndex:section];
        
        if (identifier) {
            int index = 0;
            
            for (NSMutableDictionary *dic in array) {
                if ([dic[@"seka_id"] integerValue] == [identifier integerValue]){
                    NSInteger count = [dic[@"orderCountTF"] integerValue] + 1;
                    [dic setObject:[NSNumber numberWithInteger:count] forKey:@"orderCountTF"];
                    
                    [self.ShopCartView.OrderList.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:section]]  withRowAnimation:UITableViewRowAnimationFade];
                    [self.ShopCartView updateFrame:self.ShopCartView.OrderList];
                    return;
                }
                index ++;
            }
            
            //快速获取当前foodid的详情
            
            for (NSDictionary *dictionary in self.dataArray) {
                if ([dictionary[@"seka_id"] integerValue]== [identifier integerValue]) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                    [dict setObject:@1 forKey:@"orderCountTF"];
                    [array addObject:dict];
                    
                    
                    if (array.count > 1) {
                        [self.ShopCartView.OrderList.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:array.count-1 inSection:section]]  withRowAnimation:UITableViewRowAnimationFade];
                    }
                    else{
                        [self.ShopCartView.OrderList.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:section]]  withRowAnimation:UITableViewRowAnimationFade];
                    }
                    
                    //更新购物清单的frame
                    [self.ShopCartView updateFrame:self.ShopCartView.OrderList];
                }
            }
        }
        
        int sameIndex = -1;
        for(int i = 0; i< array.count; i++){
            for (int j = i + 1; j < array.count; j++) {
                
                if ([array[i][@"seka_id"] integerValue] == [array[j][@"seka_id"] integerValue]) {
                    
                    NSInteger count = [array[i][@"orderCountTF"] integerValue] + [array[j][@"orderCountTF"] integerValue];
                    [array[i] setObject:[NSNumber numberWithInteger:count] forKey:@"orderCountTF"];
                    sameIndex = j;
                    [self.ShopCartView.OrderList.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:section]]  withRowAnimation:UITableViewRowAnimationFade];
                    
                    break;
                }
            }
            
            if (sameIndex > 0) {
                //合并相同的数据
                
                [array removeObjectAtIndex:sameIndex];
                
                [self.ShopCartView.OrderList.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sameIndex inSection:section]]  withRowAnimation:UITableViewRowAnimationFade];
                
                
                //更新购物清单的frame
                [self.ShopCartView updateFrame:self.ShopCartView.OrderList];
                
                break;
            }
        }
        
    }
}
//textfield的代理方法：自行写逻辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"，。！？"]];
    NSLog(@"点击了搜索，内容是:%@",textField.text);
    return YES;
}
- (void)usernameDidChange:(UITextField *)textField {
    NSLog(@"实时内容更新:%@",textField.text);
    
    
}
//设置文本框只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self validateNumber:string];
    
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
@end
