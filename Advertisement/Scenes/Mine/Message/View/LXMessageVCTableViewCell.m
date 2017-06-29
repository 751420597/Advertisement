//
//  LXMessageVCTableViewCell.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/8.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXMessageVCTableViewCell.h"

@implementation LXMessageVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.customeView.layer.cornerRadius = 3.f;
    self.customeView.layer.borderColor = LXColorHex(0xebebeb).CGColor;
    self.customeView.layer.borderWidth = 1.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageModel:(LXMessageModel *)messageModel {
    _messageModel = messageModel;
    
    self.leadingL.text = self.messageModel.title;
    self.bottomL.text = self.messageModel.content;
    if([self.messageModel.readFlag isEqualToString:@"0"]){
        self.redButton.backgroundColor = [UIColor redColor];
    }else{
        self.redButton.backgroundColor = [UIColor clearColor];
    }
}

@end
