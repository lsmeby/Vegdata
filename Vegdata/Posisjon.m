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

@interface PosisjonsKontroller()
- (void) oppdaterPresisjonMedFart:(NSDecimalNumber *)meterISekundet;
- (void) mockLokasjoner;
@end

@implementation PosisjonsKontroller

@synthesize lokMan, delegate, sisteOppdatering, koordinater, isMock;

- (id) initWithMock:(bool)withMock
{
    isMock = withMock;
    
    if(!isMock)
    {
        self = [super init];
    
        if(self != nil)
        {
            self.lokMan = [[CLLocationManager alloc] init];
            self.lokMan.delegate = self;
            self.lokMan.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            self.lokMan.distanceFilter = kCLDistanceFilterNone;
            self.sisteOppdatering = [[CLLocation alloc] init];
        }
    }
    else
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"vegkoordinater" ofType:@"txt"];
        NSString * content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        koordinater = [content componentsSeparatedByString:@", "];
    }
    
    return self;
}

- (void)startUpdatingLocation
{
    if(isMock)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, (unsigned long)nil), ^(void) {
            [self mockLokasjoner];
        });
        NSLog(@"Kjører i testmodus - posisjoner leses fra fil.");
    }
    else
    {
        [self.lokMan startUpdatingLocation];
        NSLog(@"Posisjonstjenesten startet.");
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if([self.delegate conformsToProtocol:@protocol(PosisjonDelegate)])
    {
        CLLocation * CLpos = [locations lastObject];

        if(self.sisteOppdatering != nil &&
           [CLpos.timestamp timeIntervalSinceDate:self.sisteOppdatering.timestamp] < (POS_OPPDATERING_SEK_VED_BEVEGELSE_STOPP) &&
           [CLpos distanceFromLocation:self.sisteOppdatering] < POS_OPPDATERING_METER)
            return;
        
        self.sisteOppdatering = CLpos;
        
        Posisjon * posisjon = [Posisjon alloc];
        posisjon.breddegrad = [[NSDecimalNumber alloc] initWithDouble:CLpos.coordinate.latitude];
        posisjon.lengdegrad = [[NSDecimalNumber alloc] initWithDouble:CLpos.coordinate.longitude];
        posisjon.hastighetIMeterISek = [[NSDecimalNumber alloc] initWithDouble:CLpos.speed];
        posisjon.retning = [[NSDecimalNumber alloc] initWithDouble:CLpos.course];
        posisjon.meterOverHavet = [[NSDecimalNumber alloc] initWithDouble:CLpos.altitude];
        posisjon.presisjon = [[NSDecimalNumber alloc] initWithDouble:CLpos.horizontalAccuracy];
        
        [self oppdaterPresisjonMedFart:posisjon.hastighetIMeterISek];
        
        [self.delegate posisjonOppdatering:posisjon];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([self.delegate conformsToProtocol:@protocol(PosisjonDelegate)])
        [self.delegate posisjonFeil:error];
}

- (void) oppdaterPresisjonMedFart:(NSDecimalNumber *)meterISekundet
{
    if(meterISekundet == nil || meterISekundet.doubleValue < 0)
        self.lokMan.distanceFilter = kCLDistanceFilterNone;
    else
    {
        double nyttFilter = meterISekundet.doubleValue * POS_OPPDATERING_SEK;
        
        // Oppdater kun hvis det er minst 10 km/t forskjell på forrige registrerte filter
        if(self.lokMan.distanceFilter - nyttFilter > (10 / POS_MSEK_TIL_KMT * POS_OPPDATERING_SEK) || self.lokMan.distanceFilter - nyttFilter < -(10 / POS_MSEK_TIL_KMT * POS_OPPDATERING_SEK))
            [self.lokMan setDistanceFilter:nyttFilter];
    }
}

- (void)mockLokasjoner
{
    while(true)
    {
        for(int i = 0; i < [koordinater count]; i++)
        {
            if(i % 10 != 0)
                continue;
            NSLog(@"Mockstrekning: %d / %u m.", i * 10, [koordinater count] * 10);
            NSString * koordString = koordinater[i];
            NSArray * koordArray = [koordString componentsSeparatedByString:@" "];
            Posisjon * posisjon = [Posisjon alloc];
            posisjon.breddegrad = [[NSDecimalNumber alloc] initWithDouble:[((NSString *)koordArray[1]) doubleValue]];
            posisjon.lengdegrad = [[NSDecimalNumber alloc] initWithDouble:[((NSString *)koordArray[0]) doubleValue]];
            [self.delegate posisjonOppdatering:posisjon];
            sleep(5);
        }
    }
}

@end


@implementation Posisjon

@synthesize breddegrad, lengdegrad, hastighetIMeterISek, retning, meterOverHavet, presisjon;

- (NSDecimalNumber *) hastighetIKmT
{
    if(hastighetIMeterISek != nil)
        return [[NSDecimalNumber alloc] initWithDouble:hastighetIMeterISek.doubleValue * POS_MSEK_TIL_KMT];
    
    return [[NSDecimalNumber alloc] initWithDouble:-1];
}

@end
