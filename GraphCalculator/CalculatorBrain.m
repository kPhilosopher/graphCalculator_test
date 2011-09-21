//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jinwoo Baek on 8/5/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import "CalculatorBrain.h"
#define VARIABLE_PREFIX @"%"

// Private properties
@interface CalculatorBrain()
@property (copy) NSString *waitingOperation;
@property double waitingOperand;
@property double memoryOperand;
@property (retain, nonatomic) NSMutableArray *internalExpression;
@end

@implementation CalculatorBrain
@synthesize operand, waitingOperand, waitingOperation, memoryOperand, internalExpression;

- (NSMutableArray *)internalExpression
{
	if (!internalExpression) {
		internalExpression = [[NSMutableArray alloc] init];
	}
	return internalExpression;
}

+ (NSString *)checkNonFundamentalOperation:(NSString *) operation
{
	if ([operation isEqualToString:@"+/-"])			operation = @"(-)";
	else if ([operation isEqualToString:@"1/x"])	operation = @"1/";
	return operation;
}

+ (NSString *)stripDownString:(NSString *)stringToStrip
{
	if([stringToStrip length] == 2)		stringToStrip = [NSString stringWithFormat:@"%c",
														 [stringToStrip characterAtIndex:([stringToStrip length]-1)]];
	else if([stringToStrip length] >= 3)	stringToStrip = [self checkNonFundamentalOperation:stringToStrip];
	return stringToStrip;
}

//TODO: implement and make sure to deal with division by zero.

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables
{
	double currentValue;
	
	if([anExpression isKindOfClass:[NSMutableArray class]])
	{
		CalculatorBrain *temporaryBrain = [[CalculatorBrain alloc] init];
		NSMutableArray *arrayOfExpression = (NSMutableArray *)anExpression;
		for (id element in arrayOfExpression)
		{
			
			//variables to be manipulated by the controller
			BOOL elementInThisIterationIsVariableOrNumber = NO;
			BOOL elementInThisIterationIsOperation = NO;
			double temporaryOperand;
			NSString *temporaryOperation;
			
			//controller: find out which computations to be performed
			
			if([element isKindOfClass:[NSNumber class]])
			{
				elementInThisIterationIsVariableOrNumber = YES;
				temporaryOperand = [element doubleValue];
			}
			else if([element isKindOfClass:[NSString class]])
			{
				NSString *temporaryString = (NSString *)element;
				if([temporaryString length] == 2)
				{
					elementInThisIterationIsVariableOrNumber = YES;	
					temporaryString = [CalculatorBrain stripDownString:temporaryString];
					NSNumber *number = [variables objectForKey:temporaryString];
					//go through variables dictionary to find the right variable
					temporaryOperand = [number doubleValue];
				}
				else
				{
					if([temporaryString length] == 1)
					{
						temporaryOperation = temporaryString;
						elementInThisIterationIsOperation = YES;
					}
					else if([temporaryString length] >= 3)
					{
						temporaryOperation = temporaryString;
						elementInThisIterationIsOperation = YES;
					}
				}
			}
			
			//computations
			if(elementInThisIterationIsVariableOrNumber)
			{
				temporaryBrain.operand = temporaryOperand;
			}
			else if(elementInThisIterationIsOperation)
			{
				currentValue = [temporaryBrain performOperation:temporaryOperation];
			}
		}
	}
	return currentValue;
}

+ (NSMutableSet *)iterateThroughExpression:(NSMutableArray *)anExpression andAddVariablesTo:(NSMutableSet *)set
{
	for (id element in anExpression)
		if(([element isKindOfClass:[NSString class]]) && ([element length] == 2))	[set addObject:element];
	if ([set count] == 0) set = nil;
	return set;
}

+ (NSSet *)variablesInExpression:(id)anExpression
{
	NSMutableSet *set = [NSMutableSet setWithCapacity:3];
	if([anExpression isKindOfClass:[NSMutableArray class]])		set = [self iterateThroughExpression:anExpression andAddVariablesTo:set];
	return set;
}

+ (NSString *)descriptionOfExpression:(id)anExpression
{	
	NSString *description = @"";
	if([anExpression isKindOfClass:[NSMutableArray class]])
	{
		NSMutableArray *array = (NSMutableArray *)anExpression;
		for (id element in array) {
			//variable or operation
			if([element isKindOfClass:[NSString class]])
			{
				NSString *currentString = (NSString *)element;
				
				//when the expression element is +,-,*,/,=
				if([currentString length] == 1)
				{
					if([currentString isEqualToString:@"="])
					{
						currentString = @"";
					}
					else
					{
						description = [description stringByAppendingString:[currentString stringByAppendingString:@" "]];
					}
				}
				else
				{
					currentString = [CalculatorBrain stripDownString:currentString];
					if([currentString length] >= 2)
					{
						NSString *front = [currentString stringByAppendingString:@"( "];
						description = [front stringByAppendingString:description];
						description = [description stringByAppendingString:@") "];
					}
					else
					{
						description = [description stringByAppendingString:[currentString stringByAppendingString:@" "]];
					}
				}
			}
			//when the element is a number
			else if([element isKindOfClass:[NSNumber class]])
			{
				NSNumber *currentString = (NSNumber *)element;
				description = [description stringByAppendingFormat:@"%g ",[currentString doubleValue]];
			}
		}
	}
	return description;
}

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

// Private method that does the math operation.

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

// Deals with operations related to simple math operations such as
// +, -, *, /

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


// Deals with operations related to Memory functions such as clear, Mem +, Store

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
	else if([@"clear" isEqualToString:operation])
	{
		self.memoryOperand = [store doubleValue];
	}
	return self.memoryOperand;
}

//executed when the variable button is pressed in the view

- (void)setVariableAsOperand:(NSString *)variableName
{
	//implement
	NSString *vp = VARIABLE_PREFIX;
	[self addNumber:nil andOperation:[vp stringByAppendingString:variableName]];
}


- (void) dealloc
{
	[internalExpression release];
	[waitingOperation release];
	[super dealloc];
}


@end
