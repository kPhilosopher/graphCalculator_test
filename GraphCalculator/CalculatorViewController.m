//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jinwoo Baek on 8/5/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController()
@property (retain, readonly) CalculatorBrain *brain;
@property BOOL userPressedAVariable;
@property BOOL userIsInTheMiddleOfTypingANumber;
@property BOOL solvePressed;
@property BOOL storedInformation;
@property BOOL periodIsEntered;
@property BOOL initialBooleanDigit;
@property BOOL initialBooleanVariable;
@property (copy) NSString *typingNumber;
@end

@implementation CalculatorViewController
@synthesize userPressedAVariable, storedInformation, periodIsEntered, userIsInTheMiddleOfTypingANumber,
			typingNumber, solvePressed, initialBooleanDigit, initialBooleanVariable;

// lazy alloc and init of brain
// returns brain

- (CalculatorBrain *)brain{
	if(!brain)
	{
		brain = [[CalculatorBrain alloc] init];
	}
	return brain;
}

//returns the tags of the variables

- (NSArray *) variables{
	NSString *variable1 = [[var1 titleLabel] text];
	NSString *variable2 = [[var2 titleLabel] text];
	NSString *variable3 = [[var3 titleLabel] text];
	return [NSArray arrayWithObjects:variable1, variable2, variable3, nil];
}

- (BOOL)checkIfVariableIsInExpression{
	if(!self.userPressedAVariable)
	{
		//go through the expression and check if there is a variable.
		if([CalculatorBrain variablesInExpression:self.brain.expression])
		{
			self.userPressedAVariable = YES;
		}
		else
		{
			self.userPressedAVariable = NO;
		}
	}
	return self.userPressedAVariable;
}

//private method that will take care of both userIsInTheMiddleOFTypingANumber and period

- (void) setUserIsNotTypingAndPeriodReset{
	self.userIsInTheMiddleOfTypingANumber = NO;
	self.periodIsEntered = NO;
	self.initialBooleanDigit = YES;
}

- (IBAction)clear
{
	[display setText:@"0"];
	[self.brain setOperand:0.0];
	[self.brain performOperation:@"clear"];
	[self.brain performMemoryOperation:@"clear" toStore:@"0"];
	self.typingNumber = nil;
	self.storedInformation = NO;
	self.userIsInTheMiddleOfTypingANumber = NO;
	self.periodIsEntered = NO;
	self.userPressedAVariable = NO;
	self.initialBooleanDigit = NO;
	self.initialBooleanVariable = NO;
}

- (void)changeDisplay:(NSString *)text
{
	if([self checkIfVariableIsInExpression])
	{
		NSString *expressionDescription = [CalculatorBrain descriptionOfExpression:self.brain.expression];
		[display setText:expressionDescription];
	}
	else
	{
		[display setText:text];
	}
}

-(BOOL)checkIfExpressionIsEmpty
{
	BOOL theVerdict;
	if([self.brain.expression count] == 0)
	{
		theVerdict = YES;
	}
	return theVerdict;
}

-(BOOL)checkIfLastElementInExpressionIsIn:(NSArray *) arrayOfElements
{
	BOOL theVerdict;
	BOOL lastOperationIsValid;
	BOOL stringOrNot;
	NSString *stringInExpression;
	id lastOperation = [CalculatorBrain lastItemInExpression:self.brain.expression];
	
	
	if([lastOperation isKindOfClass:[NSString class]])
	{
		stringOrNot = YES;
		lastOperationIsValid = YES;
		stringInExpression = (NSString *)lastOperation;
		stringInExpression = [CalculatorBrain stripDownElement:stringInExpression];
	}
	else if([lastOperation isKindOfClass:[NSNumber class]])
	{
		stringOrNot = NO;
		lastOperationIsValid = YES;
	}
	
	if(lastOperationIsValid)
	{
		for (id element in arrayOfElements)
		{
			if([element isKindOfClass:[NSString class]] && stringOrNot)
			{
				NSString *string = (NSString *)element;
				if([string isEqualToString:stringInExpression])
				{
					theVerdict = YES;
				}
			}
			if([element isKindOfClass:[NSNumber class]] && !stringOrNot)
			{
				theVerdict = YES;
			}
		}
	}
	else
	{
		if(!([self.brain.expression count] == 0))
			NSLog(@"expression has error. from checkIfLastElementInExpression");
	}
	return theVerdict;
}

//-(BOOL)checkLengthOfLastElementInExpression:(int) theLength
//{
//	
//}

// executed when a digit is pressed
- (IBAction)digitPressed:(UIButton *)sender
{
	if([self checkIfLastElementInExpressionIsIn:[NSArray arrayWithObjects:@"+", @"-", @"/", @"*", nil]] ||
	   (!self.initialBooleanDigit && [self checkIfExpressionIsEmpty]))
	{
		NSString *digit = [[sender titleLabel] text];
		
		if(self.userIsInTheMiddleOfTypingANumber)
		{
			if((![self.typingNumber isEqualToString:@"0"]))
				{
				// handle when user is entering point again.
				if( (self.periodIsEntered) && ([digit isEqualToString:@"."]))
				{
					//nothing happens
					self.periodIsEntered = YES;
				}
				else
				{
					self.typingNumber = [self.typingNumber stringByAppendingString:digit];
					[self changeDisplay:self.typingNumber];
				}
			}
		}
		
		// when user starts typing a new set of digits
		
		else
		{
			if([digit isEqualToString:@"."])
			{
				self.typingNumber = [@"0" stringByAppendingString:digit];
				[self changeDisplay:self.typingNumber];
			}
			else
			{
				self.typingNumber = digit;
				[self changeDisplay:self.typingNumber];
			}
			self.userIsInTheMiddleOfTypingANumber = YES;
		
		}
		
		// Set the period boolean so that there isn't two dots in a number
		if([digit isEqualToString:@"."])
		{
			self.periodIsEntered = YES;
		}
	}
//    NSDictionary *values = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:32.3],@"x",
//							[NSNumber numberWithFloat:2.2],@"a",
//							[NSNumber numberWithFloat:-3.3],@"b",nil];
//	id returnedValue = [values objectForKey:@"a"];
//	if([returnedValue isKindOfClass:[NSNumber class]])
//	{
//		NSNumber *nsnumber = (NSNumber *)returnedValue;
//		NSString *stringerrr = [nsnumber description];
//		NSLog(stringerrr);
//	}

}


// executed when an operation is pressed

- (IBAction)operationPressed:(UIButton *)sender
{
	
	NSString *operation = [[sender titleLabel] text];

	if(self.userIsInTheMiddleOfTypingANumber)
	{
		if(![self checkIfVariableIsInExpression])
		{
			self.brain.operand = [self.typingNumber doubleValue];
		}
		[self.brain addNumber:self.typingNumber andOperation:operation];
		[self setUserIsNotTypingAndPeriodReset];
	}
	else if(![self checkIfExpressionIsEmpty])
	{
		[self.brain addNumber:nil andOperation:operation];
	}
	
	if([self checkIfVariableIsInExpression])
	{	
		[self changeDisplay:@""];
	}
	else
	{
		double result = [self.brain performOperation:operation];
		[self changeDisplay:[NSString stringWithFormat:@"%g", result]];
	}
}


-(IBAction)variableButton:(UIButton *)sender
{
	
	if (self.userIsInTheMiddleOfTypingANumber)
	{
		self.userIsInTheMiddleOfTypingANumber = YES;
	}
	//renew the display and set the variable in the model
	else if([self checkIfLastElementInExpressionIsIn:[NSArray arrayWithObjects:@"+", @"-", @"*", @"/", nil]] ||
			(!self.initialBooleanVariable && [self checkIfExpressionIsEmpty]))
	{
		//adding the variable to the expression
		NSString *tempString = [[sender titleLabel] text];
		[self.brain setVariableAsOperand:tempString];
		
		//update the display
		[self changeDisplay:@""];
		
		self.initialBooleanVariable = YES;
	}
	else
	{
		//alert view then get out of this method
	}
}

// executed when a memory related button is pressed.

- (IBAction)memoryRelatedButtonIsPressed:(UIButton *)sender
{	
	if(![self checkIfVariableIsInExpression])
	{
		double result = [self.brain performMemoryOperation:[[sender titleLabel] text] toStore:[display text]];
		
		if([@"Recall" isEqualToString:[[sender titleLabel] text]] && self.storedInformation)
		{
			[self setUserIsNotTypingAndPeriodReset];
			[display setText:[NSString stringWithFormat:@"%g", result]];//setting display here
		}
		else if([@"Store" isEqualToString:[[sender titleLabel] text]])
		{
			self.storedInformation = YES;
		}
	}
}

- (IBAction)solve:(UIButton *)sender
{
	//make sure expression is not empty
	if(![self checkIfExpressionIsEmpty])
	{
		//make sure expression has a variable
		if(!([[CalculatorBrain variablesInExpression:self.brain.expression] count] == 0))
		{
			NSDictionary *values = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:32.3],@"x",
									[NSNumber numberWithFloat:2.2],@"a",
									[NSNumber numberWithFloat:-3.3],@"b",nil];
			[self.brain addNumber:nil andOperation:@"="];
			double result = [CalculatorBrain evaluateExpression:self.brain.expression usingVariableValues:values];
			[display setText:[NSString stringWithFormat:@"%g", result]];
		}
	}
}

- (void)dealloc
{
	[typingNumber release];
	[brain release];
	[super dealloc];
}


@end
