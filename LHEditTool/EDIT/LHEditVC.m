//
//  LHEditVC.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHEditVC.h"
#import "LHTitleEditCell.h"
#import "LHContentEditCell.h"
#import "LHTitleEditModel.h"
#import "LHContentEditModel.h"
#import "LHImageEditCell.h"
#import "LHImageEditModel.h"
#import "Masonry.h"
#import "UIImage+Edit.h"
#import "LHEditAccessoryView.h"
#import "NSString+LHCellHeight.h"
#define  ScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface LHEditVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LHEditCellDelegate,LHEditAccessoryViewDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)UIImagePickerController*imagePicker;
@property(nonatomic,strong)LHEditAccessoryView*accessoryView;
@property(nonatomic,strong)NSIndexPath * activEditingPath;
@property(nonatomic,assign)BOOL isDeletingImage; //是否正在删除图片。解决键盘上方View晃动问题。
@end

@implementation LHEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self lh_addNotefication];
    [self lh_loadData];
    [self lh_configTableView];
    self.imagePicker.delegate =self;
    self.imagePicker.allowsEditing=YES;
    [self lh_addaccessoryView];
    // Do any additional setup after loading the view from its nib.
}
-(void)lh_addNotefication{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)lh_loadData{
    _dataArray = [NSMutableArray array];
    LHTitleEditModel*modelT = [[LHTitleEditModel alloc]init];
    LHContentEditModel *modelC = [[LHContentEditModel alloc]init];
    [_dataArray addObject:modelT];
    [_dataArray addObject:modelC];
}
-(void)lh_configTableView{
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 70, 0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.right.equalTo(self.view);
        } else {
            make.top.left.bottom.right.equalTo(self.view);
            // Fallback on earlier versions
        }
    }];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [self.tableView registerClass:[LHTitleEditCell class] forCellReuseIdentifier:@"LHTitleEditeCell"];
    [self.tableView registerClass:[LHContentEditCell class] forCellReuseIdentifier:@"LHContentEditeCell"];
    [self.tableView registerClass:[LHImageEditCell class] forCellReuseIdentifier:@"LHImageEditCell"];
     
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<LHEditModelProtocol> model = _dataArray[indexPath.row];
    id<LHEditCellProtocol>cell = [tableView dequeueReusableCellWithIdentifier:[model lh_cellReuseIdentifier]];
    [(UITableViewCell*)cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    [cell lh_setData:model indexPath:indexPath andDelegate:self];
    return (UITableViewCell*)cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<LHEditModelProtocol> model = _dataArray[indexPath.row];
    NSLog(@"[model lh_cellHeight]->%f", [model lh_cellHeight]);
    return  [model lh_cellHeight];
}

-(void)lh_addaccessoryView{
    [self.view addSubview:self.accessoryView];
    [self.accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(ScreenHeight+30));
    }];
}
#pragma mark LHEditCellDelegate
-(void)lh_shouldBeginEditingAtIndexPath:(NSIndexPath *)path{
    if (path.row ==0) {
        _accessoryView.pickImgBtn.hidden = YES;
    }else{
        _accessoryView.pickImgBtn.hidden= NO;
        _activEditingPath = path;
    }
}
-(void)lh_imageCellDeleteAction:(NSIndexPath *)path{
    _isDeletingImage = YES;
    if (path.row>1) {
        if (_activEditingPath.row ==_dataArray.count-1) {
            [self.dataArray removeObjectAtIndex:path.row];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationFade)];
            [self.tableView endUpdates];
            NSIndexPath*newP = [NSIndexPath indexPathForRow:path.row-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:newP atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
            id<LHEditCellProtocol>cell = [self.tableView cellForRowAtIndexPath:newP];
            [cell lh_beginEditingWithStatePreOne:YES andLoction:0];
            _isDeletingImage = NO;
            return;
        }
        NSIndexPath*prePath = [NSIndexPath indexPathForRow:path.row-1 inSection:0];
        NSIndexPath*nextPath = [NSIndexPath indexPathForRow:path.row+1 inSection:0];
          id<LHEditCellProtocol>preModel = _dataArray[prePath.row];
           id<LHEditCellProtocol>nextModel = _dataArray[nextPath.row];
        if ([preModel isKindOfClass:[LHContentEditModel class]] && [nextModel isMemberOfClass:[LHContentEditModel class]]) {
            LHContentEditModel*pM = (LHContentEditModel*)preModel;
            LHContentEditModel*nM = (LHContentEditModel*)nextModel;
           LHContentEditModel*newModel = [[LHContentEditModel alloc]init];
           NSString* newText = [NSString stringWithFormat:@"%@\n%@",pM.text,nM.text];
            newModel.text = newText;
            newModel.cellHeight = newText.lh_TextViewHeight;
            [_dataArray removeObjectAtIndex:path.row];
            [_dataArray removeObject:preModel];
            [_dataArray removeObject:nextModel];
            [_dataArray insertObject:newModel atIndex:path.row-1];
            [self.tableView reloadData];
            id<LHEditCellProtocol>cell = [self.tableView cellForRowAtIndexPath:prePath];
            [cell lh_beginEditingWithStatePreOne:YES andLoction:pM.text.length];
            _isDeletingImage = NO;
        }else{
            [self.dataArray removeObjectAtIndex:path.row];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationFade)];
            [self.tableView endUpdates];
            NSIndexPath*newP = [NSIndexPath indexPathForRow:path.row-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:newP atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
                id<LHEditCellProtocol>cell = [self.tableView cellForRowAtIndexPath:newP];
            if (cell) {
                [cell lh_beginEditingWithStatePreOne:YES andLoction:0];
            }
            
            _isDeletingImage = NO;
            //更新剩余Model的indexPath
            for (int i = (int)newP.row; i<_dataArray.count; i++) {
                id<LHEditModelProtocol>model = _dataArray[i];
                NSIndexPath*updatePath = [NSIndexPath indexPathForRow:i inSection:0];
                [model lh_setPath:updatePath];
            }
        }
    }else{
        
        [self.dataArray removeObjectAtIndex:path.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationFade)];
        [self.tableView endUpdates];
        if (self.dataArray.count==1) {
            [self lh_insesrtATextCell:path andText:@""];
        }else{
            id<LHEditCellProtocol>cell = [self.tableView cellForRowAtIndexPath:path];
            id<LHEditModelProtocol>model = _dataArray[path.row];
            [model lh_setPath:path];
            [cell lh_beginEditingWithStatePreOne:NO andLoction:0];
        }
      _isDeletingImage = NO;
    }
  
//    id<LHEditCellProtocol>cell = [self.tableView cellForRowAtIndexPath:path];
}
-(void)lh_imageMoveCursorNextCell:(NSIndexPath *)path andText:(NSString *)text{
    
    NSIndexPath*newP = [NSIndexPath indexPathForRow:path.row+1 inSection:0];
    if (newP.row<self.dataArray.count) {
        id<LHEditModelProtocol>model = _dataArray[newP.row];
        if ([model isKindOfClass:[LHContentEditModel class]]) {
            [self.tableView scrollToRowAtIndexPath:newP atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
            LHContentEditCell* cell= [self.tableView cellForRowAtIndexPath:newP];
            LHContentEditModel*cModel = model;
            NSString*newText = [NSString stringWithFormat:@"%@%@",text,cModel.text];
            NSInteger len;
            if (newText.length==1) {
                newText = @"";
                len=0;
            }else{
                 len = ([text isEqualToString:@"\n"])?0:text.length;
            }
            cell.contentTextView.text = newText;
            [cell lh_didChangeTextFromImageCell:cell.contentTextView];
            [cell lh_beginEditingWithStatePreOne:NO andLoction:len];
        }else{
            if ([text isEqualToString:@"\n"]) {
                text=@"";
            }
            [self lh_insesrtATextCell:newP andText:text];
            for (NSInteger i = newP.row; i<_dataArray.count; i++) {
                id<LHEditModelProtocol>cellModel = _dataArray[i];
                [cellModel lh_setPath:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
        
    }else{
        if ([text isEqualToString:@"\n"]) {
            text=@"";
        }
        [self lh_insesrtATextCell:newP andText:text];
    }
}
//插入一个带textview的cell
-(void)lh_insesrtATextCell:(NSIndexPath*)path andText:(NSString*)text{
    LHContentEditModel*model = [[LHContentEditModel alloc]init];
    model.path = path;
    model.text = text;
    [self.dataArray insertObject:model atIndex:path.row];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationTop)];
    [self.tableView endUpdates];
          [self.tableView scrollToRowAtIndexPath:path atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
   
        LHContentEditCell*cell = [self.tableView cellForRowAtIndexPath:path];
        if (text.length>0) {
            [cell lh_didChangeTextFromImageCell:cell.contentTextView];
        }
         [cell lh_didChangeTextFromImageCell:cell.contentTextView];
       [cell lh_beginEditingWithStatePreOne:NO andLoction:text.length];
   
}

-(void)lh_textCellDeleteAction:(NSIndexPath *)path andTextView:(UITextView *)textView{
    if (path.row>1) {
        if (textView.text.length ==0) {
            _isDeletingImage=YES;
            NSIndexPath *newP = [NSIndexPath indexPathForRow:path.row-1 inSection:0];
            id<LHEditCellProtocol>cell = [self.tableView cellForRowAtIndexPath:newP];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [cell lh_beginEditingWithStatePreOne:YES andLoction:0];
                _isDeletingImage = NO;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.dataArray removeObjectAtIndex:path.row];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
                [self.tableView endUpdates];
            });
            
            for (int i = (int)newP.row; i<_dataArray.count; i++) {
                id<LHEditModelProtocol>model = _dataArray[i];
                NSIndexPath*updatePath = [NSIndexPath indexPathForRow:i inSection:0];
                [model lh_setPath:updatePath];
            }
        }else{
            _isDeletingImage = YES;
            NSIndexPath *newP = [NSIndexPath indexPathForRow:path.row-1 inSection:0];
            id<LHEditCellProtocol>cell = [self.tableView cellForRowAtIndexPath:newP];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [cell lh_beginEditingWithStatePreOne:YES andLoction:0];
                _isDeletingImage = NO;
            });
        }
    }
}

#pragma  mark keybord
//键盘变化
-(void)keybordWillShow:(NSNotification*)noti{
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSTimeInterval keyboardAnimTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGFloat keyBordHeight =ScreenHeight - keyboardFrame.origin.y;
    if (keyBordHeight>50) {//键盘为弹出状态
        [UIView animateWithDuration:keyboardAnimTime animations:^{
             self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 70, 0);
            [self.accessoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.height.equalTo(@(50));
                make.bottom.equalTo(self.view).offset(-keyBordHeight);
            }];
             [self.view layoutIfNeeded];
        }];
        
    }
    [UIView animateWithDuration:keyboardAnimTime animations:^{
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuide).offset(-keyBordHeight);
            } else {
                make.top.right.left.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-keyBordHeight);
                // Fallback on earlier versions
            }
    
        }];
         [self.view layoutIfNeeded];
    }];
   
    
}
-(void)keybordWillHidden:(NSNotification*)noti{
    if (_isDeletingImage) {
        return;
    }
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSTimeInterval keyboardAnimTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGFloat keyBordHeight =ScreenHeight - keyboardFrame.origin.y;
    [UIView animateWithDuration:keyboardAnimTime animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 50, 0);
        [self.accessoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(50));
            make.bottom.equalTo(self.view).offset(50);
        }];
        [self.view layoutIfNeeded];
    }];
    [UIView animateWithDuration:keyboardAnimTime animations:^{
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuide).offset(-keyBordHeight);
            } else {
                make.top.right.left.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-keyBordHeight);
                // Fallback on earlier versions
            }
            
        }];
        [self.view layoutIfNeeded];
    }];
}
-(LHEditAccessoryView*)accessoryView{
    if (_accessoryView==nil && _insertImageEnabled) {
        _accessoryView = [[LHEditAccessoryView alloc]init];
        _accessoryView.delegate = self;
    }
    return _accessoryView;
}
#pragma  mark - LHEditAccessoryViewDelegate
-(void)lh_AccessoryAcWithType:(LHEditAccessoryType)type{
    switch (type) {
        case LHEditAccessoryPickImageType:
            [self lh_pickImage];
            break;
        case LHEditAccessoryPackUpKeybordType:
            [self.view endEditing:YES];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImagePickerController*)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
-(void)lh_pickImage{
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self.imagePicker setAllowsEditing:NO];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage*newImage = image.lh_edit;
    LHImageEditModel*model = [[LHImageEditModel alloc]init];
    model.image = newImage;
    model.cellHeight = newImage.size.height*(([UIScreen mainScreen].bounds.size.width-20)/newImage.size.width)+5+5;
   
    [self lh_addImageModel:model];
    //    获取图片后返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)lh_addImageModel:(LHImageEditModel*)model{
    NSIndexPath *signPath;//标记光标需要指定的path
    id mod = _dataArray[_activEditingPath.row];
    if ([mod isKindOfClass:[LHImageEditModel class]]) {
        [self insertimageInLastLoc:model];
        signPath = [NSIndexPath indexPathForRow:_activEditingPath.row+2 inSection:0];
        
    }else{
    id<LHEditCellProtocol>cell = [self.tableView cellForRowAtIndexPath:_activEditingPath];
    NSArray*arr = [cell lh_separateText];
    if (arr.count==1) {
        BOOL insertPre = [arr[0] boolValue];
        if (insertPre) {
            [_dataArray insertObject:model atIndex:_activEditingPath.row];
            signPath = [NSIndexPath indexPathForRow:_activEditingPath.row+1 inSection:0];
        }else{
            [self insertimageInLastLoc:model];
            signPath = [NSIndexPath indexPathForRow:_activEditingPath.row+2 inSection:0];
        }
    }else{
        [self.dataArray removeObjectAtIndex:_activEditingPath.row];
        if (_activEditingPath.row>=1) {
            id<LHEditCellProtocol>preModel = self.dataArray[_activEditingPath.row-1];
            if ([preModel isKindOfClass:[LHContentEditModel class]]) {
                LHContentEditModel*newPreModel = (LHContentEditModel*)preModel;
                NSString*newT = [NSString stringWithFormat:@"%@%@",newPreModel.text,arr[0]];
                newPreModel.text = newT;
                newPreModel.cellHeight = newT.lh_TextViewHeight;
                [self.dataArray insertObject:model atIndex:_activEditingPath.row];
                LHContentEditModel*modelBot = [[LHContentEditModel alloc]init];
                modelBot.text = arr[1];
                modelBot.cellHeight = modelBot.text.lh_TextViewHeight;
                [self.dataArray insertObject:modelBot atIndex:_activEditingPath.row+1];
                signPath = [NSIndexPath indexPathForRow:_activEditingPath.row+1 inSection:0];
            }else{
                LHContentEditModel*modelTop = [[LHContentEditModel alloc]init];
                LHContentEditModel*modelBot = [[LHContentEditModel alloc]init];
                modelTop.text = arr[0];
                modelTop.cellHeight = modelTop.text.lh_TextViewHeight;
                modelBot.text = arr[1];
                modelBot.cellHeight = modelBot.text.lh_TextViewHeight;
                [_dataArray insertObject:modelTop atIndex:_activEditingPath.row];
                [_dataArray insertObject:model atIndex:_activEditingPath.row+1];
                [_dataArray insertObject:modelBot atIndex:_activEditingPath.row+2];
                signPath = [NSIndexPath indexPathForRow:_activEditingPath.row+2 inSection:0];
            }
        }
    }
    }
    [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:signPath atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
        id<LHEditCellProtocol>focsCell = [self.tableView cellForRowAtIndexPath:signPath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [focsCell lh_beginEditingWithStatePreOne:NO andLoction:0];
        });
   
}
//编辑状态是最后一个cell的情况下。插入image
-(void)insertimageInLastLoc:(LHImageEditModel*)model{
    if (_activEditingPath.row == _dataArray.count-1 && _dataArray.count>=2) {
        LHContentEditModel*contentModel = [[LHContentEditModel alloc]init];
        [_dataArray insertObject:model atIndex:_activEditingPath.row+1];
        [_dataArray insertObject:contentModel atIndex:_activEditingPath.row+2];
    }else{
        [_dataArray insertObject:model atIndex:_activEditingPath.row+1];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(UITableView*)tableView{
    if (!_tableView) {
         _tableView = [UITableView new];
         _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
         _tableView.delegate = self;
         _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark 数据处理区
-(NSMutableArray*)lh_getDataArray{
    return _dataArray;
}

-(void)lh_setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
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
