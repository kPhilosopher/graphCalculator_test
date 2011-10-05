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
- (NSArray *) evaluateExpressionFor: (GraphView *)requestor;
@end

@interface GraphView : UIView
{
	@private
	CGFloat pointsPerUnit;
	CGPoint origin;
	IBOutlet id <GraphViewDelegate> delegate;
}
- (void)changePointsPerUnitWith:(int) positiveOrNegativeUnit;
@property (nonatomic) CGFloat pointsPerUnit;
@property (nonatomic) CGPoint origin;
@end
