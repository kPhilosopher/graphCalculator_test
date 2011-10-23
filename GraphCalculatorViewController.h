//
//  GraphCalculatorViewController.h
//  GraphCalculator
//
//  Created by Jinwoo Baek on 9/20/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "CalculatorBrain.h"
#import "WindowsSizeRetrieverProtocol.h"

@interface GraphCalculatorViewController : UIViewController <GraphViewDelegate, UISplitViewControllerDelegate>
{
	@private
	id expressionToEvaluate;
	id <WindowsSizeRetrieverProtocol> windowsSizeRetrieverDelegate;
	GraphView *graphView;
}

//-(IBAction)changeScale:(UIButton *)sender;
@property (retain) id expressionToEvaluate;
@property (retain) id <WindowsSizeRetrieverProtocol> windowsSizeRetrieverDelegate;
@end
