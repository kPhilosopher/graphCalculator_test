//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jinwoo Baek on 8/5/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import "CalculatorBrain.h"
#define VARIABLE_PREFIX @"%"

#define FUNDAMENTAL_OPERATION 1
#define VARIABLE 2
#define NON_FUNDAMENTAL_OPERATION 3

@interface DescriptionOfExpression : NSObject
{
	@private
	NSString *theDescription;
	id iterationElement;
}
- (void)compileDescriptionByIteratingThrough:(NSMutableArray *)anExpression;
@end

@interface DescriptionOfExpression ()
@property (nonatomic, copy) NSString *theDescription;
@property (retain) id iterationElement;

- (void) filterElementToEitherStringOrNumber;
- (void) doNothingWithEqualOperationElement;
- (void) stripDownElementsUsingCalculatorBrainMethod;
- (void) filterFundamentality;
- (void) appendNonFundamentalOperation;
- (void) appendVariableOrFundamentalOperation;
- (void) appendNumberToDescription;
@end

@implementation DescriptionOfExpression
@synthesize theDescription, iterationElement;

- (void)compileDescriptionByIteratingThrough:(NSMutableArray *)anExpression
{
	for (id element in anExpression)
	{
		self.iterationElement = element;
		[self filterElementToEitherStringOrNumber];
	}
}

- (void) filterElementToEitherStringOrNumber
{
	if([self.iterationElement isKindOfClass:[NSString class]]) [self doNothingWithEqualOperationElement];
	else if([self.iterationElement isKindOfClass:[NSNumber class]])	[self appendNumberToDescription];
}

- (void) doNothingWithEqualOperationElement
{
	if(!([self.iterationElement isEqualToString:@"="]))
	{
		[self stripDownElementsUsingCalculatorBrainMethod];
	}
}

- (void) stripDownElementsUsingCalculatorBrainMethod
{
	self.iterationElement = [CalculatorBrain stripDownElement:self.iterationElement];
	[self filterFundamentality];
}

- (void) filterFundamentality
{
	if([self.iterationElement length] >= NON_FUNDAMENTAL_OPERATION)		[self appendNonFundamentalOperation];
	else																[self appendVariableOrFundamentalOperation];
}

- (void) appendNonFundamentalOperation
{
	self.theDescription = [[[self.iterationElement stringByAppendingString:@"( "]																		stringByAppendingString:self.theDescription] stringByAppendingString:@") "];
}

- (void) appendVariableOrFundamentalOperation
{
	self.theDescription = [self.theDescription stringByAppendingString:[self.iterationElement stringByAppendingString:@" "]];
}

- (void) appendNumberToDescription
{
	self.theDescription = [self.theDescription stringByAppendingFormat:@"%g ",[self.iterationElement doubleValue]];
}

- (NSString *)theDescription
{
	if(!theDescription)
		theDescription = [[NSString alloc] init];
	return theDescription;
}

- (void) dealloc
{
	self.theDescription = nil;
	self.iterationElement = nil;
	[super dealloc];
}

@end

@interface SolveExpression : NSObject 
{
@private
	//instances
	double theResult;
	NSDictionary *variableDictionary;
	CalculatorBrain *temporaryBrain;
	id iterationElement;
}
@property double theResult;

//methods
-(void) iterateThrough:(NSMutableArray *)theExpression;
@end

@interface SolveExpression()
//private methods
@property (nonatomic, retain) NSDictionary *variableDictionary;
@property (nonatomic, retain) CalculatorBrain *temporaryBrain;
@property (retain) id iterationElement;

-(void) filterElementToStringOrNumber;
-(void) filterStringToOperationOrVariable;
-(void) peformOperationAndSetResult;
-(void) setOperandInCalculatorBrainToElement;
-(void) setOperandInCalculatorBrainAsVariableValue;
@end

@implementation SolveExpression
@synthesize theResult, variableDictionary, temporaryBrain, iterationElement;

-(void) iterateThrough:(NSMutableArray *)theExpression
{
	for (id element in theExpression)
	{
		self.iterationElement = element;
		[self filterElementToStringOrNumber];
	}
}

-(void) filterElementToStringOrNumber
{
	if([self.iterationElement isKindOfClass:[NSNumber class]])		[self setOperandInCalculatorBrainToElement];
	else if([self.iterationElement isKindOfClass:[NSString class]])		[self filterStringToOperationOrVariable];
}

-(void) filterStringToOperationOrVariable
{
	if([self.iterationElement length] == VARIABLE)	[self setOperandInCalculatorBrainAsVariableValue];
	else											[self peformOperationAndSetResult];
}

-(void) peformOperationAndSetResult
{
	self.theResult = [self.temporaryBrain performOperation:self.iterationElement];
}

-(void) setOperandInCalculatorBrainToElement
{
	self.temporaryBrain.operand = [self.iterationElement doubleValue];
}

-(void) setOperandInCalculatorBrainAsVariableValue
{
	self.temporaryBrain.operand = [[self.variableDictionary objectForKey:[CalculatorBrain stripDownElement:self.iterationElement]]
								   doubleValue];
}


-(CalculatorBrain *)temporaryBrain
{
	if (!temporaryBrain)
		temporaryBrain = [[CalculatorBrain alloc] init];
	return temporaryBrain;
}

-(NSDictionary *)variableDictionary
{
	if (!variableDictionary)
		variableDictionary = [[NSDictionary alloc] init];
	return variableDictionary;
}

-(void)dealloc
{
	self.temporaryBrain = nil;
	self.variableDictionary = nil;
	self.iterationElement = nil;
	[super dealloc];
}
@end

@interface CalculatorBrain()

@property (copy) NSString *waitingOperation;
@property double waitingOperand;
@property double memoryOperand;
@property (retain, nonatomic) NSMutableArray *internalExpression;

+ (NSString *)checkNonFundamentalOperationFor:(NSString *)thisString;
+ (NSMutableSet *)iterateThroughExpression:(NSMutableArray *)anExpression andAddVariablesTo:(NSMutableSet *)set;

@end

@implementation CalculatorBrain
@synthesize operand, waitingOperand, waitingOperation, memoryOperand, internalExpression;

////////////////
//
+ (id)propertyListForExpression:(id)anExpression
{
	if([anExpression isMemberOfClass:[NSMutableArray class]])	[anExpression autorelease];
	else														 anExpression = nil;
	return anExpression;
}

+ (id)expressionForPropertyList:(id)propertyList
{
	if([propertyList isMemberOfClass:[NSMutableArray class]])	[propertyList autorelease];
	else														 propertyList = nil;
	return propertyList;
}

+ (id)lastItemInExpression:(id)anExpression
{
	id temp = nil;
	if([anExpression isKindOfClass:[NSMutableArray class]])		temp = [anExpression lastObject];
	return temp;
}

- (NSMutableArray *)internalExpression
{
	if (!internalExpression)	internalExpression = [[NSMutableArray alloc] init];
	return internalExpression;
}

- (id)expression
{
	NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.internalExpression copyItems:YES];
	[temp autorelease];
	return temp;
}

- (void)addNumber:(NSString *)number andOperation:(NSString *)operation
{
	if(number)	[self.internalExpression addObject:[NSNumber numberWithDouble:[number doubleValue]]];
	[self.internalExpression addObject:operation];
}

- (void)setVariableAsOperand:(NSString *)variableName
{
	//implement
	NSString *vp = VARIABLE_PREFIX;
	[self addNumber:nil andOperation:[vp stringByAppendingString:variableName]];
}
//
////////////////


////////////////
//
+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables
{
	SolveExpression *solver = [[[SolveExpression alloc] init] autorelease];
	solver.variableDictionary = variables;
	if([anExpression isKindOfClass:[NSMutableArray class]])		[solver iterateThrough:anExpression];
	return solver.theResult;
}
//
////////////////


////////////////
//
+ (NSString *)stripDownElement:(NSString *)string
{
	if([string length] == VARIABLE)
		string = [NSString stringWithFormat:@"%c",[string characterAtIndex:([string length]-1)]];
	else if([string length] >= NON_FUNDAMENTAL_OPERATION)	string = [CalculatorBrain checkNonFundamentalOperationFor:string];
	return string;
}

+ (NSString *)checkNonFundamentalOperationFor:(NSString *)thisString
{
	if ([thisString isEqualToString:@"+/-"])			thisString = @"(-)";
	else if ([thisString isEqualToString:@"1/x"])		thisString = @"1 /";
	return thisString;
}
//
////////////////


////////////////
//
+ (NSSet *)variablesInExpression:(id)anExpression
{
	NSMutableSet *set = [NSMutableSet setWithCapacity:3];
	if([anExpression isKindOfClass:[NSMutableArray class]])		set = [self iterateThroughExpression:anExpression andAddVariablesTo:set];
	return set;
}

+ (NSMutableSet *)iterateThroughExpression:(NSMutableArray *)anExpression andAddVariablesTo:(NSMutableSet *)set
{
	for (id element in anExpression)
		if(([element isKindOfClass:[NSString class]]) && ([element length] == 2))	[set addObject:element];
	if ([set count] == 0) set = nil;
	return set;
}
//
////////////////



////////////////
//
+ (NSString *)descriptionOfExpression:(id)anExpression
{	
	DescriptionOfExpression *descriptionExpression = [[[DescriptionOfExpression alloc] init] autorelease]; 
	if([anExpression isKindOfClass:[NSMutableArray class]])
		[descriptionExpression compileDescriptionByIteratingThrough:anExpression];
	return descriptionExpression.theDescription;
}
//
////////////////


////////////////
//
- (double)performWaitingOperation
{
	if([@"+" isEqualToString:self.waitingOperation])
	{
		self.operand = self.waitingOperand + self.operand;
	}
	else if([@"-" isEqualToString:self.waitingOperation])
	{
		self.operand = self.waitingOperand - self.operand;
	}
	else if([@"*" isEqualToString:self.waitingOperation])
	{
		self.operand = self.waitingOperand * self.operand;
	}
	else if([@"/" isEqualToString:self.waitingOperation])
	{
		if(self.operand)
			self.operand = self.waitingOperand / self.operand;
	}
	return self.operand;
}

- (double)performOperation:(NSString *)operation
{	
	//flow through operation strings to determine which operation to perform
	if ([operation isEqualToString:@"sqrt"])
	{
		self.operand = sqrt(self.operand);
	}
	else if ([operation isEqualToString:@"+/-"])
	{
		self.operand = (-1.0)*(self.operand);
	}
	else if ([operation isEqualToString:@"1/x"])
	{
		if(self.operand)
			self.operand = 1/self.operand;
	}
	else if ([operation isEqualToString:@"sin"])
	{
		self.operand = sin(self.operand*M_PI/180);
	}
	else if ([operation isEqualToString:@"cos"])
	{
		self.operand = cos(self.operand*M_PI/180);
	}
	else if([operation isEqualToString:@"clear"])
	{
		self.waitingOperand = 0.0;
		self.waitingOperation = nil;
		[self.internalExpression removeAllObjects];
	}
	else
	{
		[self performWaitingOperation];
		self.waitingOperation = operation;
		self.waitingOperand = self.operand;
	}
	return self.operand;
}
//
////////////////


////////////////
//
- (double)performMemoryOperation:(NSString *)operation toStore:(NSString *)store
{
	
	if([@"Store" isEqualToString:operation])
	{
		self.memoryOperand = [store doubleValue];
	}
	else if([@"Mem +" isEqualToString:operation])
	{
		self.memoryOperand += [store doubleValue];
	}
	return self.memoryOperand;
}
//
////////////////

- (void) dealloc
{
	self.internalExpression = nil;
	self.waitingOperation = nil;
	[super dealloc];
}


@end
