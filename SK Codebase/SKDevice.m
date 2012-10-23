//
//  SKDevice.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SKDevice.h"

@implementation SKDevice

//------------------------------------------------------------
// Identification/description properties
@synthesize DeviceCode;
@synthesize NativeID;

//------------------------------------------------------------
// State properties
@synthesize CurrentStateID;
@synthesize ModeID;
@synthesize ModeType;
@synthesize CurrentDimLevel;
@synthesize InSemiAutoMode;
@synthesize Enabled;
@synthesize DisabledByServer;
@synthesize ManualTargetDimLevel;
@synthesize ManualTargetStateID;

//------------------------------------------------------------
// Behavior properties
@synthesize AutoSynchronizeAllowed;
@synthesize SupportsAbsoluteDimLvl;

//------------------------------------------------------------
// Device type properties
@synthesize TypeCategory;
@synthesize TypeID;
@synthesize TypeModel;
@synthesize TypeName;
@synthesize TypeProtocol;

//------------------------------------------------------------
// Misc properties
@synthesize OnW;
@synthesize TotalkWh;

@end
