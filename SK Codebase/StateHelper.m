//
//  StateHelper.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StateHelper.h"
#import "SKDataSource.h"
#include "Constants.h"

@implementation StateHelper

+ (NSInteger)getPresentedStatus:(SKDataSource*)ds
{
    NSInteger status = DATA_SOURCE__PRESENTED_STATUS__BAD;
    
    NSLog(@"%@", ds.Name);
NSLog(@"%@", ds.UsedValue);
    NSLog(@"%@", ds.UsedValueStatus);
    
    //Status for used value
    if (ds.UsedValue != nil && ![ds.UsedValue isEqualToString:@""]) {
        NSInteger usedValueStatus = [StateHelper getDataSourceValueStatusFromString:ds.UsedValueStatus];
        
        status = [StateHelper getPresentedDataSourceStatusFromDataSourceValueStatus:usedValueStatus];
        
        if ([ds.UsedValueIsFailureValue isEqualToString:XML_VALUE__TRUE]) {
            return DATA_SOURCE__PRESENTED_STATUS__BAD;
        }
    } else if (ds.LastValue != nil && ![ds.LastValue isEqualToString:@""]) {
        return DATA_SOURCE__PRESENTED_STATUS__BAD;
    } else {
        NSInteger dsStatus = [StateHelper getDataSourceStatusFromString:ds.Status];
        
        switch (dsStatus) {
            case DATA_SOURCE__STATUS__FAILURE:
                status = DATA_SOURCE__PRESENTED_STATUS__BAD;
                break;
            case DATA_SOURCE__STATUS__EXCEPTION:
                status = DATA_SOURCE__PRESENTED_STATUS__BAD;
                break;
            default:
                status = DATA_SOURCE__PRESENTED_STATUS__UNKNOWN;
                break;
        }
        
        return status;
    }
    
    if ((status == DATA_SOURCE__PRESENTED_STATUS__GOOD) && ds.LastValue != nil && ![ds.LastValue isEqualToString:@""]) {
        //The used value is Good, but used value may not be the last collected value
        //Check if last collected value is valid. If not, then degrade to a warning
        NSInteger lastValueStatus = [StateHelper getDataSourceValueStatusFromString:ds.LastValueStatus];
        status = [StateHelper getPresentedDataSourceStatusFromDataSourceValueStatus:lastValueStatus];
        
        if (status != DATA_SOURCE__PRESENTED_STATUS__GOOD) {
            status = DATA_SOURCE__PRESENTED_STATUS__DEGRADED;
        }
    }
    
    NSLog(@"%i", status);
    
    return status;
}

+ (NSInteger)getDataSourceStatusFromString:(NSString*)status {
    if (status == nil || [status isEqualToString:@""]) {
        return DATA_SOURCE__STATUS__UNKNOWN;
    } else if([status isEqualToString:DATA_SOURCE__STATUS_STRING__SUCCESS]) {
        return DATA_SOURCE__STATUS__SUCCESS;
    } else if([status isEqualToString:DATA_SOURCE__STATUS_STRING__FAILURE]) {
        return DATA_SOURCE__STATUS__FAILURE;
    } else if([status isEqualToString:DATA_SOURCE__STATUS_STRING__EXCEPTION]) {
        return DATA_SOURCE__STATUS__EXCEPTION;
    } else {
        return DATA_SOURCE__STATUS__UNKNOWN;
    }
}

+ (NSInteger)getDataSourceValueStatusFromString:(NSString*)status {
    if (status == nil || [status isEqualToString:@""]) {
        return DATA_SOURCE__VALUE_STATUS__UNKNOWN;
    } else if([status isEqualToString:DATA_SOURCE__VALUE_STATUS_STRING__OK]) {
        return DATA_SOURCE__VALUE_STATUS__OK;
    } else if([status isEqualToString:DATA_SOURCE__VALUE_STATUS_STRING__EXPIRED]) {
        return DATA_SOURCE__VALUE_STATUS__EXPIRED;
    } else if([status isEqualToString:DATA_SOURCE__VALUE_STATUS_STRING__OUT_OF_RANGE]) {
        return DATA_SOURCE__VALUE_STATUS__OUT_OF_RANGE;
    } else if([status isEqualToString:DATA_SOURCE__VALUE_STATUS_STRING__NO_VALUE_STORED]) {
        return DATA_SOURCE__VALUE_STATUS__NO_VALUE_STORED;
    } else if([status isEqualToString:DATA_SOURCE__VALUE_STATUS_STRING__ERROR_PARSING]) {
        return DATA_SOURCE__VALUE_STATUS__ERROR_PARSING;
    } else if([status isEqualToString:DATA_SOURCE__VALUE_STATUS_STRING__EXCEPTION]) {
        return DATA_SOURCE__VALUE_STATUS__EXCEPTION;
    } else if([status isEqualToString:DATA_SOURCE__VALUE_STATUS_STRING__NOT_COLLECTED]) {
        return DATA_SOURCE__VALUE_STATUS__NOT_COLLECTED;
    } else {
        return DATA_SOURCE__VALUE_STATUS__UNKNOWN;
    }
}

+ (NSInteger)getPresentedDataSourceStatusFromDataSourceValueStatus:(NSInteger)dsvStatus {
    if (dsvStatus == DATA_SOURCE__VALUE_STATUS__UNKNOWN) {
        return DATA_SOURCE__PRESENTED_STATUS__UNKNOWN;
    } else if (dsvStatus == DATA_SOURCE__VALUE_STATUS__OK) {
        return DATA_SOURCE__PRESENTED_STATUS__GOOD;
    } else if (dsvStatus == DATA_SOURCE__VALUE_STATUS__ERROR_PARSING) {
        return DATA_SOURCE__PRESENTED_STATUS__BAD;
    } else if (dsvStatus == DATA_SOURCE__VALUE_STATUS__EXPIRED) {
        return DATA_SOURCE__PRESENTED_STATUS__BAD;
    } else if (dsvStatus == DATA_SOURCE__VALUE_STATUS__EXCEPTION) {
        return DATA_SOURCE__PRESENTED_STATUS__BAD;
    } else if (dsvStatus == DATA_SOURCE__VALUE_STATUS__NOT_COLLECTED) {
        return DATA_SOURCE__PRESENTED_STATUS__BAD;
    } else if (dsvStatus == DATA_SOURCE__VALUE_STATUS__NO_VALUE_STORED) {
        return DATA_SOURCE__PRESENTED_STATUS__BAD;
    } else if (dsvStatus == DATA_SOURCE__VALUE_STATUS__OUT_OF_RANGE) {
        return DATA_SOURCE__PRESENTED_STATUS__BAD;
    } else {
        return DATA_SOURCE__PRESENTED_STATUS__UNKNOWN;
    }
}

@end
