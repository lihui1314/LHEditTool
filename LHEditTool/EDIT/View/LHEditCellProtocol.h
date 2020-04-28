//
//  LHEditCellProtocol.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHEditCellProtocol <NSObject>
-(void)lh_setData:(id)model indexPath:(NSIndexPath*)path andDelegate:(id)delegate;
@optional
-(NSArray*)lh_separateText;//拆分字符串
-(void)lh_beginEditingWithStatePreOne:(BOOL)preOne andLoction:(NSInteger)loc;
@end
