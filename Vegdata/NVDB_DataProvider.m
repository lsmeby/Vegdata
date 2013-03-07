//
//  NVDB_DataProvider.m
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

#import "NVDB_DataProvider.h"
#import "NVDB_RESTkit.h"
#import "Vegreferanse.h"
#import "Sok.h"

static NSString * const NVDB_GEOMETRI = @"WGS84";
static double const WGS84_BBOX_RADIUS = 0.0001;

@interface NVDB_DataProvider()
+ (NSDictionary *)parametereForKoordinaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;
+ (NSDictionary *)parametereForBoundingBoxMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;
+ (NSDictionary *)parametereForSok:(Sok *)sok;
@end

@implementation NVDB_DataProvider
{
    NVDB_RESTkit * restkit;
}

- (id)init
{
    restkit = [NVDB_RESTkit alloc];
    return self;
}

- (void)hentVegreferanseMedBreddegrad:(NSDecimalNumber *)breddegrad Lengdegrad:(NSDecimalNumber *)lengdegrad OgAvsender:(NSObject *)avsender
{
    restkit.delegate = avsender;
    [restkit hentDataMedURI:[Vegreferanse getURI]
                 Parametere:[NVDB_DataProvider parametereForKoordinaterMedBreddegrad:breddegrad
                                                                        OgLengdegrad:lengdegrad]
                    Mapping:[Vegreferanse mapping]
                  OgkeyPath:[Vegreferanse getKeyPath]];
}

- (void)hentVegObjekterMedSokeObjekt:(Sok *)sok Mapping:(RKMapping *)mapping OgAvsender:(NSObject *)avsender
{
    restkit.delegate = avsender;
    [restkit hentDataMedURI:[Sok getURI]
                 Parametere:[NVDB_DataProvider parametereForSok:sok]
                    Mapping:mapping
                  OgkeyPath:[Sok getKeyPath]];
}

#pragma mark - Statiske hjelpemetoder

+ (NSDictionary *)parametereForKoordinaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    return @{@"x" : breddegrad.stringValue, @"y" : lengdegrad.stringValue, @"srid" : NVDB_GEOMETRI};
}

+ (NSDictionary *)parametereForBoundingBoxMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    NSDecimalNumber * bboxRadius = [[NSDecimalNumber alloc] initWithDouble:WGS84_BBOX_RADIUS];
    
    NSString * bboxString = [[NSArray arrayWithObjects:[lengdegrad decimalNumberBySubtracting:bboxRadius],
                              [breddegrad decimalNumberBySubtracting:bboxRadius],
                              [lengdegrad decimalNumberByAdding:bboxRadius],
                              [breddegrad decimalNumberByAdding:bboxRadius],
                              nil] componentsJoinedByString:@","];
    
    return @{@"bbox" : bboxString, @"srid" : NVDB_GEOMETRI};
}

+ (NSDictionary *)parametereForSok:(Sok *)sok
{
    
//    NSDictionary * sokDic = @{@"objektTyper" : @"[{id:105, antall:2}]"};
//    NSArray * sokArray = [[NSArray alloc] initWithObjects:sok, nil];
//    NSData * test = [NSJSONSerialization dataWithJSONObject:sokDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * test2 = [[NSString alloc] initWithData:test encoding:NSUTF8StringEncoding];
//    NSLog(@"\n test: %@ \n test2: %@", test, test2);
    return @{@"kriterie" : @"{lokasjon: {veglenker: [{id:443636, fra:0, til:1}]}, objektTyper:[{id:105, antall:0}]}"};
}

@end
