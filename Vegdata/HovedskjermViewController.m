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

@interface HovedskjermViewController ()

@end

@implementation HovedskjermViewController

@synthesize posLabel, fartLabel, fartBilde;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    fart = [[Fartsgrense alloc] initMedDelegate:self];
    
    pos = [[PosisjonsKontroller alloc] init];
    pos.delegate = self;
    [pos.lokMan startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PosisjonDelegate

- (void) posisjonOppdatering:(Posisjon *)posisjon
{
    posLabel.text = [NSString stringWithFormat:@"-Utviklerinfo-\nLengdegrad: %@\nBreddegrad: %@\nHastighet: %@ km/t\nRetning: %@ grader\nHøyde: %@ moh.\nPresisjon: %@m",
                     posisjon.lengdegrad.stringValue,
                     posisjon.breddegrad.stringValue,
                     posisjon.hastighetIKmT.stringValue,
                     posisjon.retning.stringValue,
                     posisjon.meterOverHavet.stringValue,
                     posisjon.presisjon.stringValue];
    
    [fart oppdaterMedBreddegrad:posisjon.breddegrad OgLengdegrad:posisjon.lengdegrad];
}

- (void) posisjonFeil:(NSError *)feil
{
    posLabel.text = [feil description];
}

#pragma mark - FartsgrenseDelegate

- (void) fartsgrenseErOppdatert
{
    if([fart.fart isEqualToString:@"-1"])
    {
        fartLabel.text = @"?";
        fartBilde.image = [UIImage imageNamed:@"fartsgrense_feil.gif"];
    }
    else
    {
        fartLabel.text = fart.fart;
        fartBilde.image = [UIImage imageNamed:@"fartsgrense.gif"];
    }
}

@end
