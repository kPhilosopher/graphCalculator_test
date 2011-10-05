//
//  GraphView.m
//  GraphCalculator
//
//  Created by Jinwoo Baek on 9/20/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import "GraphView.h"
#define	DEFAULT_SCALE_VALUE 20

#define X_MIDPOINT self.bounds.size.width/2
#define Y_MIDPOINT self.bounds.size.height/2

@interface GraphView ()

@property (retain) IBOutlet id <GraphViewDelegate> delegate;

- (void) drawGraphOfExpression;
@end

@implementation GraphView
@synthesize pointsPerUnit, origin;
@synthesize delegate;

- (void)drawRect:(CGRect)rect
{
	
	[AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.pointsPerUnit];
	[self drawGraphOfExpression];
}

- (void)changePointsPerUnitWith:(int) positiveOrNegativeUnit
{
	self.pointsPerUnit = self.pointsPerUnit * ((3.0 + positiveOrNegativeUnit) / 3.0);
	[self setNeedsDisplay];
}

- (void) drawGraphOfExpression
{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	
	NSArray *arrayOfRangeValues = [self.delegate evaluateExpressionFor:self];
	int yPoint = (self.bounds.size.height / 2) - [[arrayOfRangeValues objectAtIndex:0] doubleValue] * self.pointsPerUnit;
	CGContextMoveToPoint(context, 0, yPoint);
	
	for (int xPoint = 1; xPoint < [arrayOfRangeValues count]; xPoint++) 
	{
		int yPoint = (self.bounds.size.height / 2) - [[arrayOfRangeValues objectAtIndex:xPoint] doubleValue] * self.pointsPerUnit;
		CGContextAddLineToPoint(context, xPoint, yPoint);
	}
	
	[[UIColor redColor] setStroke];
	CGContextStrokePath(context);
	
	UIGraphicsPopContext();
}



- (CGFloat) pointsPerUnit
{
	if (!pointsPerUnit)
		self.pointsPerUnit = DEFAULT_SCALE_VALUE;
	return pointsPerUnit;
}

- (CGPoint) origin
{
	return CGPointMake(X_MIDPOINT, Y_MIDPOINT);
}

@end
