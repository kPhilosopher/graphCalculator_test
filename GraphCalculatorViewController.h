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


@interface GraphCalculatorViewController : UIViewController <GraphViewDelegate>
{
	@private
	id expressionToEvaluate;
}

- (IBAction)changeScale:(UIButton *)sender;
@property (retain) id expressionToEvaluate;
@end
