//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jinwoo Baek on 8/5/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject
{
	@private
	double operand;
	double waitingOperand;
	double memoryOperand;
	NSString *waitingOperation;
	NSMutableArray *internalExpression;	
}


@property double operand;
@property (readonly) id expression;

+(double) evaluateExpression:(id) anExpression usingVariableValues:(NSDictionary *) variables;
+(NSSet *) variablesInExpression:(id) anExpression;
+(NSString *) descriptionOfExpression:(id) anExpression;
+(id) propertyListForExpression:(id) anExpression;
+(id) expressionForPropertyList:(id) propertyList;
+(id) lastItemInExpression:(id) anExpression;
+(NSString *) stripDownElement:(NSString *) string;

-(double) performOperation:(NSString *) operation;
-(double) performMemoryOperation:(NSString *) operation toStore:(NSString *) store;
-(void) setVariableAsOperand:(NSString *) variableName;
-(void) toExpression_Add:(NSString *) number andAlsoAdd:(NSString *) operation;
-(void) clearOperations;



@end
