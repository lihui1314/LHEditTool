//
//  LHTitleEditModel.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LHEditModelProtocol.h"
@interface LHTitleEditModel : NSObject<LHEditModelProtocol>
@property(nonatomic,strong)NSString*text;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,assign)BOOL beginEditing;
@end
