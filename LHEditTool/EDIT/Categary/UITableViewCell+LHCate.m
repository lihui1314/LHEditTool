//
//  UITableViewCell+LHCate.m
//  LHEditeTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "UITableViewCell+LHCate.h"

@implementation UITableViewCell (LHCate)

- (UITableView*)containerTableView {
    UITableView* containerTableView = (UITableView*)self.superview;
    while (containerTableView != nil && ![containerTableView isKindOfClass:[UITableView class]]) {
        containerTableView = (UITableView*)containerTableView.superview;
    }
    return containerTableView;
}

@end
