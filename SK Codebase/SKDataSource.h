//
//  SKDataSource.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKGroupableEntity.h"

@interface SKDataSource : SKGroupableEntity

//------------------------------------------------------------
// Behavior properties
@property (nonatomic, copy) NSString *EvalMinMax;
@property (nonatomic, copy) NSString *PollScheduleRate;
@property (nonatomic, copy) NSString *PollScheduleType;
@property (nonatomic, copy) NSString *PollScheduleValue;

//------------------------------------------------------------
// State properties
@property (nonatomic, copy) NSString *Enabled;
@property (nonatomic, copy) NSString *NextRun;
@property (nonatomic, copy) NSString *Status;

@property (nonatomic, copy) NSString *LastRun;
@property (nonatomic, copy) NSString *LastValue;
@property (nonatomic, copy) NSString *LastValueAdditionalData;
@property (nonatomic, copy) NSString *LastValueDebugInfo;
@property (nonatomic, copy) NSString *LastValueExpires;
@property (nonatomic, copy) NSString *LastValueIsFailureValue;
@property (nonatomic, copy) NSString *LastValueLocalTimestamp;
@property (nonatomic, copy) NSString *LastValueStatus;
@property (nonatomic, copy) NSString *LastValueTimestamp;

@property (nonatomic, copy) NSString *UsedValue;
@property (nonatomic, copy) NSString *UsedValueAdditionalData;
@property (nonatomic, copy) NSString *UsedValueDebugInfo;
@property (nonatomic, copy) NSString *UsedValueExpires;
@property (nonatomic, copy) NSString *UsedValueIsFailureValue;
@property (nonatomic, copy) NSString *UsedValueLocalTimestamp;
@property (nonatomic, copy) NSString *UsedValueStatus;
@property (nonatomic, copy) NSString *UsedValueTimestamp;

//------------------------------------------------------------
// Presentation properties
@property (nonatomic, copy) NSString *EngineeringUnit;

@end
