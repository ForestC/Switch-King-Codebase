//
//  XMLSKSystemModeParser.m
//  Switch King
//
//  Created by Martin Videfors on 2012-10-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLSKSystemModeParser.h"
#import "NSString+HTML.h"
#import "Constants.h"
#import "SKSystemMode.h"

@implementation XMLSKSystemModeParser

@synthesize entityStore;

- (XMLSKSystemModeParser *) initXmlParser {
    self = [super init];
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:XML_ELEMENT_NAME__SYSTEM_MODE_ARRAY]) {
        self->expectsCollection = true;
        systemModeList = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:XML_ELEMENT_NAME__SYSTEM_MODE]) {
        
        //Initialize the book.
        systemMode = [[SKSystemMode alloc] init];
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
    if([elementName isEqualToString:XML_ELEMENT_NAME__SYSTEM_MODE_ARRAY]) {
        if(entityStore != nil) {
            [entityStore entityCollectionUpdated:self :systemModeList :[SKSystemMode class]];
        }
        
        systemMode = nil;
    } else if([elementName isEqualToString:XML_ELEMENT_NAME__SYSTEM_MODE]) {     
        
        if(systemMode.ID == 1 && (systemMode.Name == nil || [systemMode.Name isEqualToString:@""])) {
            systemMode.Name = NSLocalizedStringFromTable(@"Default", @"Texts", nil);
        } 
        
        if(!expectsCollection) {
            if(entityStore != nil) {
                [entityStore entityUpdated:self :systemMode];
            }
        } else {
            [systemModeList addObject:systemMode];
        }
        
        systemMode = nil;
    }
    else {
        @try {
            NSString *unescaped = [currentElementValue stringByDecodingHTMLEntities];
            [systemMode setValue:unescaped forKey:elementName];
        }
        @catch (NSException * e) {
            NSLog(@"Invalid key: %@", elementName);
        }
    }
    
    currentElementValue = nil;
}

@end