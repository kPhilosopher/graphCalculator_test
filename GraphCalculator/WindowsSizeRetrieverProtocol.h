//
//  WindowsSizeRetrieverProtocol.h
//  GraphCalculator
//
//  Created by Jinwoo Baek on 10/17/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol WindowsSizeRetrieverProtocol

-(CGRect)getCurrentWindowsCGRect:(UIViewController *) requestor;

@end