//
//  SKDevice.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEntity.h"

@interface SKDevice : SKEntity {
    NSInteger GroupID;
    NSString *GroupName;
    NSInteger CurrentStateID;
    NSInteger ModeID;
    NSString *ModeType;
    NSInteger CurrentDimLevel;
    NSString *InSemiAutoMode;
    NSString *Enabled;
    
    NSString * AutoSynchronizeAllowed;
    NSString *Description;
    NSString *DeviceCode;
    NSString *DisabledByServer;
    NSInteger ManualTargetDimLevel;
    NSInteger ManualTargetStateID;
    NSString *NativeID;
    NSString *SupportsAbsoluteDimLvl;
    NSString *TypeCategory;
    NSInteger TypeID;
    NSString *TypeModel;
    NSString *TypeName;
    NSString *TypeProtocol;
}

@property (atomic, assign) NSInteger GroupID;
@property (atomic, retain) NSString *GroupName;
@property (atomic, assign) NSInteger CurrentStateID;
@property (atomic, assign) NSInteger ModeID;
@property (atomic, retain) NSString *ModeType;
@property (atomic, assign) NSInteger CurrentDimLevel;
@property (atomic, retain) NSString *InSemiAutoMode;
@property (atomic, retain) NSString *Enabled;

@property (atomic, retain) NSString *AutoSynchronizeAllowed;
@property (atomic, retain) NSString *Description;
@property (atomic, retain) NSString *DeviceCode;
@property (atomic, retain) NSString *DisabledByServer;
@property (atomic, assign) NSInteger ManualTargetDimLevel;
@property (atomic, assign) NSInteger ManualTargetStateID;
@property (atomic, retain) NSString *NativeID;
@property (atomic, retain) NSString *SupportsAbsoluteDimLvl;
@property (atomic, retain) NSString *TypeCategory;
@property (atomic, assign) NSInteger TypeID;
@property (atomic, retain) NSString *TypeModel;
@property (atomic, retain) NSString *TypeName;
@property (atomic, retain) NSString *TypeProtocol;

@end
