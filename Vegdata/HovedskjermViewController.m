//
//  ViewController.m
//  Vegdata
//
//  Created by Lars Smeby on 14.02.13.
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

#import "HovedskjermViewController.h"

@implementation HovedskjermViewController

@synthesize posLabel, fartLabel, fartBilde, forkjorBilde;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
    vegObjKont = [[VegObjektKontroller alloc] initMedDelegate:self];
    
    pos = [[PosisjonsKontroller alloc] init];
    pos.delegate = self;
    [pos.lokMan startUpdatingLocation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
//        fartBilde.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.fartBilde attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
//        CGRect frame = fartBilde.frame;
//        frame.origin.x = 0;
//        frame.origin.y = 0;
//        fartBilde.frame = frame;
    }
    else
    {
        
    }
}

#pragma mark - PosisjonDelegate

- (void) posisjonOppdatering:(Posisjon *)posisjon
{
//    posLabel.text = [NSString stringWithFormat:@"-Utviklerinfo-\nLengdegrad: %@\nBreddegrad: %@\nHastighet: %@ km/t\nRetning: %@ grader\nHøyde: %@ moh.\nPresisjon: %@m",
//                     posisjon.lengdegrad.stringValue,
//                     posisjon.breddegrad.stringValue,
//                     posisjon.hastighetIKmT.stringValue,
//                     posisjon.retning.stringValue,
//                     posisjon.meterOverHavet.stringValue,
//                     posisjon.presisjon.stringValue];
    
    [vegObjKont oppdaterMedBreddegrad:posisjon.breddegrad OgLengdegrad:posisjon.lengdegrad];
}

- (void) posisjonFeil:(NSError *)feil
{
    posLabel.text = [feil description];
}

#pragma mark - VegObjektDelegate

- (void) vegObjekterErOppdatert:(NSDictionary *)data
{
    NSString * fart = [data objectForKey:@"fart"];
    
    if(fart == nil)
    {
        // Fartsgrense skal ikke vises på skjermen
    }
    else if([fart isEqualToString:@"-1"])
    {
        [fartLabel setTextColor:[UIColor grayColor]];
        fartBilde.image = [UIImage imageNamed:@"fartsgrense_feil.gif"];
    }
    else
    {
        if([fart length] == 3)
            [fartLabel setFont:[UIFont boldSystemFontOfSize:80]];
        else
            [fartLabel setFont:[UIFont boldSystemFontOfSize:115]];
        
        fartLabel.text = fart;
        [fartLabel setTextColor:[UIColor blackColor]];
        fartBilde.image = [UIImage imageNamed:@"fartsgrense.gif"];
    }
    
    NSString * forkjorsveg = [data objectForKey:@"forkjorsveg"];
    
    if(forkjorsveg == nil)
    {
        // Forkjørsvei skal ikke vises på skjermen
    }
    else if ([forkjorsveg isEqual: @"yes"])
    {
        // bruk forkjørsskiltet
    }
    else
    {
        // bruk ikke-forkjørsskiltet
    }
}

@end
