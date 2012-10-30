//
//  EntityGraphRequest.m
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import "EntityGraphRequest.h"
#import "Constants.h"
#import "SKEntity.h"
#import "SKEvent.h"
#import "SKDevice.h"
#import "SKScenario.h"
#import "SKSystemMode.h"
#import "SKDataSource.h"
#import "SKDeviceGroup.h"

@implementation EntityGraphRequest

@synthesize entity;
@synthesize graphSize;
@synthesize minutesBack;

// Creates a device action request for a device by using the supplied params
+ (EntityGraphRequest *)createByDataSource:(SKDataSource *)dataSource:(CGSize) graphSize:(NSInteger) minutesBack; {
    
    EntityGraphRequest *r = [EntityGraphRequest alloc];
    
    r.entity = dataSource;
    r.graphSize = graphSize;
    r.minutesBack = minutesBack;
    
    return r;
}

- (EntityGraphNotificationData *)toNotificationData {
    EntityGraphNotificationData *data = [[EntityGraphNotificationData alloc] init];
    
    data.entityId = self.entity.ID;
    
    if([self.entity isKindOfClass:[SKDevice class]]) {
        data.entityType = ENTITY_TYPE__DEVICE;
    } else if([self.entity isKindOfClass:[SKDeviceGroup class]]) {
        data.entityType = ENTITY_TYPE__DEVICE_GROUP;
    } else if([self.entity isKindOfClass:[SKDataSource class]]) {
        data.entityType = ENTITY_TYPE__DATA_SOURCE;
    } else if([self.entity isKindOfClass:[SKScenario class]]) {
        data.entityType = ENTITY_TYPE__SCENARIO;
    } else if([self.entity isKindOfClass:[SKEvent class]]) {
        data.entityType = ENTITY_TYPE__EVENTS;
    }  else if([self.entity isKindOfClass:[SKSystemMode class]]) {
        data.entityType = ENTITY_TYPE__SYSTEM_MODE;
    }
    
    return data;
}

@end
