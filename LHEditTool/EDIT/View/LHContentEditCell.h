//
//  LHContentEditCell.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHContentEditModel.h"
#import "LHTextView.h"
#import "LHEditCellProtocol.h"
#import "LHEditCellDelegate.h"

@interface LHContentEditCell : UITableViewCell<UITextViewDelegate,LHEditCellProtocol>
@property(nonatomic,strong)LHContentEditModel*model;
@property(nonatomic,strong)LHTextView *contentTextView;
@property(nonatomic,strong)NSIndexPath*path;

@property(nonatomic,weak)id<LHEditCellDelegate>delegate;

-(void)lh_didChangeTextFromImageCell:(UITextView*)textView;//来自ImageCell的换行；
@end
