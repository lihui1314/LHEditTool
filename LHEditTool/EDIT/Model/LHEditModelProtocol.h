//
//  LHEditModelProtocol.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol LHEditModelProtocol <NSObject>
-(CGFloat)lh_cellHeight;
-(NSString*)lh_cellReuseIdentifier;
@optional
-(void)lh_setPath:(NSIndexPath*)path;
@end
