//
//  GraphCalculatorViewController.m
//  GraphCalculator
//
//  Created by Jinwoo Baek on 9/20/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import "GraphCalculatorViewController.h"
#define POSITIVE_UNIT 1
#define NEGATIVE_UNIT -1


@interface GraphCalculatorViewController ()


@end

@implementation GraphCalculatorViewController
@synthesize expressionToEvaluate;

- (IBAction)changeScale:(UIButton *)sender
{
	if([self.view isKindOfClass:[GraphView class]])
	{
		GraphView *currentView = (GraphView *)self.view;
		if ([[[sender titleLabel] text] isEqualToString:@"+"])
			[currentView changePointsPerUnitWith:POSITIVE_UNIT];
		else if ([[[sender titleLabel] text] isEqualToString:@"-"])
			[currentView changePointsPerUnitWith:NEGATIVE_UNIT];
		else
		{
			NSLog(@"wrong button is linked to changeScale action method");
			return;
		}
	}
}

- (NSArray *) evaluateExpressionFor: (GraphView *)requestor
{
	CGFloat unitsPerPoint = 1/(requestor.pointsPerUnit);
	CGFloat originPointXValue;
	CGFloat numberOfPointsInPositiveDomain;
	CGFloat numberOfPointsInNegativeDomain;
	CGFloat largestXPoint = requestor.bounds.size.width - 1;
	
	CGFloat negativeStartingValue;
	
	if([self interfaceOrientation] == UIInterfaceOrientationPortrait)
	{
		originPointXValue = requestor.origin.x;
		numberOfPointsInPositiveDomain = largestXPoint - originPointXValue;
		numberOfPointsInNegativeDomain = originPointXValue;
		
		negativeStartingValue = -unitsPerPoint * numberOfPointsInNegativeDomain;
	}

	NSMutableArray *rangeValues = [[[NSMutableArray alloc] init] autorelease];
	CGFloat valueAtPoint = negativeStartingValue;
	NSDictionary *temporaryDictionary;
	
	for (int count = 0; count < numberOfPointsInNegativeDomain + 1 + numberOfPointsInPositiveDomain; count++) 
	{
		temporaryDictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:valueAtPoint],@"x",nil] autorelease];
		[rangeValues addObject:[NSNumber numberWithDouble:[CalculatorBrain evaluateExpression:self.expressionToEvaluate usingVariableValues:temporaryDictionary]]];
		
		valueAtPoint += unitsPerPoint;
	}
	return [NSArray arrayWithArray:rangeValues];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
	self.expressionToEvaluate = nil;
	[super dealloc];
}

@end
