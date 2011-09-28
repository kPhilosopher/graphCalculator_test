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
@property (retain) IBOutlet UILabel *display;

@property (copy) NSString *typingNumber;

- (void) setUserIsNotTypingAndPeriodReset;


@property BOOL periodIsEntered;
@end

@implementation CalculatorViewController
@synthesize userPressedAVariable, storedInformation, periodIsEntered, userIsInTheMiddleOfTypingANumber,
			typingNumber, display;

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
		if([CalculatorBrain variablesInExpression:self.brain.expression])	self.userPressedAVariable = YES;
	return self.userPressedAVariable;
}



- (void)changeDisplay:(NSString *)text
{
	if([self checkIfVariableIsInExpression])
		text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
	[display setText:text];
}

- (IBAction)clear
{
	[self setUserIsNotTypingAndPeriodReset];
	[self.brain clearOperations];
	self.typingNumber = nil;
	self.storedInformation = NO;
	self.userPressedAVariable = NO;
	[self changeDisplay:@"0"];
}

- (void) setUserIsNotTypingAndPeriodReset
{
	self.userIsInTheMiddleOfTypingANumber = NO;
	self.periodIsEntered = NO;
}


-(BOOL)checkIfExpressionIsEmpty
{
	BOOL verdict = NO;
	if([self.brain.expression count] == 0)
		verdict = YES;
	return verdict;
}

-(BOOL)initiateCheckWhetherLastElementInExpressionCorrespondsWith:(NSArray *) arrayOfCandidates
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
	if([self initiateCheckWhetherLastElementInExpressionCorrespondsWith:[NSArray arrayWithObjects:@"+", @"-", @"/", @"*", nil]] ||	([self checkIfExpressionIsEmpty]))
	{
		NSString *digit = [[sender titleLabel] text];
		
		if(self.userIsInTheMiddleOfTypingANumber)
		{
			if((![self.typingNumber isEqualToString:@"0"]))
			{
				// handle when user is entering point again.
				if( !((self.periodIsEntered) && ([digit isEqualToString:@"."])))
				{
					self.typingNumber = [self.typingNumber stringByAppendingString:digit];
					[self changeDisplay:self.typingNumber];
				}
			}
		}
		else
		{
			if([digit isEqualToString:@"."])
			{
				self.typingNumber = [@"0" stringByAppendingString:digit];
			}
			else
			{
				self.typingNumber = digit;
			}
			[self changeDisplay:self.typingNumber];
			self.userIsInTheMiddleOfTypingANumber = YES;
		}
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
	else if(([self initiateCheckWhetherLastElementInExpressionCorrespondsWith:[NSArray arrayWithObjects:@"+", @"-", @"*", @"/", nil]]) ||	([self checkIfExpressionIsEmpty]))
	{
		NSString *tempString = [[sender titleLabel] text];
		[self.brain setVariableAsOperand:tempString];
		[self changeDisplay:@""];
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
			[self changeDisplay:[NSString stringWithFormat:@"%g", result]];
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

-(void) viewDidUnload
{
	self.display = nil;
}

- (void)dealloc
{
	self.display = nil;
	self.typingNumber = nil;
	[brain release];
	[super dealloc];
}


@end
