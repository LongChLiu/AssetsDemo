//
//  CustTabViewCell.h
//  AssetsPickerDemo
//
//  Created by 刘隆昌 on 15-1-1.
//  Copyright (c) 2015年 刘隆昌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustTabViewCell : UITableViewCell


@property(nonatomic,retain)UIImageView* imaView;
@property float rowHeight;

-(void)configUI:(NSString *)urlStr;



@end
