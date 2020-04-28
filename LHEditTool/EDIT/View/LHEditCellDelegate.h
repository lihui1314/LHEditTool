//
//  LHEditCellDelegate.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/18.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHEditCellDelegate <NSObject>
-(void)lh_shouldBeginEditingAtIndexPath:(NSIndexPath*)path;
@optional
-(void)lh_imageCellDeleteAction:(NSIndexPath*)path;//图片删除;
-(void)lh_imageMoveCursorNextCell:(NSIndexPath*)path andText:(NSString*)text;//光标移动到下一个textview

-(void)lh_textCellDeleteAction:(NSIndexPath*)path andTextView:(UITextView*)textView; //textV删除
@end
