//
//  GraphCalculatorViewController.m
//  GraphCalculator
//
//  Created by Jinwoo Baek on 9/20/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//
#import "GraphCalculatorViewController.h"

@interface EvaluateExpressionzRangeValuesForPlot : NSObject
{
@private
	GraphView *requestor;
	id expressionToEvaluate;
	CGFloat unitsPerPixel;
	CGFloat xValueAtPixel;
	CGFloat deltaPixelValueFromYAxis;
	NSMutableArray *valuesOfTheRange;
}

@end

@interface EvaluateExpressionzRangeValuesForPlot()

@property (retain) id expressionToEvaluate;
@property (nonatomic ,retain) GraphView *requestor;

@property CGFloat unitsPerPixel;
@property CGFloat deltaPixelValueFromYAxis;
@property CGFloat xValueAtPixel;
@property (nonatomic,retain) NSMutableArray *valuesOfTheRange;

-(BOOL) returnNOIfExpressionIsEmpty:(id) expression;
-(void) setPixelRelatedFloatingValuesWithGivenInformationForRangeValueCalculation;
-(void) setPixelCountUsingGraphViewBoundsAndScaleRatio;
-(void) setUnitsPerPixelFloatingValue;
-(void) setLeftMostUnitValueForTheInitialPointForRangeValueEvaluation;
-(void) collectRangeValuesForEachCorrespondingDomainValueBySpanningTheXAxis;
-(void) evaluateTheExpressionzRangeValueForTheCorrespondingXValue;
-(void) incrementBy_UnitPerPixel;
@end

@implementation EvaluateExpressionzRangeValuesForPlot
@synthesize requestor, expressionToEvaluate;
@synthesize unitsPerPixel, xValueAtPixel, deltaPixelValueFromYAxis;
@synthesize valuesOfTheRange;

////////////////
////////////////
//
-(id) initWith:(id) expression given:(GraphView *) requestorLink
{
	[super init];
	if ([self returnNOIfExpressionIsEmpty:(id) expression]) 
	{
		self.expressionToEvaluate = expression;
		self.requestor = requestorLink;
		[self setPixelRelatedFloatingValuesWithGivenInformationForRangeValueCalculation];
		[self collectRangeValuesForEachCorrespondingDomainValueBySpanningTheXAxis];
	}
	return self;
}
	-(BOOL) returnNOIfExpressionIsEmpty:(id) expression
	{
		return !([expression count] == 0);
	}
	-(void) setPixelRelatedFloatingValuesWithGivenInformationForRangeValueCalculation
	{
		[self setPixelCountUsingGraphViewBoundsAndScaleRatio];
		[self setUnitsPerPixelFloatingValue];
		[self setLeftMostUnitValueForTheInitialPointForRangeValueEvaluation];
	}
		-(void) setPixelCountUsingGraphViewBoundsAndScaleRatio 
		{
			self.deltaPixelValueFromYAxis = self.requestor.origin.x * self.requestor.scaleRatioForPlot;
		}
		-(void) setUnitsPerPixelFloatingValue
		{
			self.unitsPerPixel = 1/(self.requestor.pointsPerUnit * self.requestor.scaleRatioForPlot);
		}
		-(void) setLeftMostUnitValueForTheInitialPointForRangeValueEvaluation
		{
			self.xValueAtPixel = -self.unitsPerPixel * self.deltaPixelValueFromYAxis;
		}

	-(void) collectRangeValuesForEachCorrespondingDomainValueBySpanningTheXAxis
	{
		for (int count = 0; count < (self.requestor.bounds.size.width * self.requestor.scaleRatioForPlot); count++) 
			[self evaluateTheExpressionzRangeValueForTheCorrespondingXValue];
	}
		-(void) evaluateTheExpressionzRangeValueForTheCorrespondingXValue
		{
			NSDictionary *dictionaryForXValue = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:self.xValueAtPixel] forKey:@"x"];
			[self.valuesOfTheRange addObject: [NSNumber numberWithDouble:[CalculatorBrain evaluateExpression:self.expressionToEvaluate
																						 usingVariableValues:dictionaryForXValue]]];
			[self incrementBy_UnitPerPixel];
		}
			-(void) incrementBy_UnitPerPixel
			{
				self.xValueAtPixel += self.unitsPerPixel;	
			}
//
////////////////
////////////////

-(NSMutableArray *)valuesOfTheRange
{
	if (!valuesOfTheRange)
		valuesOfTheRange = [[NSMutableArray alloc] init];;
	return valuesOfTheRange;
}

-(void) dealloc
{
	self.expressionToEvaluate = nil;
	[valuesOfTheRange release];
	[requestor release];
	[super dealloc];
}

@end

@interface GraphCalculatorViewController()
@property (retain) GraphView *graphView;
-(void) setGraphVariableValuesFromUserSettings;

-(void) pinch:(UIPinchGestureRecognizer *)gesture;
	-(void) changePointsPerUnitOfGraphViewProportionalToTheScaleChangeInducedByPinchingWith:(UIPinchGestureRecognizer *)gesture;
		-(void) resetGestureScaleForNextScaling:(UIPinchGestureRecognizer *)gesture;

-(void) pan:(UIPanGestureRecognizer *)gesture;
	-(void) translateTheOriginValueByDisplacingTheDeltaValues:(UIPanGestureRecognizer *)gesture;

-(void) tap:(UITapGestureRecognizer *)gesture;
	-(void) translateTheOriginValueBySettingTheDeltaValuesToZero;
-(void) saveTheChangedUserSettingsToPreferences;
-(void) addGestureRecognizersToGraphView;
	-(void) setUp_Pinch_GestureRecognizerForGraphView;
	-(void) setUp_Pan_GestureRecognizerForGraphView;
	-(void) setUp_Tap_GestureRecognizerForGraphView;
@end

@implementation GraphCalculatorViewController
@synthesize expressionToEvaluate, graphView, windowsSizeRetrieverDelegate;

-(NSArray *) evaluateMultipleDomainValuezCorrespondingExpressionSolutionFor: (GraphView *)requestor
{
	EvaluateExpressionzRangeValuesForPlot *evaluator = [[[EvaluateExpressionzRangeValuesForPlot alloc] initWith:self.expressionToEvaluate given:self.graphView] autorelease];
	return evaluator.valuesOfTheRange;
}

////////////////
////////////////
//
-(void) pinch:(UIPinchGestureRecognizer *)gesture
{
	if((gesture.state == UIGestureRecognizerStateChanged) ||
	   (gesture.state == UIGestureRecognizerStateEnded))
	{
		[self changePointsPerUnitOfGraphViewProportionalToTheScaleChangeInducedByPinchingWith:gesture];
	}
	[self saveTheChangedUserSettingsToPreferences];
	[self.graphView setNeedsDisplay];
}
	-(void) changePointsPerUnitOfGraphViewProportionalToTheScaleChangeInducedByPinchingWith:(UIPinchGestureRecognizer *)gesture
	{
		self.graphView.pointsPerUnit *= gesture.scale;
		[self resetGestureScaleForNextScaling:gesture];
	}
		-(void) resetGestureScaleForNextScaling:(UIPinchGestureRecognizer *)gesture
		{
			gesture.scale = 1;
		}

-(void) pan:(UIPanGestureRecognizer *)gesture
{
	if((gesture.state == UIGestureRecognizerStateChanged) ||
	   (gesture.state == UIGestureRecognizerStateEnded))
	{
		[self translateTheOriginValueByDisplacingTheDeltaValues:(UIPanGestureRecognizer *)gesture];
	}
	[self saveTheChangedUserSettingsToPreferences];
	[self.graphView setNeedsDisplay];
}
	-(void) translateTheOriginValueByDisplacingTheDeltaValues:(UIPanGestureRecognizer *)gesture
	{
		self.graphView.x_delta = self.graphView.x_delta + [gesture translationInView:self.graphView].x/10;
		self.graphView.y_delta = self.graphView.y_delta + [gesture translationInView:self.graphView].y/10;
	}

-(void) tap:(UITapGestureRecognizer *)gesture
{
	[self translateTheOriginValueBySettingTheDeltaValuesToZero];
	[self saveTheChangedUserSettingsToPreferences];
	[self.graphView setNeedsDisplay];
}
	-(void) translateTheOriginValueBySettingTheDeltaValuesToZero
	{
		self.graphView.x_delta = 0;
		self.graphView.y_delta = 0;
	}

-(void) saveTheChangedUserSettingsToPreferences
{
	[[NSUserDefaults standardUserDefaults] setFloat:self.graphView.x_delta forKey:@"x_delta"];
	[[NSUserDefaults standardUserDefaults] setFloat:self.graphView.y_delta forKey:@"y_delta"];
	[[NSUserDefaults standardUserDefaults] setFloat:self.graphView.pointsPerUnit forKey:@"pointsPerUnit"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
//
////////////////
////////////////

////////////////
////////////////
//
- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController
{
}

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc
{
	barButtonItem.title = aViewController.title;
	self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
	self.navigationItem.rightBarButtonItem = nil;
}
//
////////////////
////////////////

#pragma mark - View lifecycle

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	[self loadView];
	[self viewDidLoad];
	return YES;
}

-(void) loadView
{
	self.view =  [[GraphView alloc] initWithFrame:[self.windowsSizeRetrieverDelegate getCurrentWindowsCGRect:self]];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	self.graphView = (GraphView *) self.view;
	self.graphView.delegate = self;
	[self setGraphVariableValuesFromUserSettings];
}
	-(void) setGraphVariableValuesFromUserSettings
	{
		self.graphView.x_delta = [[NSUserDefaults standardUserDefaults] floatForKey:@"x_delta"];
		self.graphView.y_delta = [[NSUserDefaults standardUserDefaults] floatForKey:@"y_delta"];
		self.graphView.pointsPerUnit = [[NSUserDefaults standardUserDefaults] floatForKey:@"pointsPerUnit"];
	}

////////////////
////////////////
//
-(void)viewDidLoad
{
	[self addGestureRecognizersToGraphView];
}
	-(void) addGestureRecognizersToGraphView
	{
		[self setUp_Pinch_GestureRecognizerForGraphView];
		[self setUp_Pan_GestureRecognizerForGraphView];
		[self setUp_Tap_GestureRecognizerForGraphView];
	}
		-(void) setUp_Pinch_GestureRecognizerForGraphView
		{
			UIPinchGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
			[self.graphView addGestureRecognizer:pinchgr];
			[pinchgr release];
		}
		-(void) setUp_Pan_GestureRecognizerForGraphView
		{
			UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
			pangr.maximumNumberOfTouches = 1;
			[self.graphView addGestureRecognizer:pangr];
			[pangr release];
		}
		-(void) setUp_Tap_GestureRecognizerForGraphView
		{
			UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
			tapgr.numberOfTapsRequired = 2;
			[self.graphView addGestureRecognizer:tapgr];
			[tapgr release];
		}
//
////////////////
////////////////

-(void) viewDidUnload
{
	self.graphView = nil;
}

-(void) dealloc
{
	self.windowsSizeRetrieverDelegate = nil;
	self.expressionToEvaluate = nil;
	[graphView release];
	[super dealloc];
}

@end
