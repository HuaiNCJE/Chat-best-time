//
//  LoginViewController.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/26.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "LoginViewController.h"
#import "VerifyHelper.h"
#import "UIHelper.h"
#import "AFNetworkingHelper.h"
#import "User.h"
#import "UtilsMacro.h"

@interface LoginViewController ()

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *fields;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginButtonPressed:(id)sender {
    if ([self verify]) {
        [UIHelper showLoadingInView:self.view];
        
        NSString *username = [_fields[0] text];
        NSString *password = [_fields[1] text];
        NSDictionary *params = @{@"username": username, @"password": password};
        
        
        AFNetworkingHelper *helper = [AFNetworkingHelper defaultHelper];
        [helper sendRequestWithURLString:kURLTypeLogin parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *response) {
            
            // 加载效果
            [UIHelper dismissLoadingInView:self.view];
            [self successWithTask:task response:response];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [UIHelper dismissLoadingInView:self.view];
            [self failureWithTask:task error:error];
            
        }];

        
    }
}

//
- (IBAction)textFieldDidEndOnExit:(id)sender {
    if (_fields[0] == sender) {
        [sender resignFirstResponder];
        [_fields[1] becomeFirstResponder];
    } else {
        [_fields[1] resignFirstResponder];
    }
}

// 触摸屏幕时，键盘消失
- (IBAction)touched {
    [self.view endEditing:YES];
}


#pragma mark - Private

// 验证
- (BOOL)verify {
    //
    NSString *name = [_fields[0] text];
    if ([VerifyHelper isEmptyString:name]) {
        [UIHelper showTipsWithText:@"请输入用户名" inView:self.view];
        return NO;
    }
    
    //
    NSString *password = [_fields[1] text];
    if ([VerifyHelper isEmptyString:password]) {
        [UIHelper showTipsWithText:@"请输入密码" inView:self.view];
        return NO;
    }
    
    
    
    return YES;
    
}

- (void)successWithTask:(NSURLSessionDataTask *)task response:(NSDictionary *)response {
    NSInteger code = [response[@"code"] integerValue];
    if (code == 200) {
      
        // 取得数据
        NSDictionary *data = response[@"data"];
        NSString *objectId = data[@"objectId"];
        NSString *username = data[@"username"];
        [User loginWithID:objectId username:username];
        
        // 发出登录通知 刷新页面
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:kNoticationTypeLogin object:nil];
        
        // 跳转至首页 
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 不是200时，指出错误提示信息
        NSString *text = response[@"msg"];
        [UIHelper showTipsWithText:text inView:self.view];
    }
        
}

- (void)failureWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    [UIHelper showErrorWithText:@"网络异常，请稍后重试" inView:self.view];
}



@end
