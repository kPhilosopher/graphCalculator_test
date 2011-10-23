//
//  GraphView.h
//  GraphCalculator
//
//  Created by Jinwoo Baek on 9/20/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@class GraphView;

@protocol GraphViewDelegate
-(NSArray *) evaluateMultipleDomainValuezCorrespondingExpressionSolutionFor: (GraphView *)requestor;
@end

@interface GraphView : UIView
{
	@private
	CGFloat pointsPerUnit;
	CGFloat x_delta;
	CGFloat y_delta;
	CGPoint origin;
	IBOutlet id <GraphViewDelegate> delegate;
	CGFloat scaleRatioForPlot;
	CGContextRef contextForPlot;
	NSArray *arrayOfRangeValuesForPlot;
}

@property (nonatomic) CGFloat pointsPerUnit;
@property (nonatomic) CGFloat x_delta;
@property (nonatomic) CGFloat y_delta;
@property (nonatomic) CGPoint origin;
@property CGFloat scaleRatioForPlot;
@property (retain) IBOutlet id <GraphViewDelegate> delegate;
@end