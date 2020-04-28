//
//  LHImageEditCell.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHTextView.h"
#import "LHEditCellProtocol.h"
#import "LHImageEditModel.h"
#import "LHEditCellDelegate.h"
@interface LHImageEditCell : UITableViewCell<LHEditCellProtocol,UITextViewDelegate>
@property(nonatomic,strong)UIImageView*imV;
@property(nonatomic,strong)LHTextView*imageTextV;
@property(nonatomic,strong)LHImageEditModel*model;
@property(nonatomic,strong)NSIndexPath*path;

@property(nonatomic,weak)id<LHEditCellDelegate>delegate;

@end
