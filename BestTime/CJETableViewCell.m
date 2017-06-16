//
//  CJETableViewCell.m
//  BestTime
//
//  Created by iPhone8s on 2017/6/13.
//  Copyright © 2017年 iPhone8s. All rights reserved.
//

#import "CJETableViewCell.h"

#import <UIView+SDAutoLayout.h>
#import <UITableView+SDAutoTableViewCellHeight.h>


@implementation CJETableViewCell

{
    UIImageView *_view0;
    UILabel *_view1;
    UILabel *_view2;
    UIImageView *_view3;
    UILabel *_view4;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *view0 = [UIImageView new];
    view0.backgroundColor = [UIColor redColor];
    _view0 = view0;
    
    UILabel *view1 = [UILabel new];
    view1.textColor = [UIColor lightGrayColor];
    view1.font = [UIFont systemFontOfSize:16];
    _view1 = view1;
    
    UILabel *view2 = [UILabel new];
    view2.textColor = [UIColor grayColor];
    view2.font = [UIFont systemFontOfSize:16];
    view2.numberOfLines = 0;
    _view2 = view2;
    
    UIImageView *view3 = [UIImageView new];
    view3.backgroundColor = [UIColor orangeColor];
    _view3 = view3;
    
    UILabel *view4 = [UILabel new];
    view4.textColor = [UIColor whiteColor];
    view4.backgroundColor = [UIColor lightGrayColor];
    view4.text = @"纯文本";
    view4.font = [UIFont systemFontOfSize:13];
    _view4 = view4;
    
    [self.contentView sd_addSubviews:@[view4,view3,view2,view1,view0]];
    
    _view0.sd_layout
    .widthIs(40)
    .heightIs(40)
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView,10);
    
    _view1.sd_layout
    .topEqualToView(_view0)
    .leftSpaceToView(_view0, 10)
    .heightRatioToView(_view0, 0.4);
    
    _view2.sd_layout
    .topSpaceToView(_view1, 10)
    .rightSpaceToView(self.contentView,10)
    .leftEqualToView(_view1)
    .autoHeightRatio(0);
    
    _view3.sd_layout
    .topSpaceToView(_view2, 10)
    .leftEqualToView(_view2)
    .widthRatioToView(_view2, 0.7);
    
    _view4.sd_layout
    .leftSpaceToView(_view1, 5)
    .centerYEqualToView(_view1)
    .heightIs(14);
    
    // 设置最大宽度
    [_view4 setSingleLineAutoResizeWithMaxWidth:50];
    
    // 设置圆角
    _view0.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    [_view1 setSingleLineAutoResizeWithMaxWidth:200];
    
    
    
}

- (void)setModel:(CJEModel *)model {
    _model = model;
    
    _view0.image = [UIImage imageNamed:model.iconName];
    
    _view1.text = model.name;
    
    _view2.text = model.content;
    
    CGFloat bottomMargin = 0;
    
    // 在实际的开发中， 网络图片的宽高应由图片服务器返回然后计算宽高比
    
    UIImage *piç = [UIImage imageNamed:model.picName];
    if (piç.size.width > 0) {
        CGFloat scale = piç.size.height / piç.size.width;
        _view3.sd_layout.autoHeightRatio(scale);
        _view3.image = piç;
        bottomMargin = 10;
        _view4.hidden = YES;
        
    } else {
        _view3.sd_layout.autoHeightRatio(0);
        _view4.hidden = NO;
    }
    //***********************高度自适应cell设置步骤************************
    
    [self setupAutoHeightWithBottomView:_view3 bottomMargin:bottomMargin];
}

@end
