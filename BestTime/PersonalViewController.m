//
//  PersonalViewController.m
//  BestTime
//
//  Created by iPhone8s on 2017/6/1.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "PersonalViewController.h"
#import "UserInfo.h"
#import "AFNetworkingHelper.h"
#import "UIHelper.h"
#import <UIImageView+WebCache.h>
#import "ConversionHelper.h"

@interface PersonalViewController ()

// 是否是用户本人查看页面
@property (nonatomic, assign) BOOL isMe;
@property (nonatomic, strong) NSString *objectId;
// 当前用户数据
@property (nonatomic, strong) UserInfo *object;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *labels;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *editItem;

@end

@implementation PersonalViewController

// 传值
- (void)viewControllerDidShowWithTag:(NSString *)tag data:(NSObject *)data {
    
    NSDictionary *entries = (NSDictionary *)data;
    // 取出布尔值
    self.isMe = [entries[@"isMe"] boolValue];
    self.objectId = entries[@"objectId"];
    
    [self refresh];
}

- (IBAction)editButtonPressed {
    
    // 构造动态可变的字典 指明头像
    NSMutableDictionary *data = [@{@"head": _imageView.image} mutableCopy];
    // 用户数据是否为空
    if (_object != nil) {
        // 传入数据
        data[@"object"] = _object;
    }
    
    //  进行编辑页面的跳转
    [self.navigationController pushViewControllerWithStoryboardID:@"Edit" animated:YES data:data];
}

//  打招呼效果 暂时用弹框代替
//- (IBAction)helloButtonPressed {
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你好" message:@"很高兴认识你！" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleCancel handler:nil]];
//    
//    // 无此句 弹框效果不出现
//    [self presentViewController:alert animated:YES completion:nil];
//
//}

#pragma mark - UITableViewDataSource

// 根据实际情况调整 单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 登录之后无打招呼的按钮
    return (_isMe ? 2 : 3);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 114;
    } else if (indexPath.row == 1) {
        return [self theSecondCellHeight];
    } else {
        return 60;
    }
}


#pragma mark - Private

- (void)refresh {
    //
    if (_isMe == NO) {
        // 去掉右边的编辑资料
        self.navigationItem.rightBarButtonItem = nil;
        self.title = @"个人资料";
    }
    
    
    // 构建数据 初始化词典 当value为nil 时 程序崩溃 通过判断语句解决
    if (_object != nil) {
     NSDictionary *data = @{@"objectId":_object};
    
    
    AFNetworkingHelper *helper = [AFNetworkingHelper defaultHelper];
    [helper sendRequestWithURLString:kURLTypeInfos parameters:data success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        [self successWithTask:task response:response];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithTask:task error:error];
    }];
 }
    
    
    /*
    // 使用标准的初始化方法 解决value为 nil引发程序崩溃问题
   [NSDictionary  dictionaryWithObjectsAndKeys:_object ,@"objectId",nil];
    
    
    AFNetworkingHelper *helper = [AFNetworkingHelper defaultHelper];
    [helper sendRequestWithURLString:kURLTypeInfos parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        [self successWithTask:task response:response];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithTask:task error:error];
    }];
     */
    
}

- (CGFloat)theSecondCellHeight {
    
    // 获取当前屏幕尺寸
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    // 单元格尺寸自定义大小
    CGFloat width = screenSize.width - 64;
    // 高度为0
    CGSize size = CGSizeMake(width,0);
    
    // 调用方法 实现文字自适应
    size = [_labels[9] sizeThatFits:size];
    return  (size.height + 284);
}

- (void)successWithTask:(NSURLSessionDataTask *)task response:(NSDictionary *)response {
    
    NSDictionary *data = response[@"data"];
    if (data != nil) {
        self.object = [UserInfo userInfoWithDictionary:data];
        [self reload:_object];
    } else {
        [UIHelper showErrorWithText:@"网络异常，请稍后重试" inView:self.view];
        
    }
}

- (void)failureWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    [UIHelper showErrorWithText:@"网络不好，稍后重试" inView:self.view];
    
    NSLog(@"hello");
}

// 加载数据
- (void)reload:(UserInfo *)object {
    //
    UIImage *image = [UIImage imageNamed:@"personal_head"];
    NSURL *url = [NSURL URLWithString:object.photo];
    if (url != nil) {
        // 默认加载
        [_imageView sd_setImageWithURL:url placeholderImage:image];
    } else {
        _imageView.image = image;
    }
   
    //
    NSString *nickname = [ConversionHelper stringWithString:object.nickname defaultValue:@"-"];
    NSString *sex = [ConversionHelper stringWithString:object.sex defaultValue:@"-"];
    NSString *record = [ConversionHelper stringWithString:object.record defaultValue:@"-"];
    NSString *marital = [ConversionHelper stringWithString:object.marital defaultValue:@"-"];
    NSString *address = [ConversionHelper stringWithString:object.address defaultValue:@"-"];
    NSString *contact = [ConversionHelper stringWithString:object.contact defaultValue:@"-"];
    NSString *introduce = [ConversionHelper stringWithString:object.introduce defaultValue:@"-"];
    
    // 设置
    [_labels[0] setText:nickname];
    [_labels[1] setText:sex];
    [_labels[2] setText:record];
    [_labels[3] setText:object.salary];
    [_labels[4] setText:object.age];
    [_labels[5] setText:object.height];
    [_labels[6] setText:marital];
    [_labels[7] setText:address];
    [_labels[8] setText:contact];
    [_labels[9] setText:introduce];
    
    
    // 重新刷新数据
    [self.tableView reloadData];
        
}

@end
