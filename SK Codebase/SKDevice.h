//
//  SKDevice.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKGroupableEntity.h"

@interface SKDevice : SKGroupableEntity

//------------------------------------------------------------
// Identification/description properties
@property (nonatomic, copy) NSString *DeviceCode;
@property (nonatomic, copy) NSString *NativeID;

//------------------------------------------------------------
// State properties
@property (nonatomic, assign) NSInteger CurrentStateID;
@property (nonatomic, assign) NSInteger ModeID;
@property (nonatomic, copy) NSString *ModeType;
@property (nonatomic, assign) NSInteger CurrentDimLevel;
@property (nonatomic, copy) NSString *InSemiAutoMode;
@property (nonatomic, copy) NSString *Enabled;
@property (nonatomic, copy) NSString *DisabledByServer;
@property (nonatomic, assign) NSInteger ManualTargetDimLevel;
@property (nonatomic, assign) NSInteger ManualTargetStateID;

//------------------------------------------------------------
// Behavior properties
@property (nonatomic, copy) NSString *AutoSynchronizeAllowed;
@property (nonatomic, copy) NSString *SupportsAbsoluteDimLvl;

//------------------------------------------------------------
// Device type properties
@property (nonatomic, copy) NSString *TypeCategory;
@property (nonatomic, assign) NSInteger TypeID;
@property (nonatomic, copy) NSString *TypeModel;
@property (nonatomic, copy) NSString *TypeName;
@property (nonatomic, copy) NSString *TypeProtocol;

//------------------------------------------------------------
// Misc properties
@property (nonatomic, copy) NSString *OnW;
@property (nonatomic, copy) NSString *TotalkWh;

@end
