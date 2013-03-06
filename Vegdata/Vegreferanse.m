//
//  Vegreferanse.m
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

#import "Vegreferanse.h"
#import "Veglenke.h"

static NSString * const URI = @"/vegreferanse";
static NSString * const KEYPATH = nil;

@implementation Vegreferanse

@synthesize punktPaVeg, meterVerdi, visningsNavn, veglenkeId, veglenkePosisjon, geometriWgs84, veglenker;

- (NSDictionary *)hentKoordinater
{
    if(punktPaVeg == nil)
        return nil;
    
    NSRange start = [punktPaVeg rangeOfString:@"("];
    NSRange end = [punktPaVeg rangeOfString:@")"];
    NSRange range = NSMakeRange(start.location+1, end.location-start.location-1);
    
    NSString * hele = [punktPaVeg substringWithRange:range];
    
    NSDecimalNumber * breddegrad = [[NSDecimalNumber alloc] initWithString:[hele substringFromIndex:[hele rangeOfString:@" "].location+1]];
    NSDecimalNumber * lengdegrad = [[NSDecimalNumber alloc] initWithString:[hele substringToIndex:[hele rangeOfString:@" "].location]];
    
    return @{@"breddegrad" : breddegrad, @"lengdegrad" : lengdegrad};
}

#pragma mark - Statiske hjelpemetoder

+ (RKObjectMapping *)mapping
{
    RKObjectMapping * veglenkeMapping = [RKObjectMapping mappingForClass:[Veglenke class]];
    [veglenkeMapping addAttributeMappingsFromDictionary:@{@"id" : @"lenkeId",
                                                          @"fra" : @"fra",
                                                          @"til" : @"til",
                                                          @"direction" : @"retning"}];
   
    RKObjectMapping * vegreferanseMapping = [RKObjectMapping mappingForClass:[self class]];
    [vegreferanseMapping addAttributeMappingsFromDictionary:@{@"punktPaVegReferanseLinjeWGS84" : @"punktPaVeg",
                                                              @"meterVerdi" : @"meterVerdi",
                                                              @"visningsNavn" : @"visningsNavn",
                                                              @"veglenkeId" : @"veglenkeId",
                                                              @"veglenkePosisjon" : @"veglenkePosisjon",
                                                              @"vegReferanse.lokasjon.geometriWgs84" : @"geometriWgs84"}];
    [vegreferanseMapping addPropertyMapping:[RKRelationshipMapping
                                             relationshipMappingFromKeyPath:@"vegReferanse.lokasjon.veglenker"
                                                                  toKeyPath:@"veglenker"
                                                                withMapping:veglenkeMapping]];
    
    return vegreferanseMapping;
}

+ (NSString *)getURI
{
    return URI;
}

+ (NSString *)getKeyPath
{
    return KEYPATH;
}

@end