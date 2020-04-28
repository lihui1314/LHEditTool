//
//  UIImage+Edit.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "UIImage+Edit.h"
#define SidePadding 10
@implementation UIImage (Edit)

-(UIImage*)lh_edit{
    if (self.size.width>1080) {
        UIGraphicsBeginImageContext(CGSizeMake(self.size.width/4, self.size.height/4));
        [self drawInRect:CGRectMake(0, 0, self.size.width/4, self.size.height/4)];
        UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }else{
        return self;
    }
}
@end
