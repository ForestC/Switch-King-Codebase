//
//  XMLSKScenarioParser.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLSKScenarioParser.h"
#import "NSString+HTML.h"
#import "Constants.h"
#import "SKScenario.h"

@implementation XMLSKScenarioParser

@synthesize entityStore;

- (XMLSKScenarioParser *) initXmlParser {
    self = [super init];
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:XML_ELEMENT_NAME__SCENARIO_ARRAY]) {
        self->expectsCollection = true;
        scenarioList = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:XML_ELEMENT_NAME__SCENARIO]) {
        
        //Initialize the book.
        scenario = [[SKScenario alloc] init];
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
    if([elementName isEqualToString:XML_ELEMENT_NAME__SCENARIO_ARRAY]) {
        if(entityStore != nil) {
            [entityStore entityCollectionUpdated:self :scenarioList :[SKScenario class]];
        }
        
        scenario = nil;
    } else if([elementName isEqualToString:XML_ELEMENT_NAME__SCENARIO]) {     
        
        if(scenario.ID == 1)        {
            scenario.Name = NSLocalizedStringFromTable(@"(all by schedule)", @"Texts", nil);
        } else if(scenario.ID == 2) {
            scenario.Name = NSLocalizedStringFromTable(@"(all frozen)", @"Texts", nil);            
        }
        
        if(!expectsCollection) {
            if(entityStore != nil) {
                [entityStore entityUpdated:self :scenario];
            }
        } else {
            [scenarioList addObject:scenario];
        }
        
        scenario = nil;
    }
    else {
        @try {
            NSString *unescaped = [currentElementValue stringByDecodingHTMLEntities];
            [scenario setValue:unescaped forKey:elementName];
        }
        @catch (NSException * e) {
            NSLog(@"Invalid key: %@", elementName);
        }
    }
    
    currentElementValue = nil;
}

@end