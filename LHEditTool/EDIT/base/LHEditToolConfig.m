//
//  LHEditToolConfig.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/28.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHEditToolConfig.h"
static LHEditToolConfig* config;
@implementation LHEditToolConfig
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[LHEditToolConfig alloc]init];
    });
    return config;
}
-(instancetype)init{
    _lineSpacing = 0;
    _titleFontSize = 20;
    _textFontSize = 17;
    return self;
}
@end
