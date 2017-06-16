//
//  EditViewController.m
//  BestTime
//
//  Created by iPhone8s on 2017/6/7.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "EditViewController.h"

#import "UserInfo.h"
#import "ConversionHelper.h"
#import "UIHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VerifyHelper.h"
#import "User.h"
#import "AFNetworkingHelper.h"
#import "URLMacro.h"
#import "UINavigationController+Passable.h"
#import "UtilsMacro.h"

@interface EditViewController () <UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, strong) UserInfo *object;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *fields;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView.userInteractionEnabled = YES;
    
    // 视图载入时 调整多行textView上下左右的间距
    _textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0);
}

// 视图将要显示时注册通知
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotification];
}

// 视图将要消失时取消通知
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unregisterNotification];
}

// 从其他页面传入数据 进行数据转换
- (void)viewControllerDidShowWithTag:(NSString *)tag data:(NSObject *)data {
    //
    NSDictionary *entries = (NSDictionary *)data;
    self.object = entries[@"object"];
    _imageView.image = entries[@"head"];
    
    // 重新载入 刷新
    [self reload:_object];
}

- (IBAction)headTapped {
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self openCamera];
    }];
    
    [sheet addAction:cameraAction];
    
    //
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self openPhotoLibrary];
    }];
    
    [sheet addAction:photoAction];
    
    //
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil ];
    
    [sheet addAction:cancelAction];
    
    // 呈现ViewController方法 显示操作表
    [self presentViewController:sheet animated:YES completion:nil];
    
}

// 点击按钮 提交数据
- (IBAction)saveButtonPressed {
    NSString *text = [_fields[0] text];
    // 只验证昵称
    if ([VerifyHelper isEmptyString:text]) {
        [UIHelper showTipsWithText:@"昵称不能为空" inView:self.view];
        return;
    }
    
    [UIHelper showLoadingInView:self.view];
    //headIMG
    if (_headImage != nil) {
        // 获取当前用户
        User *user = [User currentUser];
        NSString *filename = [NSString stringWithFormat:@"%@.jpg", user.username];
        // 拼接
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kURLTypeFileUploadPrefix,filename];
         // 转换数据
        NSData *data = UIImageJPEGRepresentation(_headImage, 1.0);
        
        AFNetworkingHelper *helper = [AFNetworkingHelper defaultHelper];
        [helper uploadWithURLString:urlString data:data success:^(NSURLResponse *response ,id object) {
            NSString *photo = object[@"url"];
            if (photo != nil) {
                // 图片下载地址
                NSString *urlString = [kURLTypeFileDownloadPrefix stringByAppendingString:photo];
                // 提交数据
                [self commitWithPhotoURLString:urlString];
            } else {
                [self commitWithPhotoURLString:nil];
            }
        } failure:^(NSURLResponse *response, NSError *error){
            // 失败 取消动画
            [UIHelper dismissLoadingInView:self.view];
            // 简单提示 失败原因
            [UIHelper showErrorWithText:@"网络，请稍后再试" inView:self.view];
        }];
    
        
    } else {
        [self commitWithPhotoURLString:nil];
    }
    
}

// 点击下一步 让光标向下移动
- (IBAction)textFieldDidEndOnExit:(UITextField *)field {
    // 获取当前输入框
    NSInteger index = [_fields indexOfObject:field];
    if (index < _fields.count - 1) {
        UITextField *nextField = _fields[index + 1];
        // 获取焦点
        [nextField becomeFirstResponder];
    } else {
        [_textView becomeFirstResponder];
    }
}

#pragma mark - UIScrollViewDelegate

 //向上拖动时 使控件失去焦点 让键盘消失
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
// 按钮retuen key 操作的方式方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 回车
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *type = info[UIImagePickerControllerMediaType];
    if ([type isEqual:(NSString *)kUTTypeImage]) {
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];
        // 压缩处理图片 并指定尺寸大小
        self.headImage = [self shrinkImage:editedImage size:CGSizeMake(100, 100)];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_headImage != nil) {
            _imageView.image = _headImage;
        }
    }];
}

// 未选图片时
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)registerNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)unregisterNotification {
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

// 键盘显示 布局方法
- (void) keyboardWillShow:(NSNotification *)sender {
    NSDictionary *info = sender.userInfo;
    // 获得键盘尺寸
    CGRect bounds = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘弹出动画时间
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 获得当前的输入框
    UIView *inputField = [self firstResponder];
    // 获得输入框坐标位置
    CGRect rect = [inputField convertRect:inputField.bounds toView:_scrollView];
    //
    rect.origin.y += 8;
    
    // 动画效果
    void(^animations) (void) = ^ {
        //
        UIEdgeInsets insets = _scrollView.contentInset;
        insets.bottom = bounds.size.height;
        _scrollView.contentInset = insets;
        
        // 显示动画效果 遮挡时 输入框向上移动
        [_scrollView scrollRectToVisible:rect animated:NO];
        
    };
    
    if (duration > 0) {
        NSInteger value = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        UIViewAnimationOptions options = (value << 16);
        // 让输入框弹起时间与键盘弹起时间一致
        [UIView animateWithDuration:duration delay:0 options:options animations:animations completion:nil];
    } else {
        animations();
    }
}

// 键盘隐藏 布局方法
- (void)keyboardWillHide:(NSNotification *)sender {
    // 获取动画时间
    NSDictionary *info = sender.userInfo;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 构造动画效果
    void(^animations) (void) = ^ {
        //键盘隐藏
        UIEdgeInsets insets = _scrollView.contentInset;
        // 重新将下边边距置为0
        insets.bottom = 0;
        _scrollView.contentInset = insets;
        
        // 回到初始状态
        _scrollView.contentOffset = CGPointMake(0,0);
    };
    
    if (duration > 0) {
        NSInteger value = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        UIViewAnimationOptions options = (value << 16);
        [UIView animateWithDuration:duration delay:0 options:options animations:animations completion:nil];
    } else {
        animations();
    }
}

// 刷新
- (void)reload:(UserInfo *)object {
    NSString *nickname = [ConversionHelper stringWithString:object.nickname defaultValue:@""];
    NSString *sex = [ConversionHelper stringWithString:object.sex defaultValue:@""];
    NSString *record = [ConversionHelper stringWithString:object.record defaultValue:@""];
    NSString *marital = [ConversionHelper stringWithString:object.marital defaultValue:@""];
    NSString *address = [ConversionHelper stringWithString:object.address defaultValue:@""];
    NSString *contact = [ConversionHelper stringWithString:object.contact defaultValue:@""];
    NSString *introduce = [ConversionHelper stringWithString:object.introduce defaultValue:@""];
    
    [_fields[0] setText:nickname];
    [_fields[1] setText:sex];
    [_fields[2] setText:record];
    [_fields[3] setText:object.salary];
    [_fields[4] setText:object.age];
    [_fields[5] setText:object.height];
    [_fields[6] setText:marital];
    [_fields[7] setText:address];
    [_fields[8] setText:contact];
    [_textView setText:introduce];
    
}

// 寻找输入框的第一响应者
- (UIView *)firstResponder {
    if ([_textView isFirstResponder]) {
        return _textView;
    } else {
        for (UITextField *field in _fields) {
            if ([field isFirstResponder]) {
                return field;
            }
        }
    }
    return  nil;
}

// 调用打开相机方法
- (void)openCamera {
    [self getMediaFromSourceWithType:UIImagePickerControllerSourceTypeCamera];
}

// 打开相册方法
- (void)openPhotoLibrary {
    [self getMediaFromSourceWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)getMediaFromSourceWithType:(UIImagePickerControllerSourceType)type {
    // 拿出当前可用的资源类型
    NSArray *types = [UIImagePickerController availableMediaTypesForSourceType:type];
    //  指定资源类型是否可用
    if ([UIImagePickerController isSourceTypeAvailable:type] && types.count >0){ UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = types;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        NSString *text;
        
        if (type == UIImagePickerControllerSourceTypeCamera) {
            text = @"拍照功能不可用";
        } else {
            text = @"相册不可以访问";
        }
        
        [UIHelper showTipsWithText:text inView:self.view];
    }
}

// 压缩图片处理
-  (UIImage *)shrinkImage:(UIImage *)original size:(CGSize)size {
    // 获得当前屏幕倍数
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    uint32_t info = kCGImageAlphaPremultipliedFirst;
    //4*width*2  整数倍数每像素的字节数  至少要“宽*字节每个像素的字节  创建位图
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 4*width*2, colorSpace, info);
    CGRect rect = CGRectMake(0,0,width,height);
    CGContextDrawImage(context, rect, original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *finalImage = [UIImage imageWithCGImage:shrunken];
    
    // 释放相关资源
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(shrunken);
    
    return finalImage;

}

// 提交数据
- (void)commitWithPhotoURLString:(NSString *)urlString {
    // 构造字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    // 设置头像
    if (urlString != nil) {
        params[@"photo"] = urlString;
    }
    
    params[@"objectId"] = _object.objectId;
    params[@"nickname"] = [_fields[0] text];
    params[@"sex"] = [_fields[1] text];
    params[@"record"] = [_fields[2] text];
    
    int number = [[_fields[3] text] intValue];
    NSLog(@"number:%d",number);
    if (number > 0) {
        params[@"salary"] = [NSNumber numberWithInt:number];
        
    }
    
     number = [[_fields[4] text] intValue];
    if (number > 0) {
        params[@"age"] = [NSNumber numberWithInt:number];
        
    }
    
    number = [[_fields[5] text] intValue];
    if (number > 0) {
        params[@"height"] = [NSNumber numberWithInt:number];
        
    }
    
    params[@"marital"] =  [_fields[6] text];
    params[@"address"] =  [_fields[7] text];
    params[@"contact"] =  [_fields[8] text];
    params[@"introduce"] =  [_textView text];
    
    AFNetworkingHelper *helper = [AFNetworkingHelper defaultHelper];
    [helper sendRequestWithURLString:kURLTypePublish parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        [UIHelper dismissLoadingInView:self.view];
        NSInteger code = [response[@"code"] integerValue];
        NSLog(@"code:%ld",(long)code);
        if (code == 200) {
            //
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:kNofiticationTypeReset object:nil];
            
            //
            NSDictionary *data = @{@"isMe": @YES, @"objectId":_object.objectId};
            [self.navigationController popViewControllerAnimated:YES data:data];
        } else {
            [UIHelper showErrorWithText:response[@"msg"] inView:self.view];
        }
        
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@",error);
        [UIHelper dismissLoadingInView:self.view];
//        [UIHelper showErrorWithText:@"msg" inView:self.view];
        [UIHelper showErrorWithText:@"网络异常，请稍后重试" inView:self.view];
    }];


}
@end
