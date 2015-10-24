    //
    //  HBCustomNumberPadView.m
    //  keyboard
    //
    //  Created by wangfeng on 15/10/24.
    //  Copyright (c) 2015年 anyfish. All rights reserved.
    //

#import "HBCustomNumberPadView.h"
#define BG_COLOR     [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define TEXT_COLOR     [UIColor colorWithRed:0 green:0 blue:0 alpha:1]
#define HL_COLOR     [UIColor colorWithRed:194/255.0 green:200/255.0 blue:206/255.0 alpha:1]

#define LINE_COLOR      [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1]
#define TEXT_FONT  27
#define ADDITION_TITLE  @"X"

@implementation HBCustomNumberPadView
{
    CGFloat _height;
    CGFloat _width;
    NSArray* _nums ;
    NSArray* _letters;
    
}
-(instancetype)init
{
    if (self = [super init]) {
        
        _width = [[UIScreen mainScreen] bounds].size.width;
        if (_width < 413) {
            _height = 216;
        }else{
            _height = 226;
        }
        self.frame = CGRectMake(0, 0, _width, _height);
        
        self.backgroundColor = LINE_COLOR;
        _nums = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        _letters = @[@"",@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ"];
        
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 4; j++) {
                [self createButtonAtX:i Y:j];
            }
        }
    }
    return self;
}

-(void)createButtonAtX:(int)x Y:(int)y
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BG_COLOR;
    [button setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    
    UIImage* hLImage = [self imageWithColor:HL_COLOR];
    UIImage* whiteImage = [self imageWithColor:BG_COLOR];
    
    [button setBackgroundImage:hLImage forState:UIControlStateHighlighted];
    
    int index = x + y * 3;
    button.tag = index + 1;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (y < 3) {
        [button setTitle:_nums[index] forState:UIControlStateNormal];
    }else{
        if (x == 0) {
            button.backgroundColor = HL_COLOR;
            [button setBackgroundImage:whiteImage forState:UIControlStateHighlighted];
            [button setTitle:ADDITION_TITLE forState:UIControlStateNormal];
            
        }else if(x == 1){
            [button setTitle:@"0" forState:UIControlStateNormal];
        } else{
            button.backgroundColor = HL_COLOR;
            [button setBackgroundImage:whiteImage forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:@"DelImage"]  forState:UIControlStateNormal];
        }
    }
        //减去两条线的宽度
    CGFloat width = (_width) / 3;
    CGFloat height = (_height) / 4;
    CGFloat point_x = x * _width / 3;
    CGFloat point_y = y * _height / 4;
    if(x == 1) {
        point_x+=0.5;
        width-=1;
    }
    
    if (y != 3 && y!=1) {
        height -= 0.5;
    }
    if (y == 2) {
        point_y += 0.5;
        height -=0.5;
    }
    button.frame = CGRectMake(point_x, point_y, width, height);
    if (y < 3) {
        UILabel *labelLetter = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, width, 16)];
        labelLetter.text = [ _letters objectAtIndex:index];
        labelLetter.textColor = TEXT_COLOR;
        labelLetter.textAlignment = NSTextAlignmentCenter;
        labelLetter.font = [UIFont systemFontOfSize:12];
        [button addSubview:labelLetter];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT];
    [self addSubview:button];
    
    
}
-(void)buttonClick:(UIButton*)sender
{
    if (!self.textField) {
        return;
    }
        //特殊按键
    if (sender.tag == 10){
        self.textField.text = [self.textField.text stringByAppendingString:[NSString stringWithFormat:@"%@",ADDITION_TITLE]];
    }//回退
    else if(sender.tag == 12){
        if (self.textField.text.length != 0){
            self.textField.text = [self.textField.text substringToIndex:self.textField.text.length -1];
        }
    }
    else{
        NSInteger num = sender.tag;
        if (sender.tag == 11){
            num = 0;
        }
        self.textField.text = [self.textField.text stringByAppendingString:[NSString stringWithFormat:@"%zi",num]];
    }
    
    

    
}
-(UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
