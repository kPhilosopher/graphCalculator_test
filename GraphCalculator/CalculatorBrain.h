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
	
	NSString *waitingOperation;
	double waitingOperand;
	double memoryOperand;
	NSMutableArray *internalExpression;	
}


@property double operand;

//new 
@property (readonly) id expression;

- (double)performOperation:(NSString *)operation;
- (double)performMemoryOperation:(NSString *)operation toStore:(NSString *)store;//done

//new
- (void)setVariableAsOperand:(NSString *)variableName;//done
+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables;
+ (NSSet *)variablesInExpression:(id)anExpression;//done
+ (NSString *)descriptionOfExpression:(id)anExpression;//done
+ (id)propertyListForExpression:(id)anExpression;//done
+ (id)expressionForPropertyList:(id)propertyList;//done
- (void)addNumber:(NSString *)number andOperation:(NSString *)operation;//done

+ (id)lastItemInExpression:(id)anExpression;//done

+ (NSString *)stripDownString:(NSString *)stringToStrip;

@end
