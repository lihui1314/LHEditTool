//
//  LHTitleEditCell.h
//  LHEditeTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHTextView.h"
#import "LHTitleEditModel.h"
#import "LHEditCellProtocol.h"
#import "LHEditCellDelegate.h"
@interface LHTitleEditCell : UITableViewCell<UITextViewDelegate,LHEditCellProtocol>
@property(nonatomic,strong)LHTextView*titleTextView;
@property(nonatomic,strong)LHTitleEditModel*model;
@property(nonatomic,strong)NSIndexPath*path;
@property(nonatomic,weak)id<LHEditCellDelegate>delegate;
@end
