//
//  Posisjon.m
//  Vegdata
//
//  Created by Lars Smeby on 15.02.13.
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

#import "Posisjon.h"

static int const MIN_ANTALL_METER = 50;
static int const MIN_ANTALL_SEK = 10;
static double const MSEK_TIL_KMT = 3.6;

@implementation PosisjonsKontroller

@synthesize lokMan, forrigeOppdatering, delegate;

- (id) init
{
    self = [super init];
    
    if(self != nil)
    {
        self.lokMan = [[CLLocationManager alloc] init];
        self.lokMan.delegate = self;
        self.lokMan.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // Bruker mye batteri, må testes
        self.lokMan.distanceFilter = MIN_ANTALL_METER; // Antall meter enheten må flytte seg før delegaten kalles
    }
    
    return self;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if([self.delegate conformsToProtocol:@protocol(PosisjonDelegate)])
    {
        CLLocation * CLpos = [locations lastObject];
        
        if(forrigeOppdatering != nil && [CLpos.timestamp timeIntervalSinceDate:forrigeOppdatering] < MIN_ANTALL_SEK)
            return;
        
        forrigeOppdatering = CLpos.timestamp;

        Posisjon * posisjon = [Posisjon alloc];
        posisjon.breddegrad = [[NSDecimalNumber alloc] initWithDouble:CLpos.coordinate.latitude];
        posisjon.lengdegrad = [[NSDecimalNumber alloc] initWithDouble:CLpos.coordinate.longitude];
        posisjon.hastighetIMeterISek = [[NSDecimalNumber alloc] initWithDouble:CLpos.speed];
        posisjon.retning = [[NSDecimalNumber alloc] initWithDouble:CLpos.course];
        posisjon.meterOverHavet = [[NSDecimalNumber alloc] initWithDouble:CLpos.altitude];
        posisjon.presisjon = [[NSDecimalNumber alloc] initWithDouble:CLpos.horizontalAccuracy];
           
        [self.delegate posisjonOppdatering:posisjon];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([self.delegate conformsToProtocol:@protocol(PosisjonDelegate)])
        [self.delegate posisjonFeil:error];
}

@end


@implementation Posisjon

@synthesize breddegrad, lengdegrad, hastighetIMeterISek, retning, meterOverHavet, presisjon;

- (NSDecimalNumber *) hastighetIKmT
{
    if(hastighetIMeterISek != nil)
        return [[NSDecimalNumber alloc] initWithDouble:hastighetIMeterISek.doubleValue * MSEK_TIL_KMT];
    
    return [[NSDecimalNumber alloc] initWithDouble:-1];
}

@end
