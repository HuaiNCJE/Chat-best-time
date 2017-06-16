//
//  UserViewController.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/17.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "UserViewController.h"
#import "UINavigationController+Passable.h"
#import "UIViewController+Base.h"
#import "UtilsMacro.h"
#import "User.h"
#import "AFNetworkingHelper.h"
#import <UIImageView+WebCache.h>

@interface UserViewController ()

@property (nonatomic, assign) BOOL logged;

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;

@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 注册通知
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 取消
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景图片
    UIImage *image = [UIImage imageNamed:@"menu_bg"];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
    

    
    // 刷新数据
    User *user = [User currentUser];
    _logged = (user != nil ? YES : NO);
    [self refresh];
   
}

//  头像点击事件
- (IBAction)headTapped {
    if (_logged == NO) {
        // 进行登录页面跳转
        [self pushWithStoryboardID:@"Login" data:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_logged ? 3 : 0);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger  index = indexPath.row;
    if (index == 0) { // 个人资料
        // 获取当前用户的ID
        NSString *objectId = [[User currentUser] objectId];
        // 封装 数据
        NSDictionary *data = @{@"isMe": @YES, @"objectId": objectId};
        // 点击进行页面跳转
        [self pushWithStoryboardID:@"Personal" data:data];
    } else if (index == 1) { // 消息中心
        
    } else { // 注销
        // 序列化对象从本地删除 
        [User logout];
        
        //
        _logged = NO;
        [self refresh];
        
        //
        [self.tableView reloadData];
    }
}

#pragma mark - Private


- (void)registerNotifications {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didLogin) name:kNoticationTypeLogin object:nil];
        [center addObserver:self selector:@selector(didReset) name:kNofiticationTypeReset object:nil];
}

- (void)unregisterNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (void)didLogin {
    _logged = YES;
    [self refresh];
}

- (void)didReset {
    [self refresh];
}

// 核心代码
- (void)refresh {
    if (_logged == YES) { // 登录
        NSString *objectId = [[User currentUser] objectId];
        NSDictionary *data = @{@"objectId": objectId};
        
        AFNetworkingHelper *helper = [AFNetworkingHelper defaultHelper];
        [helper sendRequestWithURLString:kURLTypeInfos parameters:data success:^(NSURLSessionDataTask *task, NSDictionary *response) {
            [self successWithTask:task response: response];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            [self failureWithTask:task error:error];
        }];
    } else { // 未登录
        //[self defaultSetting];
        _headImageView.image = [UIImage imageNamed:@"default_user"];
        _nicknameLabel.text = @"点击头像登录";
        [self.tableView reloadData];
    }
}

//  下载成功
- (void)successWithTask:(NSURLSessionDataTask *)task response:(NSDictionary *)response {
    NSInteger code = [response[@"code"] integerValue];
    if (code == 200) {
        // 设置昵称
        NSDictionary *data = response[@"data"];
        _nicknameLabel.text = data[@"nickname"];
        
        // 设置头像
        NSString *photo = data[@"photo"];
        NSURL *url = [NSURL URLWithString:photo];
        if (url != nil) {
            UIImage *image = [UIImage imageNamed:@"default_user"];
            [_headImageView sd_setImageWithURL:url placeholderImage:image];
        } else {
            // 作默认设置
            _headImageView.image = [UIImage imageNamed:@"default_user"];
        }
    } else {
        [self defaultSetting];
    }
    
    [self.tableView reloadData];
}

// 下载失败
- (void)failureWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    [self defaultSetting];
    [self.tableView reloadData];
}

- (void)defaultSetting {
    _headImageView.image = [UIImage imageNamed:@"default_user"];
    _nicknameLabel.text = @"昵称未知";
}

- (void)pushWithStoryboardID:(NSString *)identifier data:(NSObject *)data {
    //  导航效果
    UINavigationController *nav = self.parentViewController.childViewControllers.lastObject;
    [nav pushViewControllerWithStoryboardID:identifier animated:NO data:data];
    
    //  抽屉效果
    [self.slideMenuController switchController];
}


@end
