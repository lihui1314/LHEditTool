//
//  LHContentEditCell.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHContentEditCell.h"
#import "Masonry.h"
#import "UITableViewCell+LHCate.h"
#import "LHLabel.h"
#import "LHEditToolConfig.h"
@implementation LHContentEditCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self lh_addSubViews];
//        [self lh_setPlaceHolder];
    }
    return self;
}
-(void)lh_addSubViews{
    _contentTextView = [[LHTextView alloc]init];
    _contentTextView.scrollEnabled = NO;
    _contentTextView.font = [UIFont systemFontOfSize:[LHEditToolConfig shareInstance].textFontSize];
    _contentTextView.delegate = self;
    if ([LHEditToolConfig shareInstance].lineSpacing!=0) {
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc]init];
        sty.lineSpacing = [LHEditToolConfig shareInstance].lineSpacing;
        _contentTextView.typingAttributes =@{NSParagraphStyleAttributeName:sty,
                                             NSFontAttributeName:[UIFont systemFontOfSize:[LHEditToolConfig shareInstance].textFontSize],
                                             NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                             };
    }
    [self addSubview:_contentTextView];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
    }];
}
-(void)textViewDidChange:(UITextView *)textView{
    CGSize newSize = [textView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT)];
    //    CGRect newFrame = textView.frame;
    //    newFrame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, newSize.height);
    _model.text =textView.text;
    _model.cellHeight = newSize.height;
    if ((ABS(_contentTextView.frame.size.height - newSize.height))>5) {
        UITableView* containerTableView = [self containerTableView];
        [containerTableView beginUpdates];
        [self.contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@(_model.cellHeight));
        }];
        [containerTableView endUpdates];
        [self scrollToCursorForTextView:textView];
    }

}
//tableview滚动到可见位置。
-(void)scrollToCursorForTextView:(UITextView*)textView{
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    cursorRect.size.height+=15;
    cursorRect = [self.containerTableView convertRect:cursorRect fromView:textView];
    [self.containerTableView scrollRectToVisible:cursorRect animated:YES];
}

-(void)lh_setPlaceHolder:(NSString*)str{
    LHLabel*placeLab;
    for (LHLabel*lab in self.contentTextView.subviews) {
        if ([lab isKindOfClass:[LHLabel class]]) {
            placeLab = lab;
        }
    }
    [placeLab removeFromSuperview];
    LHLabel *placeHolderLabel_c = [[LHLabel alloc] init];
    placeHolderLabel_c.text = str;
    placeHolderLabel_c.numberOfLines = 0;
    placeHolderLabel_c.textColor = [UIColor lightGrayColor];
    [placeHolderLabel_c sizeToFit];
    placeHolderLabel_c.font = [UIFont systemFontOfSize:17];
    [_contentTextView addSubview:placeHolderLabel_c];
    [_contentTextView setValue:placeHolderLabel_c forKey:@"_placeholderLabel"];
}

-(void)lh_setData:(id)model indexPath:(NSIndexPath*)path andDelegate:(id)delegate{
    _delegate = delegate;
    self.model = model;
    _path = path;
    _model.path = path;
    if (path.row ==1&&[_contentTextView.text isEqualToString:@""]) {
        [self lh_setPlaceHolder:@"请输入内容"];
    }else{
        [self lh_setPlaceHolder:@""];
    }
    
}
-(void)setModel:(LHContentEditModel *)model{
    _model = model;
    self.contentTextView.text = model.text;
    [self.contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(_model.cellHeight));
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"%ld",textView.selectedRange.location);
    if ([self.delegate respondsToSelector:@selector(lh_shouldBeginEditingAtIndexPath:)]) {
        [self.delegate lh_shouldBeginEditingAtIndexPath:_model.path];
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_model.path.row==1 &&textView.text.length==0) {
        [self lh_setPlaceHolder:@"请输入内容"];
    }
    if ([text isEqualToString:@""]) {
        if (textView.text.length==0||textView.selectedRange.location==0) {
            if ([self.delegate respondsToSelector:@selector(lh_textCellDeleteAction:andTextView:)]) {
                [self.delegate lh_textCellDeleteAction:_model.path andTextView:textView];
                return YES;
            }
        }
    }
    return YES;
}
#pragma mark 拆分字符串
-(NSArray*)lh_separateText{//YES preOne
    if (self.contentTextView.selectedRange.location==0) {
        return @[@(YES)];
    }
    if (self.contentTextView.selectedRange.location == self.contentTextView.text.length) {
        return @[@(NO)];
    }
    NSRange seletedRange = self.contentTextView.selectedRange;
    NSMutableArray* sepreateArray = [NSMutableArray array];
    if (seletedRange.location>0) {
        [sepreateArray addObject:[self.contentTextView.text substringToIndex:seletedRange.location]];
    }
    
    if (seletedRange.location+seletedRange.length<self.contentTextView.text.length) {
        [sepreateArray addObject:[self.contentTextView.text substringWithRange:NSMakeRange(seletedRange.length+seletedRange.location, self.contentTextView.text.length-seletedRange.length-seletedRange.location)]];
    }
    /***去掉回车**/
    if (sepreateArray.count>1) {
        NSString*strLast = sepreateArray[1];
        NSString*strFirstChar = [strLast substringToIndex:1];
        if ([strFirstChar isEqualToString:@"\n"]) {
            NSString*lastFinalStr = [strLast substringFromIndex:1];
            sepreateArray[1] = lastFinalStr;
        }
        
    }
    /***********/
    return sepreateArray;
}
#pragma mark
-(void)lh_beginEditingWithStatePreOne:(BOOL)preOne andLoction:(NSInteger)loc{
    [self.contentTextView becomeFirstResponder];
    if (preOne) {
        NSInteger loction = (loc==0)? self.contentTextView.text.length:loc;
        self.contentTextView.selectedRange = NSMakeRange(loction, 0);
    }else{
        self.contentTextView.selectedRange = NSMakeRange(loc, 0);
    }
}

-(void)lh_didChangeTextFromImageCell:(UITextView*)textView{
    [self textViewDidChange:textView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
