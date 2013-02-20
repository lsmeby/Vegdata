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

static NSString * const URI = @"/vegreferanse";
static NSString * const KEYPATH = nil;

@implementation Vegreferanse

@synthesize punktPaVeg, meterVerdi, visningsNavn, veglenkeId, veglenkePosisjon;

+ (RKObjectMapping *)mappingForVegreferanse
{
    RKObjectMapping * vegreferanseMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [vegreferanseMapping addAttributeMappingsFromDictionary:@{@"punktPaVegReferanseLinjeWGS84": @"punktPaVeg",
                                                              @"meterVerdi" : @"meterVerdi",
                                                              @"visningsNavn" : @"visningsNavn",
                                                              @"veglenkeId" : @"veglenkeId",
                                                              @"veglenkePosisjon" : @"veglenkePosisjon"}];
    
    return vegreferanseMapping;
}

+ (NSDictionary *)parametereForVegreferanseMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    return @{@"x" : breddegrad.stringValue, @"y" : lengdegrad.stringValue, @"srid" : @"WGS84"};
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
