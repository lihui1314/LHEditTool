//
//  LHTitleEditeCell.m
//  LHEditeTool
//
//  Created by 李辉 on 2018/11/13.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHTitleEditCell.h"
#import "Masonry.h"
#import "UITableViewCell+LHCate.h"
#import "LHEditToolConfig.h"
@implementation LHTitleEditCell{
    UIImageView*_segmentationImv;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self lh_addSubVies];
        [self lh_setPlaceHolder];
    }
    return self;
}

-(void)lh_addSubVies{
    _titleTextView = [[LHTextView alloc]init];
    _titleTextView.scrollEnabled=NO;
    _titleTextView.delegate = self;
    _titleTextView.font = [UIFont systemFontOfSize:[LHEditToolConfig shareInstance].titleFontSize];
    _titleTextView.textColor = [UIColor darkGrayColor];
    _titleTextView.backgroundColor = [UIColor whiteColor];
    if ([LHEditToolConfig shareInstance].lineSpacing!=0) {
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc]init];
        sty.lineSpacing = [LHEditToolConfig shareInstance].lineSpacing;
        _titleTextView.typingAttributes =@{NSParagraphStyleAttributeName:sty,
                                           NSFontAttributeName:[UIFont systemFontOfSize:[LHEditToolConfig shareInstance].titleFontSize],
                                           NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                           };
    }
    _segmentationImv = [[UIImageView alloc]initWithImage:[self imageWithLineWithImageView:_segmentationImv]];
//    _segmentationImv.backgroundColor = [UIColor lightGrayColor];
   
    [self addSubview:_titleTextView];
    [self addSubview:_segmentationImv];
    [_titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self);
        make.bottom.equalTo(self).priority(900);
    }];
    [_segmentationImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-1);
        make.height.equalTo(@(1));
    }];
  
}
-(void)lh_sp{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         _segmentationImv.image = [self imageWithLineWithImageView:_segmentationImv];
    });
}

//画虚线
-(UIImage*)imageWithLineWithImageView:(UIImageView *)imageView{
//    CGFloat width = imageView.frame.size.width;
    CGFloat width = [UIScreen mainScreen].bounds.size.width-20;
    //    CGFloat height = imageView.frame.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(width, 1));
    //    [imageView.image drawInRect:CGRectMake(0, 0, width, height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGFloat lengths[] = {6,4};//虚线的长度设置
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0].CGColor);
    //画线
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0, 1);
    CGContextAddLineToPoint(line, width, 1);
    CGContextStrokePath(line);
    return UIGraphicsGetImageFromCurrentImageContext();
    
}

-(void)lh_setPlaceHolder{
    UILabel *placeHolderLabel_c = [[UILabel alloc] init];
    placeHolderLabel_c.text = @"请输入标题";
    placeHolderLabel_c.numberOfLines = 0;
    placeHolderLabel_c.textColor = [UIColor lightGrayColor];
    [placeHolderLabel_c sizeToFit];
    placeHolderLabel_c.font = [UIFont systemFontOfSize:20];
    [_titleTextView addSubview:placeHolderLabel_c];
    [_titleTextView setValue:placeHolderLabel_c forKey:@"_placeholderLabel"];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }else{
        return YES;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    CGSize newSize = [textView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, newSize.height);
    _model.text =textView.text;
    _model.cellHeight = newSize.height;
    UITableView* containerTableView = [self containerTableView];
    [containerTableView beginUpdates];
    [containerTableView endUpdates];
}

-(void)lh_setData:(id)model indexPath:(NSIndexPath*)path andDelegate:(id)delegate{
    _delegate =delegate;
    _model = model;
    _path =path;
    _titleTextView.text = _model.text;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(lh_shouldBeginEditingAtIndexPath:)]) {
        [self.delegate lh_shouldBeginEditingAtIndexPath:_path];
    }
    return YES;
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
