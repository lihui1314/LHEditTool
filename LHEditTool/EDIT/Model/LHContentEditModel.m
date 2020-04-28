//
//  LHContentEditModel.m
//  LHEditeTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHContentEditModel.h"

@implementation LHContentEditModel
-(instancetype)init{
    self.cellHeight  =30;
    self.text= @"";
    return self;
}

-(CGFloat)lh_cellHeight{
    return _cellHeight;
}

-(NSString*)lh_cellReuseIdentifier{
    return @"LHContentEditeCell";
}
-(void)lh_setPath:(NSIndexPath *)path{
    self.path = path;
}
@end
