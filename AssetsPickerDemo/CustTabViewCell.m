//
//  CustTabViewCell.m
//  AssetsPickerDemo
//
//  Created by 刘隆昌 on 15-1-1.
//  Copyright (c) 2015年 刘隆昌. All rights reserved.
//

#import "CustTabViewCell.h"

@implementation CustTabViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =
    [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imaView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 59, 59)];
        _imaView.layer.cornerRadius = 8;
        _imaView.layer.masksToBounds = YES;
        _rowHeight = _imaView.size.height;
        [self addSubview:_imaView];
        
        
    }
    return self;
}

-(void)configUI:(NSString *)urlStr{
    
    
    [_imaView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
    

    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
