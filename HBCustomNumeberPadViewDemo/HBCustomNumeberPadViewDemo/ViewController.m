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

@property (weak, nonatomic) IBOutlet UITextField *textField2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HBCustomNumberPadView* textInputView = [HBCustomNumberPadView new];
    self.textField.inputView = textInputView;
        //此处为弱引用
    textInputView.textField = self.textField;
    

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",NSStringFromRange(range));
    if (textField) {
        NSString* text = textField.text;
                        //删除
        if([string isEqualToString:@""]){
            
                //删除一位
            if(range.length == 1){
                    //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                    //从中间删除
                else{
                    NSInteger offset = range.location;

                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                    //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self parseString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == 3 || range.location  == 8) {
                    offset ++;
                }
                if (isLast) {
                        //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
                //限制输入字符个数
            if (([self noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
                return NO;
            }
                //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
//            if(![string isNum]){
//                return NO;
//            }
            [textField insertText:string];
            textField.text = [self parseString:textField.text];

            NSInteger offset = range.location + string.length;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
        
    }
    
    return YES;
}

-(NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >3) {
        [mStr insertString:@" " atIndex:3];
    }if (mStr.length > 8) {
        [mStr insertString:@" " atIndex:8];
        
    }
    
   return  mStr;
}


    //这种是采取的延迟格式化，类似支付宝中添加银行卡输入
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == _userNameTextField) {
//            //限制输入字符个数
//        NSString* text = textField.text;
//        if (([self noneSpaseString:textField.text].length >10 && range.length == 0) || range.location > 12) {
//            return NO;
//        }
//            //删除
//        if([string isEqualToString:@""]){
//            
//                //删除一位
//            if(range.length == 1){
//                    //最后一位,遇到空格则多删除一次
//                if (range.location == text.length-1 ) {
//                    if ([text characterAtIndex:text.length-1] == ' ') {
//                        [textField deleteBackward];
//                    }
//                    return YES;
//                }
//                    //从中间删除
//                else{
//                    NSInteger offset = range.location;
//                    
//                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
//                        [textField deleteBackward];
//                        offset --;
//                    }
//                    dispatch_time_t tim = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.1*NSEC_PER_SEC));
//                    dispatch_after(tim,dispatch_get_main_queue(), ^{
//                        NSMutableString* mStr = [NSMutableString stringWithString:[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
//                        if (mStr.length >3) {
//                            [mStr insertString:@" " atIndex:3];
//                        }if (mStr.length > 8) {
//                            [mStr insertString:@" " atIndex:8];
//                            
//                        }
//                        textField.text = mStr;
//                        UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
//                        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
//                        
//                    });
//                    
//                    
//                    return YES;
//                }
//            }
//            else if (range.length > 1) {
//                BOOL isLast = NO;
//                    //如果是从最后一位开始
//                if(range.location + range.length == textField.text.length ){
//                    isLast = YES;
//                }
//                dispatch_time_t tim = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.1*NSEC_PER_SEC));
//                dispatch_after(tim,dispatch_get_main_queue(), ^{
//                    NSMutableString* mStr = [NSMutableString stringWithString:[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
//                    if (mStr.length >3) {
//                        [mStr insertString:@" " atIndex:3];
//                    }if (mStr.length > 8) {
//                        [mStr insertString:@" " atIndex:8];
//                    }
//                    textField.text = mStr;
//                    NSInteger offset = range.location;
//                    if (range.location == 3 || range.location  == 8) {
//                        offset ++;
//                    }
//                    if (isLast) {
//                            //光标直接在最后一位了
//                    }else{
//                        UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
//                        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
//                    }
//                    
//                });
//                
//                return YES;
//            }
//            
//            else{
//                return YES;
//            }
//        }
//        
//        else if(string.length >0){
//            if (![string isNum]) {
//                    //[self promptMessage:@"输入不合法！"];
//                return  NO;
//            }
//            [textField insertText:string];
//            NSMutableString* mStr = [NSMutableString stringWithString:[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
//            if (mStr.length >3) {
//                [mStr insertString:@" " atIndex:3];
//            }if (mStr.length > 8) {
//                [mStr insertString:@" " atIndex:8];
//            }
//            textField.text = mStr;
//            NSInteger offset = range.location + string.length;
//            if (range.location == 3 || range.location  == 8) {
//                offset ++;
//            }
//            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
//            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
//            return NO;
//        }else{
//            return YES;
//        }
//        
//    }
//    
//    return YES;
//}

@end
