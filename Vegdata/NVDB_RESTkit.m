//
//  NVDB_RESTkit.m
//  Vegdata
//
//  Created by Lars Smeby on 20.02.13.
//
//  Copyright (C) 2013  Henrik Hermansen og Lars Smeby
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "NVDB_RESTkit.h"

static NSString * const NVDB_GRUNN_URL = @"http://nvdb1.demo.bekk.no:7001/nvdb/api";

//static NSString * const NVDB_GRUNN_URL = @"https://www.vegvesen.no/nvdb/api";

@implementation NVDB_RESTkit

@synthesize delegate;

- (void) hentDataMedURI:(NSString *)uri Parametere:(NSDictionary *)parametere Mapping:(RKMapping *)mapping KeyPath:(NSString *)keyPath OgVeglenkeId:(NSNumber *)lenkeId
{
    AFHTTPClient * klient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:NVDB_GRUNN_URL]];
    [klient setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:keyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager * objectManager = [[RKObjectManager alloc] initWithHTTPClient:klient];

    [objectManager addResponseDescriptor:responseDescriptor];
    
    NSString * fullURI = [NVDB_GRUNN_URL stringByAppendingString:uri];
    
    [objectManager getObjectsAtPath:fullURI parameters:parametere
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         if([self.delegate conformsToProtocol:@protocol(NVDBResponseDelegate)])
             [self.delegate svarFraNVDBMedResultat:[mappingResult array] OgVeglenkeId:lenkeId];
     }
                            failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"\n### FEIL I NVDB_RESTkit:\n### Operation: %@\n### Error: %@", operation, error);
         [self.delegate svarFraNVDBMedResultat:nil OgVeglenkeId:lenkeId];
     }];
}

@end
