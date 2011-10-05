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
@property BOOL periodIsEntered;

@property (copy) NSString *typingNumber;
@property (retain) IBOutlet UILabel *display;
@property (nonatomic,retain) NSArray *fundamentalOperations;
@property (nonatomic,retain) NSDictionary *variableValues;

- (void) checkIfExpressionHasVariable;
- (void) setUserPressedAVariableAsYes;
- (void) setAsUserIsNotTypingAndResetPeriodBoolean;

//Digit
- (void) checkIfUserIsInTheMiddleOfTypingANumberAndSendDownTheFollowing:(NSString *) digit;
- (void) checkToStopIfTheCurrentTypingNumberIsEqualToZeroAndSendDownTheFollowing:(NSString *) digit;
- (void) checkToStopIfAPeriodIsBeingEnteredTwice:(NSString *) digit;
- (void) isPeriod_AppendToZeroIfTheFollowing:(NSString *) digit;
- (void) setTheCurrentTypingNumberTo:(NSString *) digit;
- (void) setBooleanToNotifyThatUserIsInTheMiddleOfTypingNumber;
- (void) period_DetermineIfTheFollowing:(NSString *)digit;
//Operation
- (void) checkWhetherUserIsInTheMiddleOfTypingNumberOrNotTypingNumberWhileExpressionIsNotEmptyAndPassDown:(NSString *)operation;
- (void) checkIfVariableIsNotInExpressionForOperation;
- (void) setOperandInBrainToTheNumericValueOfTypingNumber;
- (void) checkIfVariableIsInExpressionToDetermineDisplayOptionsAndPassDown:(NSString *)operation;
//Memory
- (void) checkIfVariableIsnotInExpressionForMemoryAndPassDown:(UIButton *)sender;
- (void) performMemoryOperationWith:(UIButton *)sender;
- (void) checkIf_Recall_IsEqualTo:(UIButton *)sender andPassDown:(double) result;
- (void) checkIf_Store_IsEqualTo:(UIButton *)sender;
//Solve
- (void) checkToMakeSureExpressionIsNotEmpty;
- (void) checkToMakeSureVariableIsInExpression;
- (void) callToSolveInCalculatorBrainAndDisplay;
- (void) addEqualOperationAtEndToEnsureCorrectCalculations;
@end

@implementation CalculatorViewController
@synthesize userIsInTheMiddleOfTypingANumber, userPressedAVariable, storedInformation, periodIsEntered;
@synthesize typingNumber, display, fundamentalOperations, variableValues;

- (CalculatorBrain *)brain{
	if(!brain)
		brain = [[CalculatorBrain alloc] init];
	return brain;
}

////////////////
//
- (BOOL)checkIfVariableIsInExpression{
	if(!self.userPressedAVariable)
		[self checkIfExpressionHasVariable];
	return self.userPressedAVariable;
}
- (void) checkIfExpressionHasVariable
{
	if([CalculatorBrain variablesInExpression:self.brain.expression])
		[self setUserPressedAVariableAsYes];
}

-(void) setUserPressedAVariableAsYes
{
	self.userPressedAVariable = YES;
}
//
////////////////

- (void)changeDisplay:(NSString *)text
{
	if([self checkIfVariableIsInExpression])
		text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
	[display setText:text];
}

- (IBAction)clear
{
	[self setAsUserIsNotTypingAndResetPeriodBoolean];
	[self.brain clearOperations];
	self.typingNumber = nil;
	self.storedInformation = NO;
	self.userPressedAVariable = NO;
	[self changeDisplay:@"0"];
}

- (void) setAsUserIsNotTypingAndResetPeriodBoolean
{
	self.userIsInTheMiddleOfTypingANumber = NO;
	self.periodIsEntered = NO;
}

-(BOOL)initiateCheckWhetherLastElementInExpressionCorrespondsWith:(NSArray *) arrayOfCandidates
{	
	CheckLastItemInExpression *check = 
	[[[CheckLastItemInExpression alloc] initWithArrayOfCandidates:arrayOfCandidates 
												   andLastElement:[CalculatorBrain lastItemInExpression:self.brain.expression]] autorelease];
	[check determineWhetherLastElementInExpressionIsStringOrNumber];
	return check.theVerdict;
}

-(BOOL)checkIfExpressionIsEmpty
{
	BOOL verdict = NO;
	if([self.brain.expression count] == 0)
		verdict = YES;
	return verdict;
}


////////////////
//
- (IBAction)digitPressed:(UIButton *)sender
{
	if([self initiateCheckWhetherLastElementInExpressionCorrespondsWith:self.fundamentalOperations] ||	([self checkIfExpressionIsEmpty]))
	{
		NSString *digit = [[sender titleLabel] text];
		[self checkIfUserIsInTheMiddleOfTypingANumberAndSendDownTheFollowing:digit];
	}
}

- (void) checkIfUserIsInTheMiddleOfTypingANumberAndSendDownTheFollowing:(NSString *) digit
{
	if(self.userIsInTheMiddleOfTypingANumber)
		[self checkToStopIfTheCurrentTypingNumberIsEqualToZeroAndSendDownTheFollowing:digit];
	else
		[self isPeriod_AppendToZeroIfTheFollowing:digit];
	[self period_DetermineIfTheFollowing:digit];

}
- (void) checkToStopIfTheCurrentTypingNumberIsEqualToZeroAndSendDownTheFollowing:(NSString *) digit
{
	if(![self.typingNumber isEqualToString:@"0"])
		[self checkToStopIfAPeriodIsBeingEnteredTwice:digit];
}
- (void) checkToStopIfAPeriodIsBeingEnteredTwice:(NSString *) digit
{
	if( !((self.periodIsEntered) && ([digit isEqualToString:@"."])))
	{
		[self setTheCurrentTypingNumberTo:[self.typingNumber stringByAppendingString:digit]];
		[self changeDisplay:self.typingNumber];
	}
}

- (void) isPeriod_AppendToZeroIfTheFollowing:(NSString *) digit
{
	if([digit isEqualToString:@"."])	digit = [@"0" stringByAppendingString:digit];
	[self setTheCurrentTypingNumberTo:digit];
	[self changeDisplay:self.typingNumber];
	[self setBooleanToNotifyThatUserIsInTheMiddleOfTypingNumber];
}

- (void) setTheCurrentTypingNumberTo:(NSString *) digit
{
	self.typingNumber = digit;
}	
		 
- (void) setBooleanToNotifyThatUserIsInTheMiddleOfTypingNumber
{
	self.userIsInTheMiddleOfTypingANumber = YES;
}

- (void) period_DetermineIfTheFollowing:(NSString *)digit
{
	if([digit isEqualToString:@"."])
		self.periodIsEntered = YES;
}
//
////////////////

////////////////
//
- (IBAction)operationPressed:(UIButton *)sender
{
	NSString *operation = [[sender titleLabel] text];
	[self checkWhetherUserIsInTheMiddleOfTypingNumberOrNotTypingNumberWhileExpressionIsNotEmptyAndPassDown:operation];
	[self checkIfVariableIsInExpressionToDetermineDisplayOptionsAndPassDown:operation];
}

- (void) checkWhetherUserIsInTheMiddleOfTypingNumberOrNotTypingNumberWhileExpressionIsNotEmptyAndPassDown:(NSString *)operation
{
	if(self.userIsInTheMiddleOfTypingANumber)
	{
		[self checkIfVariableIsNotInExpressionForOperation];
		[self.brain toExpression_Add:self.typingNumber andAlsoAdd:operation];
		[self setAsUserIsNotTypingAndResetPeriodBoolean];
	}
	else if(![self checkIfExpressionIsEmpty])
		[self.brain toExpression_Add:nil andAlsoAdd:operation];
}

- (void) checkIfVariableIsNotInExpressionForOperation
{
	if(![self checkIfVariableIsInExpression])
		[self setOperandInBrainToTheNumericValueOfTypingNumber];
}

- (void) setOperandInBrainToTheNumericValueOfTypingNumber
{
	self.brain.operand = [self.typingNumber doubleValue];
}

- (void) checkIfVariableIsInExpressionToDetermineDisplayOptionsAndPassDown:(NSString *)operation
{
	if([self checkIfVariableIsInExpression])		[self changeDisplay:@""];
	else	[self changeDisplay:[NSString stringWithFormat:@"%g", [self.brain performOperation:operation]]];
}
//
////////////////


////////////////
//
-(IBAction)variableButton:(UIButton *)sender
{	
	if(!self.userIsInTheMiddleOfTypingANumber && 
	   (([self initiateCheckWhetherLastElementInExpressionCorrespondsWith:self.fundamentalOperations]) ||  ([self checkIfExpressionIsEmpty])))
	{
		[self.brain setVariableAsOperand:[[sender titleLabel] text]];
		[self changeDisplay:@""];
	}
}
//
////////////////


////////////////
//
- (IBAction)memoryRelatedButtonIsPressed:(UIButton *)sender
{	
	[self checkIfVariableIsnotInExpressionForMemoryAndPassDown:sender];
}
- (void) checkIfVariableIsnotInExpressionForMemoryAndPassDown:(UIButton *)sender
{
	if(![self checkIfVariableIsInExpression])
		[self performMemoryOperationWith:sender];
}
- (void) performMemoryOperationWith:(UIButton *)sender
{
	double result = [self.brain performMemoryOperation:[[sender titleLabel] text] toStore:[display text]];
	
	[self checkIf_Recall_IsEqualTo:sender andPassDown:result];
	[self checkIf_Store_IsEqualTo:sender];
	
}
- (void) checkIf_Recall_IsEqualTo:(UIButton *)sender andPassDown:(double) result
{
	if([@"Recall" isEqualToString:[[sender titleLabel] text]] && self.storedInformation)
	{
		[self setAsUserIsNotTypingAndResetPeriodBoolean];
		[self changeDisplay:[NSString stringWithFormat:@"%g", result]];
	}
}

- (void) checkIf_Store_IsEqualTo:(UIButton *)sender
{
	if([@"Store" isEqualToString:[[sender titleLabel] text]])
		self.storedInformation = YES;
}
//
////////////////


////////////////
//
- (IBAction) solve:(UIButton *) sender
{
	[self checkToMakeSureExpressionIsNotEmpty];
}

- (void) checkToMakeSureExpressionIsNotEmpty
{
	if(![self checkIfExpressionIsEmpty])
		[self checkToMakeSureVariableIsInExpression];
}
- (void) checkToMakeSureVariableIsInExpression
{
	if(!([[CalculatorBrain variablesInExpression:self.brain.expression] count] == 0))
		[self callToSolveInCalculatorBrainAndDisplay];
}
- (void) callToSolveInCalculatorBrainAndDisplay
{
	[self addEqualOperationAtEndToEnsureCorrectCalculations];
	[display setText:[NSString stringWithFormat:@"%g", [CalculatorBrain evaluateExpression:self.brain.expression 
																	   usingVariableValues:self.variableValues]]];
}

- (void) addEqualOperationAtEndToEnsureCorrectCalculations
{
	[self.brain toExpression_Add:nil andAlsoAdd:@"="];
}
//
////////////////


////////////////
//
- (IBAction)graphTheExpression:(UIButton *)sender
{
	GraphCalculatorViewController *graphCalculatorViewController = [[GraphCalculatorViewController alloc] init];
	graphCalculatorViewController.title = @"Graph";
	[self addEqualOperationAtEndToEnsureCorrectCalculations];
	graphCalculatorViewController.expressionToEvaluate = self.brain.expression;
	[self.navigationController pushViewController:graphCalculatorViewController animated:YES];
	[graphCalculatorViewController release];
}
//
////////////////

-(NSDictionary *) variableValues
{
	return [[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:32.3],@"x",nil] autorelease];
//			[NSNumber numberWithFloat:2.2],@"a",
//			[NSNumber numberWithFloat:-3.3],@"b",nil];
}

-(NSArray *) fundamentalOperations
{
	return [NSArray arrayWithObjects:@"+", @"-", @"*", @"/", nil];
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
