//
//  ViewController.m
//  HBCustomNumeberPadViewDemo
//
//  Created by wangfeng on 15/10/24.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import "ViewController.h"
#import "HBCustomNumberPadView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HBCustomNumberPadView* textInputView = [HBCustomNumberPadView new];
    self.textField.inputView = textInputView;
        //此处为弱引用
    textInputView.textField = self.textField;

}



@end
