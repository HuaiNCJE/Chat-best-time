//
//  RegisterViewController.m
//  BestTime
//
//  Created by iPhone8s on 2017/5/26.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworkingHelper.h"
#import "URLMacro.h"
#import "VerifyHelper.h"
#import "UIHelper.h"


@interface RegisterViewController ()

// 输出口的数组
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *fields;

@end

@implementation RegisterViewController

// 触碰屏幕时，让键盘消失
- (IBAction)touched {
    [self.view endEditing:YES];
}

- (IBAction)registerButtonPressed:(id)sender {
    if ([self verify]) {
        [UIHelper showLoadingInView:self.view];
        
        NSString *username = [_fields[0] text];
        NSString *password = [_fields[1] text];
        NSDictionary *params = @{@"username": username ,@"password": password };
        
        AFNetworkingHelper *helper = [AFNetworkingHelper defaultHelper];
        [helper sendRequestWithURLString:kURLTypeRegister parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *response) {
            [UIHelper dismissLoadingInView:self.view];
            [self successWithTask:task response:response];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [UIHelper dismissLoadingInView:self.view];
            [self failureWithTask:task error:error];
            
        }];
        
            }
}


- (IBAction)textFieldDidEndOnExit:(UITextField *)field {
    // 获得当前输入框
    NSInteger index = [_fields indexOfObject:field];
    if (index < 2) {
        // 当前输入框失去焦点
        [field resignFirstResponder];
        // 下个输入框获得焦点
        [_fields[++index] becomeFirstResponder];
    } else {
        [field resignFirstResponder];
    }
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
    
    NSString *passwordAgain = [_fields[2] text];
    if ([VerifyHelper isEmptyString:passwordAgain]) {
        [UIHelper showTipsWithText:@"请再次输入密码" inView:self.view];
        return NO;
       
     }
    
    if (![password isEqualToString:passwordAgain]) {
        [UIHelper showTipsWithText:@"两次输入的密码不一致" inView:self.view];
        return NO;
      }
    
    return YES;
     
}

- (void)successWithTask:(NSURLSessionDataTask *)task response:(NSDictionary *)response {
    NSInteger code = [response[@"code"] integerValue];
    if (code == 200) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 提示失败原因
        NSString *text = response[@"msg"];
        [UIHelper showTipsWithText:text inView:self.view];
    }
}

- (void)failureWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    [UIHelper showErrorWithText:@"网络异常，请稍后重试" inView:self.view];
}





@end
