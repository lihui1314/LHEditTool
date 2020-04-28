//
//  LHEditToolConfig.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/28.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LHEditToolConfig : NSObject
@property(nonatomic,assign)CGFloat lineSpacing;
@property(nonatomic,assign)CGFloat titleFontSize;
@property(nonatomic,assign)CGFloat textFontSize;
+(instancetype)shareInstance;
@end
