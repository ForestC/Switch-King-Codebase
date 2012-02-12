//
//  XMLSKSystemSettingParser.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLSKSystemSettingParser.h"
#include "Constants.h"
#import "NSString+HTML.h"

@implementation XMLSKSystemSettingParser

@synthesize entityStore;

- (XMLSKSystemSettingParser *) initXmlParser {
    self = [super init];
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:XML_ELEMENT_NAME__SYSTEM_SETTING_ARRAY]) {
        self->expectsCollection = true;
        settingList = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:XML_ELEMENT_NAME__SYSTEM_SETTING]) {
        
        //Initialize the book.
        setting = [[SKSystemSetting alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:XML_ELEMENT_NAME__SYSTEM_SETTING_ARRAY]) {
        if(entityStore != nil) {
            [entityStore entityCollectionUpdated:self :settingList :[SKSystemSetting class]];
        }
        
        setting = nil;
    } else if([elementName isEqualToString:XML_ELEMENT_NAME__SYSTEM_SETTING]) {        
        if(!expectsCollection) {
            if(entityStore != nil) {
                [entityStore entityUpdated:self :setting];
            }
        } else {
            [settingList addObject:setting];
        }
        
        setting = nil;
    }
    else {
        @try {
            NSString *unescaped = [currentElementValue stringByDecodingHTMLEntities];
            [setting setValue:unescaped forKey:elementName];
        }
        @catch (NSException * e) {
            NSLog(@"Invalid key: %@", elementName);
        }
    }
    
    currentElementValue = nil;
}

@end