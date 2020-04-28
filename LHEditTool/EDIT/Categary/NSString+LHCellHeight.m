//
//  NSString+LHCellHeight.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/18.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "NSString+LHCellHeight.h"
#import "LHEditToolConfig.h"
@implementation NSString (LHCellHeight)
-(CGFloat)lh_TextViewHeight{
    UITextView*textView = [[UITextView alloc]init];
    
    textView.font = [UIFont systemFontOfSize:[LHEditToolConfig shareInstance].textFontSize];
    textView.scrollEnabled = NO;
    textView.frame = CGRectMake(0,0 , [UIScreen mainScreen].bounds.size.width-20, 100000);
    if ([LHEditToolConfig shareInstance].lineSpacing!=0) {
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc]init];
        sty.lineSpacing =[LHEditToolConfig shareInstance].lineSpacing;
        textView.typingAttributes =@{NSParagraphStyleAttributeName:sty,
                                     NSFontAttributeName:[UIFont systemFontOfSize:[LHEditToolConfig shareInstance].textFontSize],
                                     NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                     };
    }
    textView.text = self;
    CGSize newSize = [textView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT)];
    return newSize.height;
}

-(CGFloat)lh_titleTextViewHeight{
    UITextView*textView = [[UITextView alloc]init];
    textView.font = [UIFont systemFontOfSize:[LHEditToolConfig shareInstance].titleFontSize];
    textView.scrollEnabled = NO;
    textView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, 10000);
    if ([LHEditToolConfig shareInstance].lineSpacing!=0) {
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc]init];
        sty.lineSpacing = [LHEditToolConfig shareInstance].lineSpacing;
        textView.typingAttributes =@{NSParagraphStyleAttributeName:sty,
                                     NSFontAttributeName:[UIFont systemFontOfSize:[LHEditToolConfig shareInstance].titleFontSize],
                                     NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                     };
    }
    textView.text = self;
    CGSize newSize = [textView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT)];
    return newSize.height;
}
@end
