//
//  LHEditImageModel.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LHEditModelProtocol.h"
@interface LHImageEditModel : NSObject<LHEditModelProtocol>
@property(nonatomic,strong)NSString*imageUrl;
@property(nonatomic,strong)UIImage*image;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong)NSMutableAttributedString*imageAttriStr;

@property(nonatomic,strong)NSIndexPath*path;
@end
