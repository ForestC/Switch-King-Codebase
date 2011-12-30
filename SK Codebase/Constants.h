//
//  Constants.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef SK_Codebase_Constants_h
#define SK_Codebase_Constants_h

#define XML_ELEMENT_NAME__DEVICE_ARRAY @"ArrayOfRESTDevice"
#define XML_ELEMENT_NAME__DEVICE @"RESTDevice"

#define XML_ELEMENT_NAME__DATASOURCE_ARRAY @"ArrayOfRESTDataSource"
#define XML_ELEMENT_NAME__DATASOURCE @"RESTDataSource"

#define ACTION_ID__TURN_ON 2
#define ACTION_ID__TURN_OFF 1

#define ENTITY_TYPE__DEVICE 1
#define ENTITY_TYPE__DEVICE_GROUP 2
#define ENTITY_TYPE__DATA_SOURCE 3

#define ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY @"EntityReqData"


#define NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING @"EntityDirtified"
#define NOTIFICATION_NAME__ENTITY_UPDATE_REQUESTED @"EntityUpdateRequested"
#define NOTIFICATION_NAME__ENTITY_UPDATE_REQUEST_CANCELLED @"EntityUpdateReqCancelled"
#define NOTIFICATION_NAME__DEVICES_UPDATED @"DevicesUpdated"
#define NOTIFICATION_NAME__DEVICE_DIRTIFICATION_UPDATED @"DeviceDirtificationUpdated"

#endif
