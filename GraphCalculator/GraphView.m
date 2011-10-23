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
@property CGContextRef contextForPlot;
@property (retain) NSArray *arrayOfRangeValuesForPlot;

-(void) drawPlotOfExpression;
-(void) setScaleRatioToContentScaleRatioOrOne;
-(void) usingTheDelegateMethod_SetArrayOfRangeValuesForPlot;
-(BOOL) checkWhetherExpressionIsDefinedInGraphCalculatorController;
-(void) contextSetupPriorToDrawingThePlot;
-(void) retrieveCurrentContextAndPushContext;
-(void) setupTheInitialConditionOfThePlotPath;
-(void) notifyContextThatPathPlottingWillBegin;
-(void) moveToTheInitialPointOfThePlotToCommenceLineDrawing;
-(void) setStrokeOfThePlotToRedColor;
-(void) loopThroughTheRangeValuesGivenByTheDelegateToPlotTheExpression;
-(void) connectTheLinesBetweenCoordinatesThatCorrespondsToTheFollowing:(float) xIteration;
-(void) addLineToTheFollowing:(CGPoint)point;
-(void) finishOffThePlottingContext;
-(void) fillInTheStrokePathDefinedByThePreviousLoop;
@end

@implementation GraphView
@synthesize pointsPerUnit, origin, x_delta, y_delta;
@synthesize scaleRatioForPlot, contextForPlot, arrayOfRangeValuesForPlot;
@synthesize delegate;

-(void)drawRect:(CGRect)rect
{
	[AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.pointsPerUnit];
	[self drawPlotOfExpression];
}

////////////////
////////////////
//
-(void) drawPlotOfExpression
{
	[self setScaleRatioToContentScaleRatioOrOne];
	[self usingTheDelegateMethod_SetArrayOfRangeValuesForPlot];
	if ([self checkWhetherExpressionIsDefinedInGraphCalculatorController])
		return;
	[self contextSetupPriorToDrawingThePlot];
	[self loopThroughTheRangeValuesGivenByTheDelegateToPlotTheExpression];
	[self finishOffThePlottingContext];
}
	-(void) setScaleRatioToContentScaleRatioOrOne
	{
		self.scaleRatioForPlot = 1.0;
		if ([self respondsToSelector:@selector(setContentScaleFactor)]) 
			self.scaleRatioForPlot = self.contentScaleFactor;
	}
	-(void) usingTheDelegateMethod_SetArrayOfRangeValuesForPlot
	{
		self.arrayOfRangeValuesForPlot = [self.delegate evaluateMultipleDomainValuezCorrespondingExpressionSolutionFor:self];
	}
	-(BOOL) checkWhetherExpressionIsDefinedInGraphCalculatorController
	{
		return ([self.arrayOfRangeValuesForPlot count] == 0);
	}
	-(void) contextSetupPriorToDrawingThePlot
	{
		[self retrieveCurrentContextAndPushContext];
		[self setupTheInitialConditionOfThePlotPath];
		[self setStrokeOfThePlotToRedColor];
	}
		-(void) retrieveCurrentContextAndPushContext 
		{
			self.contextForPlot = UIGraphicsGetCurrentContext();
			UIGraphicsPushContext(self.contextForPlot);
		}
		-(void) setupTheInitialConditionOfThePlotPath
		{
			[self notifyContextThatPathPlottingWillBegin];
			[self moveToTheInitialPointOfThePlotToCommenceLineDrawing];
		}
			-(void) notifyContextThatPathPlottingWillBegin
			{
				CGContextBeginPath(self.contextForPlot);
			}
			-(void) moveToTheInitialPointOfThePlotToCommenceLineDrawing
			{
				int yPoint = (self.bounds.size.height / 2) + self.y_delta - [[self.arrayOfRangeValuesForPlot objectAtIndex:0] doubleValue] * self.pointsPerUnit;
				CGContextMoveToPoint(self.contextForPlot, 0, yPoint);
			}
		-(void) setStrokeOfThePlotToRedColor
		{
			[[UIColor redColor] setStroke];
		}
	-(void) loopThroughTheRangeValuesGivenByTheDelegateToPlotTheExpression
	{
		for (float xIteration = 1; xIteration < [self.arrayOfRangeValuesForPlot count]; xIteration++) 
			[self connectTheLinesBetweenCoordinatesThatCorrespondsToTheFollowing:xIteration];
	}
		-(void) connectTheLinesBetweenCoordinatesThatCorrespondsToTheFollowing:(float) xIteration
		{
			CGFloat yPoint =
			(self.bounds.size.height / 2.0) + self.y_delta - [[self.arrayOfRangeValuesForPlot objectAtIndex:xIteration] doubleValue] * self.pointsPerUnit;
			CGFloat xPoint = xIteration / self.scaleRatioForPlot;
			[self addLineToTheFollowing:(CGPoint)CGPointMake(xPoint, yPoint)];
		}
			-(void) addLineToTheFollowing:(CGPoint)point
			{
				CGContextAddLineToPoint(self.contextForPlot, point.x, point.y);
			}
	-(void) finishOffThePlottingContext
	{
		[self fillInTheStrokePathDefinedByThePreviousLoop];
		UIGraphicsPopContext();
	}
		-(void) fillInTheStrokePathDefinedByThePreviousLoop
		{
			CGContextStrokePath(self.contextForPlot);
		}
//
////////////////
////////////////

-(CGPoint) origin
{
	return CGPointMake(X_MIDPOINT + self.x_delta, Y_MIDPOINT + self.y_delta);
}

-(CGFloat) pointsPerUnit
{
	if (!pointsPerUnit)
		pointsPerUnit = DEFAULT_SCALE_VALUE;
	return pointsPerUnit;
}

-(void) dealloc
{
	[arrayOfRangeValuesForPlot release];
	[super dealloc];
}

@end