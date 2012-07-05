//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Drew Drinkwater on 28/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize sentToBrain;
@synthesize display;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];        
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self appendToSentToBrain:self.display.text];

    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    
    [self appendToSentToBrain:operation];
    
    [self appendToSentToBrain:@"="];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (IBAction)decimalPointPressed {
    
    if(!self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber =  YES;
    }
    
    if ([self.display.text rangeOfString:@"."].location == NSNotFound )
    {   
        self.display.text = [self.display.text stringByAppendingString:@"."];   
    }
}


- (IBAction)clearPressed {
    
    [self.brain clearStack];
    self.display.text = @"0";
    self.sentToBrain.text = @"";     
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backspacePressed {
    if (self.display.text.length > 1)
    {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    } 
    else 
    {
        self.display.text=@"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }

}

- (IBAction)signChangePressed {
    
    if ([@"-" isEqualToString:[self.display.text substringToIndex:1]])
    {
        self.display.text = [self.display.text substringFromIndex:1];
    }
    else 
    {
        self.display.text = [@"-" stringByAppendingString:self.display.text]; 
    }
    
    if (!self.userIsInTheMiddleOfEnteringANumber ) 
    {
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}


- (void)appendToSentToBrain:(NSString *)stringToAdd
{
    self.sentToBrain.text = [self.sentToBrain.text stringByAppendingString:[stringToAdd stringByAppendingString:@" "]]; 
    
    if (self.sentToBrain.text.length > 35){
        self.sentToBrain.text = [self.sentToBrain.text substringFromIndex:self.sentToBrain.text.length - 35];
    }
}

@end
