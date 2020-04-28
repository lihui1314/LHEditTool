//
//  LHSubEditVC.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/25.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHSubEditVC.h"
#import "LHEditToolConfig.h"
@interface LHSubEditVC ()

@end

@implementation LHSubEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [LHEditToolConfig shareInstance].lineSpacing = 6;
    self.insertImageEnabled = YES;
    self.title = @"LHEditTool";
    
    [self lh_addItems];
}

-(void)lh_addItems{
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)leftItemAction{
    
    
}
-(void)rightItemAction{
    NSMutableArray *marr =  self.lh_getDataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
