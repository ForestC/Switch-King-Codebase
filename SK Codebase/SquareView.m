//
//  SquareView.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SquareView.h"

@implementation SquareView

- (void)drawRect:(CGRect)rect;
{   
    /*
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0); // yellow line
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 50.0, 50.0); //start point
    CGContextAddLineToPoint(context, 250.0, 100.0);
    CGContextAddLineToPoint(context, 250.0, 350.0);
    CGContextAddLineToPoint(context, 50.0, 350.0); // end path
    
    CGContextClosePath(context); // close path
    
    CGContextSetLineWidth(context, 8.0); // this is set from now on until you explicitly change it
    
    CGContextStrokePath(context); // do actual stroking

    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5); // green color, half transparent
    CGContextFillRect(context, CGRectMake(20.0, 25.0, 128.0, 128.0)); // a square at the bottom left-hand corner
*/
        // get the contect
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //now draw the rounded rectangle
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.0);
//
      /*  
        //since I need room in my rect for the shadow, make the rounded rectangle a little smaller than frame
        CGRect rrect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect)-30, CGRectGetHeight(rect)-30);
        CGFloat radius = 45;
        // the rest is pretty much copied from Apples example
        CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
        CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    */
    
//    CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)

    //CGRect rrect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect)-30, CGRectGetHeight(rect)-30);
  CGRect rrect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGFloat radius = 8;
    // the rest is pretty much copied from Apples example
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    
        /*
        {
            //for the shadow, save the state then draw the shadow
            CGContextSaveGState(context);
            
            // Start at 1
            CGContextMoveToPoint(context, minx, midy);
            // Add an arc through 2 to 3
            CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
            // Add an arc through 4 to 5
            CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
            // Add an arc through 6 to 7
            CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
            // Add an arc through 8 to 9
            CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
            // Close the path
            CGContextClosePath(context);
            
            CGContextSetShadow(context, CGSizeMake(4,-5), 10);
            CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
            
            // Fill & stroke the path
            CGContextDrawPath(context, kCGPathFillStroke);
            
            //for the shadow
            CGContextRestoreGState(context);
        }
        */
        {
            // Start at 1
            CGContextMoveToPoint(context, minx, midy);
            // Add an arc through 2 to 3
            CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
            // Add an arc through 4 to 5
            CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
            // Add an arc through 6 to 7
            CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
            // Add an arc through 8 to 9
            CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
            // Close the path
            CGContextClosePath(context);
            
            CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
//            CGContextSetRGBFillColor(context, [[UIColor darkGrayColor] CGColor]);// 0.0, 0.0, 1.0, 1.0);       
            CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);// 0.0, 0.0, 1.0, 1.0);       
            
            // Fill & stroke the path
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }


@end
