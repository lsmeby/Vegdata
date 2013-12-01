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

@implementation NVDB_RESTkit

@synthesize delegate;

- (void) hentDataMedURI:(NSString *)uri Parametere:(NSDictionary *)parametere Mapping:(RKMapping *)mapping KeyPath:(NSString *)keyPath VeglenkeId:(NSNumber *)lenkeId Vegreferanse:(Vegreferanse *)vegref OgSpoerringsType:(Spoerring)type
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
             [self.delegate svarFraNVDBMedResultat:[mappingResult array] VeglenkeId:lenkeId Vegreferanse:vegref OgSpoerringsType:type];
     }
                            failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"Feil i NVDB_RESTkit:\nOperation: %@\nError: %@", operation, error);
         [self.delegate svarFraNVDBMedResultat:nil VeglenkeId:lenkeId Vegreferanse:vegref OgSpoerringsType:type];
     }];
}

- (void)hentAvstandMellomKoordinaterMedParametere:(NSDictionary *)parametere Mapping:(RKMapping *)mapping OgKey:(NSString *)key
{
    AFHTTPClient * klient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:MAPQUEST_GRUNN_URL]];
    [klient setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager * objectManager = [[RKObjectManager alloc] initWithHTTPClient:klient];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    NSString * fullURI = [MAPQUEST_GRUNN_URL stringByAppendingString:MAPQUEST_MATRIX_URL];
    
    [objectManager getObjectsAtPath:fullURI parameters:parametere
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         if([self.delegate conformsToProtocol:@protocol(NVDBResponseDelegate)])
             [self.delegate svarFraMapQuestMedResultat:[mappingResult array] OgKey:key];
     }
                            failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"Feil i NVDB_RESTkit:\nOperation: %@\nError: %@", operation, error);
         if([self.delegate conformsToProtocol:@protocol(NVDBResponseDelegate)])
             [self.delegate svarFraMapQuestMedResultat:nil OgKey:key];
     }];
}

@end
