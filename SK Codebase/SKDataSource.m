//
//  SKDataSource.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKDataSource.h"

@implementation SKDataSource

//------------------------------------------------------------
// Behavior properties
@synthesize EvalMinMax;
@synthesize PollScheduleRate;
@synthesize PollScheduleType;
@synthesize PollScheduleValue;

//------------------------------------------------------------
// State properties
@synthesize Enabled;
@synthesize Status;
@synthesize NextRun;

@synthesize GroupID;
@synthesize GroupName;
@synthesize LastRun;
@synthesize LastValue;
@synthesize LastValueStatus;
@synthesize LastValueExpires;
@synthesize LastValueDebugInfo;
@synthesize LastValueTimestamp;
@synthesize LastValueAdditionalData;
@synthesize LastValueIsFailureValue;
@synthesize LastValueLocalTimestamp;

@synthesize UsedValue;
@synthesize UsedValueStatus;
@synthesize UsedValueExpires;
@synthesize UsedValueDebugInfo;
@synthesize UsedValueTimestamp;
@synthesize UsedValueAdditionalData;
@synthesize UsedValueIsFailureValue;
@synthesize UsedValueLocalTimestamp;

//------------------------------------------------------------
// Presentation properties
@synthesize EngineeringUnit;

@end
