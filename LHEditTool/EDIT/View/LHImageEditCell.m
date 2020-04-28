//
//  LHImageEditCell.m
//  LHEditTool
//
//  Created by 李辉 on 2018/11/15.
//  Copyright © 2018年 李辉. All rights reserved.
//

#import "LHImageEditCell.h"
#import "Masonry.h"
@implementation LHImageEditCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self lh_addAllSubviews];
    }
    return self;
}
-(void)lh_addAllSubviews{
    [self addSubview:self.imageTextV];
    [self addSubview:self.imV];
    [self.imageTextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self);
    }];
    [self.imV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
    }];
}

-(void)lh_setData:(id)model indexPath:(NSIndexPath *)path andDelegate:(id)delegate{
    self.model = (LHImageEditModel*)model;
    _path = path;
    _model.path = path;
    self.delegate =delegate;
}
-(void)setModel:(LHImageEditModel *)model{
    _model = model;
    _imageTextV.attributedText = _model.imageAttriStr;
    [_imageTextV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).priority(900);
        make.height.equalTo(@(model.cellHeight));
    }];
    [_imV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-5);
    }];
    _imV.image = _model.image;
    
}

-(LHTextView*)imageTextV{
    if (!_imageTextV) {
        _imageTextV = [LHTextView new];
        _imageTextV.delegate = self;
        _imageTextV.font = [UIFont systemFontOfSize:17];
        _imageTextV.scrollEnabled = NO;
        _imageTextV.textContainerInset = UIEdgeInsetsMake(1, 1, 1, 1);
        _imageTextV.allowsEditingTextAttributes = YES;
        
    }
    return _imageTextV;
}
-(UIImageView*)imV{
    if (!_imV) {
        _imV = [[UIImageView alloc]init];
    }
    return _imV;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(lh_shouldBeginEditingAtIndexPath:)]) {
        [self.delegate lh_shouldBeginEditingAtIndexPath:_model.path];
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(lh_imageCellDeleteAction:)]) {
            [self.delegate lh_imageCellDeleteAction:_model.path];
           
        }
         return NO;
    }else{
        if ([self.delegate respondsToSelector:@selector(lh_imageMoveCursorNextCell:andText:)]) {
            [self.delegate lh_imageMoveCursorNextCell:_model.path andText:text];
        }
        return NO;
    }
}

-(void)lh_beginEditingWithStatePreOne:(BOOL)preOne andLoction:(NSInteger)loc{
//    _imageTextV.attributedText = _model.imageAttriStr;
    [self.imageTextV becomeFirstResponder];
//    if (preOne) {
//        self.imageTextV.selectedRange = NSMakeRange(1, 0);
//    }else{
//        self.imageTextV.selectedRange = NSMakeRange(0, 0);
//    }
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
