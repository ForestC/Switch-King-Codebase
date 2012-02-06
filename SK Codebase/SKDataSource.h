//
//  SKDataSource.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKDataSource : SKEntity {
    NSString *Description;
    NSString *Enabled;
    NSString *EngineeringUnit;
    NSString *EvalMinMax;

    NSString *LastRun;
    NSString *LastValue;
    NSString *LastValueAdditionalData;
    NSString *LastValueDebugInfo;
    NSString *LastValueExpires;
    NSString *LastValueIsFailureValue;
    NSString *LastValueLocalTimestamp;
    NSString *LastValueStatus;
    NSString *LastValueTimestamp;

    NSString *UsedValue;
    NSString *UsedValueAdditionalData;
    NSString *UsedValueDebugInfo;
    NSString *UsedValueExpires;
    NSString *UsedValueIsFailureValue;
    NSString *UsedValueLocalTimestamp;
    NSString *UsedValueStatus;
    NSString *UsedValueTimestamp;

    NSString *NextRun;
    NSString *PollScheduleRate;
    NSString *PollScheduleType;
    NSString *PollScheduleValue;
    NSString *Status;

    NSInteger GroupID;
    NSString *GroupName;
}

@property (atomic, retain) NSString *Description;
@property (atomic, retain) NSString *Enabled;
@property (atomic, retain) NSString *EngineeringUnit;
@property (atomic, retain) NSString *EvalMinMax;

@property (atomic, retain) NSString *LastRun;
@property (atomic, retain) NSString *LastValue;
@property (atomic, retain) NSString *LastValueAdditionalData;
@property (atomic, retain) NSString *LastValueDebugInfo;
@property (atomic, retain) NSString *LastValueExpires;
@property (atomic, retain) NSString *LastValueIsFailureValue;
@property (atomic, retain) NSString *LastValueLocalTimestamp;
@property (atomic, retain) NSString *LastValueStatus;
@property (atomic, retain) NSString *LastValueTimestamp;

@property (atomic, retain) NSString *UsedValue;
@property (atomic, retain) NSString *UsedValueAdditionalData;
@property (atomic, retain) NSString *UsedValueDebugInfo;
@property (atomic, retain) NSString *UsedValueExpires;
@property (atomic, retain) NSString *UsedValueIsFailureValue;
@property (atomic, retain) NSString *UsedValueLocalTimestamp;
@property (atomic, retain) NSString *UsedValueStatus;
@property (atomic, retain) NSString *UsedValueTimestamp;

@property (atomic, retain) NSString *NextRun;
@property (atomic, retain) NSString *PollScheduleRate;
@property (atomic, retain) NSString *PollScheduleType;
@property (atomic, retain) NSString *PollScheduleValue;
@property (atomic, retain) NSString *Status;

@property (atomic, assign) NSInteger GroupID;
@property (atomic, retain) NSString *GroupName;

@end
