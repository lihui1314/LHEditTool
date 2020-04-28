//
//  LHEditAccessoryView.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHEditAccessoryView.h"
#import "Masonry.h"
@implementation LHEditAccessoryView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self lh_addAllSubviews];
    }
    return self;
}
-(void)lh_addAllSubviews{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pickImgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_pickImgBtn addTarget:self action:@selector(picImageAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_pickImgBtn setImage:[UIImage imageNamed:@"pickImage"] forState:(UIControlStateNormal)];
    _packUpKeybordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_packUpKeybordBtn setImage:[UIImage imageNamed:@"keybordff"] forState:(UIControlStateNormal)];
    [_packUpKeybordBtn addTarget:self action:@selector(packUpKeybordBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_pickImgBtn];
    [self addSubview:_packUpKeybordBtn];
    [_pickImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@(30));
    }];
    [_packUpKeybordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@(30));
        make.width.equalTo(@(30));
    }];
    
}
-(void)picImageAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(lh_AccessoryAcWithType:)]) {
        [self.delegate lh_AccessoryAcWithType:LHEditAccessoryPickImageType];
    }
}
-(void)packUpKeybordBtnAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(lh_AccessoryAcWithType:)]) {
        [self.delegate lh_AccessoryAcWithType:(LHEditAccessoryPackUpKeybordType)];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
