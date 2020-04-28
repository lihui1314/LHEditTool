//
//  LHEditVC.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHEditVC : UIViewController

///获取编辑数据
-(NSMutableArray*)lh_getDataArray;
-(void)lh_setDataArray:(NSMutableArray*)dataArray;
@property(nonatomic,assign)BOOL insertImageEnabled;
@end
