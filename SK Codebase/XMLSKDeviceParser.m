//
//  XmlSKDeviceParser.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLSKDeviceParser.h"
#import "SKDevice.h"
#include "Constants.h"
#import "NSString+HTML.h"

@implementation XMLSKDeviceParser

@synthesize entityStore;

- (XMLSKDeviceParser *) initXmlParser {
    self = [super init];
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:XML_ELEMENT_NAME__DEVICE_ARRAY]) {
        self->expectsCollection = true;
        deviceList = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:XML_ELEMENT_NAME__DEVICE]) {
        
        //Initialize the book.
        device = [[SKDevice alloc] init];
    }
    
    //NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
    
    //NSLog(@"Processing Value: %@", currentElementValue);
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:XML_ELEMENT_NAME__DEVICE_ARRAY]) {
        if(entityStore != nil) {
            [entityStore entityCollectionUpdated:self :deviceList :[SKDevice class]];
        }
        
        device = nil;
    } else if([elementName isEqualToString:XML_ELEMENT_NAME__DEVICE]) {
        if(!expectsCollection) {
            if(entityStore != nil) {
               [entityStore entityUpdated:self :device];
            }
        } else if([XML_VALUE__TRUE isEqualToString:device.Enabled]) {
            [deviceList addObject:device];
        }
        
        device = nil;
    }
    else {
        @try {
//            if([currentElementValue isEqualToString:XML_VALUE__TRUE]) {
//                [device setValue:@"YES" forKey:elementName];                
//            } else if([currentElementValue isEqualToString:XML_VALUE__FALSE]) {
//                [device setValue:@"NO" forKey:elementName];
//            } else {
                NSString *unescaped = [currentElementValue stringByDecodingHTMLEntities];
                [device setValue:unescaped forKey:elementName];
           // }
        }
        @catch (NSException * e) {
            NSLog(@"Invalid key: %@", elementName);
        }
    }
                
    currentElementValue = nil;
}

@end