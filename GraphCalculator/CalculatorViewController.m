//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jinwoo Baek on 8/5/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import "CalculatorViewController.h"
#define FUNDAMENTAL_OPERATION 1
#define VARIABLE 2
#define NON_FUNDAMENTAL_OPERATION 3

@interface CheckLastItemInExpression : NSObject 
{
@private
    NSArray *arrayOfCandidates;
	id lastElement;
	BOOL theVerdict;
}
-(id)initWithArrayOfCandidates:(NSArray *) array andLastElement:(id) tempLastElement;
-(void) determineWhetherLastElementInExpressionIsStringOrNumber;
@end

@interface CheckLastItemInExpression()
@property (nonatomic,retain) NSArray *arrayOfCandidates;
@property (retain) id lastElement;
@property BOOL theVerdict;

-(void) checkIfTheLastElementIsVariable;
-(void) stripTheVariable;
-(void) iterateThroughArrayOfCandidatesToFindIfTheLastElementMatch;
-(void) determineEqualityOf_NSStringClass_AndKindOfClassOfTheFollowing:(id) element;
-(void) determineEqualityOfStringAndTheFollowing:(NSString *)string;

-(void) iterateThroughArrayOfCandidatesToFindIfTheLastElementIsNumber;
-(void) determineEqualityOf_NSNumberClass_AndKindOfClassOfTheFollowing:(id) element;

@end

@implementation CheckLastItemInExpression
@synthesize arrayOfCandidates, lastElement, theVerdict;

-(id)initWithArrayOfCandidates:(NSArray *) array andLastElement:(id) tempLastElement
{
	[super init];
	self.arrayOfCandidates = array;
	self.lastElement = tempLastElement;
	return self;
}

-(void) determineWhetherLastElementInExpressionIsStringOrNumber
{
	if([self.lastElement isKindOfClass:[NSString class]])
		[self checkIfTheLastElementIsVariable];
	else if([self.lastElement isKindOfClass:[NSNumber class]])
		[self iterateThroughArrayOfCandidatesToFindIfTheLastElementIsNumber];
}

-(void) checkIfTheLastElementIsVariable
{
	if ([self.lastElement length] == VARIABLE) 
		[self stripTheVariable];
	[self iterateThroughArrayOfCandidatesToFindIfTheLastElementMatch];
}

-(void) stripTheVariable
{
	self.lastElement = [CalculatorBrain stripDownElement:self.lastElement];
}

-(void) iterateThroughArrayOfCandidatesToFindIfTheLastElementMatch
{
	for (id element in self.arrayOfCandidates)
		[self determineEqualityOf_NSStringClass_AndKindOfClassOfTheFollowing:element];
}

-(void) determineEqualityOf_NSStringClass_AndKindOfClassOfTheFollowing:(id) element
{
	if([element isKindOfClass:[NSString class]])
		[self determineEqualityOfStringAndTheFollowing:element];
}

-(void) determineEqualityOfStringAndTheFollowing:(NSString *)string
{
	if([string isEqualToString:self.lastElement])
		self.theVerdict = YES;
}

-(void) iterateThroughArrayOfCandidatesToFindIfTheLastElementIsNumber
{
	for (id element in self.arrayOfCandidates)
		[self determineEqualityOf_NSNumberClass_AndKindOfClassOfTheFollowing:element];
}

-(void) determineEqualityOf_NSNumberClass_AndKindOfClassOfTheFollowing:(id) element
{
	if([element isKindOfClass:[NSNumber class]])
		self.theVerdict = YES;
}

-(NSArray *) arrayOfCandidates
{
	if (!arrayOfCandidates)
		arrayOfCandidates = [[NSArray alloc] init];
	return arrayOfCandidates;
}

-(void) dealloc
{
	self.arrayOfCandidates = nil;
	[super dealloc];
}
@end


@interface CalculatorViewController()
@property (retain, readonly) CalculatorBrain *brain;
@property BOOL userPressedAVariable;
@property BOOL userIsInTheMiddleOfTypingANumber;
@property BOOL storedInformation;

@property (copy) NSString *typingNumber;




@property BOOL periodIsEntered;
@property BOOL initialBooleanDigit;
@property BOOL initialBooleanVariable;
@end

@implementation CalculatorViewController
@synthesize userPressedAVariable, storedInformation, periodIsEntered, userIsInTheMiddleOfTypingANumber,
			typingNumber, initialBooleanDigit, initialBooleanVariable;

// lazy alloc and init of brain
// returns brain

- (CalculatorBrain *)brain{
	if(!brain)
	{
		brain = [[CalculatorBrain alloc] init];
	}
	return brain;
}

- (BOOL)checkIfVariableIsInExpression{
	if(!self.userPressedAVariable)
	{
		//go through the expression and check if there is a variable.
		if([CalculatorBrain variablesInExpression:self.brain.expression])	self.userPressedAVariable = YES;
		else																self.userPressedAVariable = NO;
	}
	return self.userPressedAVariable;
}

- (void) setUserIsNotTypingAndPeriodReset{
	self.userIsInTheMiddleOfTypingANumber = NO;
	self.periodIsEntered = NO;
	self.initialBooleanDigit = YES;
}

- (IBAction)clear
{
	
	self.userIsInTheMiddleOfTypingANumber = NO;
	self.periodIsEntered = NO;
	
	
	[display setText:@"0"];
	[self.brain setOperand:0.0];
	[self.brain performOperation:@"clear"];
	[self.brain performMemoryOperation:@"Store" toStore:@"0"];
	self.typingNumber = nil;
	self.storedInformation = NO;
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
		theVerdict = YES;
	return theVerdict;
}

-(BOOL)initiateCheckIfLastElementInExpressionCorrespondsWith:(NSArray *) arrayOfCandidates
{	
	CheckLastItemInExpression *check = 
	[[[CheckLastItemInExpression alloc] initWithArrayOfCandidates:arrayOfCandidates 
												   andLastElement:[CalculatorBrain lastItemInExpression:self.brain.expression]] autorelease];
	[check determineWhetherLastElementInExpressionIsStringOrNumber];
	return check.theVerdict;
}

// executed when a digit is pressed
- (IBAction)digitPressed:(UIButton *)sender
{
	if([self initiateCheckIfLastElementInExpressionCorrespondsWith:[NSArray arrayWithObjects:@"+", @"-", @"/", @"*", nil]] ||
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
	else if([self initiateCheckIfLastElementInExpressionCorrespondsWith:[NSArray arrayWithObjects:@"+", @"-", @"*", @"/", nil]] ||
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
			[display setText:[NSString stringWithFormat:@"%g", result]];
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
	self.typingNumber = nil;
	[brain release];
	[super dealloc];
}


@end
