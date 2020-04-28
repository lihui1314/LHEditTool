//
//  LHEditImageModel.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHImageEditModel.h"
#define Padding 10
@implementation LHImageEditModel

-(CGFloat)lh_cellHeight{
    return _cellHeight;
}

-(NSString*)lh_cellReuseIdentifier{
    return @"LHImageEditCell";
}
-(NSMutableAttributedString*)imageAttriStr{
    if (!_imageAttriStr) {
        NSTextAttachment*attachment = [[NSTextAttachment alloc]init];
        attachment.image = [UIImage new];
        attachment.bounds =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.cellHeight);
        NSAttributedString*att = [NSAttributedString attributedStringWithAttachment:attachment];
        NSMutableAttributedString*attStr = [[NSMutableAttributedString alloc]initWithString:@""];
        [attStr insertAttributedString:att atIndex:0];
        _imageAttriStr = attStr;
        
    }
    return _imageAttriStr;
}
-(void)lh_setPath:(NSIndexPath *)path{
    self.path = path;
}
@end
