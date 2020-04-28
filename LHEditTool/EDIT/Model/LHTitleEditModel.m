//
//  LHTitleEditModel.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHTitleEditModel.h"

@implementation LHTitleEditModel
-(instancetype)init{
    self.cellHeight = 40;
    return self;
}
-(CGFloat)lh_cellHeight{
    return _cellHeight;
}
-(NSString*)lh_cellReuseIdentifier{
    return @"LHTitleEditeCell";
}

@end
