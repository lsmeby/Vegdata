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

@interface HovedskjermViewController()
- (IBAction)hudKnappTrykket:(UISwitch *)knapp;
@end

@implementation HovedskjermViewController

@synthesize posLabel, fartLabel, fartBilde, forkjorBilde, hudSwitch;

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
        CGRect frame = fartBilde.frame;
        frame.origin.x = 30;
        frame.origin.y = 40;
        fartBilde.frame = frame;
        fartLabel.frame = frame;
        
        frame.origin.x = 260;
        forkjorBilde.frame = frame;
    }
}

//-(BOOL)shouldAutorotate
//{
//    if(hudSwitch.isOn)
//        return NO;
//    return YES;
//}

-(NSUInteger)supportedInterfaceOrientations
{
    if(hudSwitch.isOn)
        return UIInterfaceOrientationMaskLandscapeRight;
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (IBAction)hudKnappTrykket:(UISwitch *)knapp
{
    if(knapp.isOn)
    {
        fartLabel.transform = CGAffineTransformScale(fartLabel.transform, 1.0, -1.0);
        forkjorBilde.transform = CGAffineTransformScale(forkjorBilde.transform, 1.0, -1.0);
    }
    else
    {
        fartLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        forkjorBilde.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        // ...
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
        forkjorBilde.image = [UIImage imageNamed:@"forkjorsvei.gif"];
    }
    else
    {
        forkjorBilde.image = [UIImage imageNamed:@"opphevet_forkjorsvei.gif"];
    }
}

@end
