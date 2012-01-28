//
//  Constants.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef SK_Codebase_Constants_h
#define SK_Codebase_Constants_h

#define REUSE_IDENTIFIER__DEVICE_CELL_STD @"DeviceCellStd"
#define REUSE_IDENTIFIER__DEVICE_CELL_STD_DIRTY @"DeviceCellStdDirty"
#define REUSE_IDENTIFIER__DEVICE_GROUP_CELL_STD @"DeviceGroupCellStd"
#define REUSE_IDENTIFIER__DEVICE_GROUP_CELL_STD_DIRTY @"DeviceGroupCellStdDirty"

#define REUSE_IDENTIFIER__SETTINGS_CELL_SWITCH @"SwitchSettingStd"
#define REUSE_IDENTIFIER__SETTINGS_CELL_URL @"UrlSettingStd"
#define REUSE_IDENTIFIER__SETTINGS_CELL_NUMERIC @"NumericSettingStd"
#define REUSE_IDENTIFIER__SETTINGS_CELL_PASSWORD @"PasswordSettingStd" 
#define REUSE_IDENTIFIER__SETTINGS_CELL_TEXT @"TextSettingStd" 

#define REUSE_IDENTIFIER__RIGHT_DETAIL @"RightDetail"

/*******************************************************************************
 Xml tags for REST communication
 *******************************************************************************/

#define XML_ELEMENT_NAME__DEVICE_ARRAY @"ArrayOfRESTDevice"
#define XML_ELEMENT_NAME__DEVICE @"RESTDevice"

#define XML_ELEMENT_NAME__DATASOURCE_ARRAY @"ArrayOfRESTDataSource"
#define XML_ELEMENT_NAME__DATASOURCE @"RESTDataSource"

#define XML_VALUE__TRUE @"true"
#define XML_VALUE__FALSE @"false"

/*******************************************************************************
 Swipe Params (Constants)
 *******************************************************************************/

#define SWIPE_MARGIN__PER_SIDE 60
#define SWIPE_MARGIN__DETECTION_THRESHOLD 30
#define SWIPE_MARGIN__Y_MOVEMENT 20

/*******************************************************************************
 Server IDs (Constants)
*******************************************************************************/

#define ACTION_ID__TURN_ON 2
#define ACTION_ID__TURN_OFF 1

#define DEVICE_STATE_ID__ON 2
#define DEVICE_STATE_ID__OFF 1

#define DEVICE_MODE_ID__AUTO 2
#define DEVICE_MODE_ID__MANUAL 1
#define DEVICE_MODE_ID__SEMI_AUTO 3

#define SCENARIO_ID__AUTO 1
#define SCENARIO_ID__FROZEN 2

#define DEVICE_MODE_TYPE__SCHEDULE_AND_RULE_DRIVEN @"ScheduleAndRuleDriven"
#define DEVICE_MODE_TYPE__SCENARIO_DRIVEN @"ScenarioDriven"

/*******************************************************************************
 Internal type definitions
 *******************************************************************************/

#define ENTITY_TYPE__DEVICE 1
#define ENTITY_TYPE__DEVICE_GROUP 2
#define ENTITY_TYPE__DATA_SOURCE 3
#define ENTITY_TYPE__ALL_ENTITIES 1000

/*******************************************************************************
 Notification names
 *******************************************************************************/

#define NOTIFICATION_NAME__ENTITY_DIRTIFICATION_UPDATING @"EntityDirtified"
#define NOTIFICATION_NAME__ENTITY_UPDATE_REQUESTED @"EntityUpdateRequested"
#define NOTIFICATION_NAME__ENTITY_UPDATE_REQUEST_CANCELLED @"EntityUpdateReqCancelled"
#define NOTIFICATION_NAME__DEVICE_UPDATED @"DeviceUpdated"
#define NOTIFICATION_NAME__DEVICES_UPDATED @"DevicesUpdated"
#define NOTIFICATION_NAME__DEVICE_DIRTIFICATION_UPDATED @"DeviceDirtificationUpdated"
#define NOTIFICATION_NAME__DEVICE_GROUP_DIRTIFICATION_UPDATED @"DeviceGroupDirtificationUpdated"
#define NOTIFICATION_NAME__ALERT_INFO_REQUESTED @"AlertReq"
#define NOTIFICATION_NAME__NO_CONNECTION @"NoConn"

#define ENTITY_REQ_NOTIFICATION__ENTITY_REQ_DATA_KEY @"EntityReqData"
#define ALERT_INFO_NOTIFICATION__ALERT_MSG_KEY @"Msg"

/*******************************************************************************
 Setting tags
 *******************************************************************************/

#define CELL_TAG__USE_LIVE 1
#define CELL_TAG__SERVER_ADDRESS 2
#define CELL_TAG__SERVER_PORT 3
#define CELL_TAG__SERVER_IDENTITY 4
#define CELL_TAG__USERNAME 5
#define CELL_TAG__PASSWORD 6

#define CELL_TAG__SETTINGS_LIST__SERVER__ADDRESS 1
#define CELL_TAG__SETTINGS_LIST__INTERVAL__UPDATE_INTERVAL 2
#define CELL_TAG__SETTINGS_LIST__INTERVAL__UPDATE_CMD_INTERVAL 3
#define CELL_TAG__SETTINGS_LIST__EVENTS__MAX_COMING_UP_EVTS 4
#define CELL_TAG__SETTINGS_LIST__MISC__ALLOW_LEARN 5
#define CELL_TAG__SETTINGS_LIST__MISC__GROUP_DEVICES 6
#define CELL_TAG__SETTINGS_LIST__MISC__RELOAD_AT_TAB_SWITCH 7

/*******************************************************************************
 Settings sections
 *******************************************************************************/

#define TABLE_SECTION__SETTINGS__TARGET 0
#define TABLE_SECTION__SETTINGS__CREDENTIALS 1

#define TABLE_SECTION__SETTINGS_LIST__SERVER 0
#define TABLE_SECTION__SETTINGS_LIST__INTERVAL 1
#define TABLE_SECTION__SETTINGS_LIST__EVENTS 2
#define TABLE_SECTION__SETTINGS_LIST__MISC 3


#endif


