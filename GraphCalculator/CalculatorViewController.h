//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Jinwoo Baek on 8/5/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController
{
@private
	IBOutlet UILabel *display;
	CalculatorBrain *brain;
	NSString *typingNumber;
	NSArray *fundamentalOperations;
	NSDictionary *variableValues;
	BOOL userIsInTheMiddleOfTypingANumber;
	BOOL storedInformation;
	BOOL userPressedAVariable;
	BOOL solvePressed;
	BOOL initialBooleanDigit;
	BOOL initialBooleanVariable;
	BOOL periodIsEntered;
	
//	DigitPressed *digitPressed;
//	NSArray *buttonMethodInstances;
}

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)memoryRelatedButtonIsPressed:(UIButton *)sender;
- (IBAction)clear;
- (IBAction)variableButton:(UIButton *)sender;
- (IBAction)solve:(UIButton *)sender;
@end
