//
//  LHEditAccessoryView.h
//  LHEditTool
//
//  Created by 李辉 on 2018/11/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,LHEditAccessoryType){
    LHEditAccessoryPackUpKeybordType =1,
    LHEditAccessoryPickImageType
};

@protocol LHEditAccessoryViewDelegate <NSObject>

-(void)lh_AccessoryAcWithType:(LHEditAccessoryType)type;

@end
@interface LHEditAccessoryView : UIView
@property(nonatomic,strong)UIButton*pickImgBtn;
@property(nonatomic,strong)UIButton*packUpKeybordBtn;
@property(nonatomic,weak)id<LHEditAccessoryViewDelegate>delegate;
@end
