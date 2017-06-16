//
//  HomeTableViewController.m
//  BestTime
//
//  Created by iPhone8s on 2017/6/13.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "HomeTableViewController.h"
#import "UIViewController+Base.h"
#import "CJEModel.h"
#import "CJETableViewCell.h"

#import <SDCycleScrollView.h>
#import <SDAutoLayout.h>


@interface HomeTableViewController ()

@property (nonatomic, strong) NSMutableArray *modelsArray;

@end

@implementation HomeTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.slideMenuController.pan.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.slideMenuController.pan.enabled = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置委托
    NavigationHelper *helper = [NavigationHelper defaultHelper];
    self.navigationController.delegate = helper;
    
    // 封装函数 提高viewDidLoad可读性
    [self setupHeaderView];
    
    [self creatWorld:10];
    
    //self.navigationController.navigationBar.translucent = NO;
    
    // 设置标题
    self.title = @"美好时光";
   
}

- (void)setupHeaderView {
    
    UIView *header = [UIView new];
    
    // 由于tableviewHeaderView的特殊性，在使他高度自适应之前你最好先给它设置一个宽度
    header.width = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *picImages = @[@"t6.jpg",@"t7.jpg",@"t5.jpg",@"t4.jpg",@"t3.jpg",@"t2.jpg",@"t1.jpg"];
    
    SDCycleScrollView *scrollView = [SDCycleScrollView new];
    scrollView.localizationImageNamesGroup = picImages;
    [header addSubview:scrollView];
    
    UILabel *tagLabel = [UILabel new];
    tagLabel.font = [UIFont systemFontOfSize:13];
    tagLabel.textColor = [UIColor lightGrayColor];
    tagLabel.text = @"见你的第一眼，我发现，我爱上了你！";
    [header addSubview:tagLabel];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [header addSubview:bottomLine];
    
    scrollView.sd_layout
    .leftSpaceToView(header,0)
    .topSpaceToView(header,0)
    .rightSpaceToView(header,0)
    .heightIs(180);
    
    tagLabel.sd_layout
    .leftSpaceToView(header,10)
    .topSpaceToView(scrollView,0)
    .rightSpaceToView(header,0)
    .heightIs(25);
    
    bottomLine.sd_layout
    .topSpaceToView(tagLabel,0)
    .leftSpaceToView(header,0)
    .rightSpaceToView(header,0)
    .heightIs(1);
    
    // 设置底面视图自适应  解决轮播图遮挡单元格问题
    [header setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
    [header layoutSubviews];
    
    // 显示轮播图
    self.tableView.tableHeaderView = header;
    
}

- (void)creatWorld:(NSInteger)count {
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray new];
    }
    
    NSArray *icon = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg"];
    
    NSArray *names = @[@"杨易",@"杨",@"易",@"杨杨",@"易心一易",@"杨杨得易"];
    
    NSArray *text = @[@"大家好，我叫杨易",@"爱的故事上集",@"遇见，因为时光",@"看！起风了",@"如果能早些遇见，结局会不会不一样"];
    
    NSArray *pic = @[@"t1.jpg",@"t2.jpg",@"t2.jpg",@"t2.jpg",@"t2.jpg",@"t2.jpg"];
    
    // 将数据存储NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:names forKey:@"names"];
    [userDefaults setObject:text forKey:@"text"];
    [userDefaults setObject:pic forKey:@"pic"];
    
    // 同步存储到磁盘
    [userDefaults synchronize];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        int picRandomIndex = arc4random_uniform(5);
        
        CJEModel *model = [CJEModel new];
        model.iconName = icon[iconRandomIndex];
        model.name = names[nameRandomIndex];
        model.content = text[contentRandomIndex];
        
        // 模拟“有或者无图片”
        int random = arc4random_uniform(100);
        if (random <= 80) {
            model.picName = pic[picRandomIndex];
        }
        
        [self.modelsArray addObject:model];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.modelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"test";
    CJETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CJETableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.modelsArray[indexPath.row];
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
    /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
    
    return [self.tableView cellHeightForIndexPath:indexPath model:self.modelsArray[indexPath.row] keyPath:@"model" cellClass:[CJETableViewCell class] contentViewWidth:[self cellContentViewWith]];
}


- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


@end
