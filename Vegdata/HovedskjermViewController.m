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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
    self.vegObjKont = [[VegObjektKontroller alloc] initMedDelegate:self];
    
    self.pos = [[PosisjonsKontroller alloc] init];
    self.pos.delegate = self;
    [self.pos.lokMan startUpdatingLocation];
}

-(BOOL)shouldAutorotate
{
    if(self.hudSwitch.isOn)
        return NO;
    return YES;
}

- (IBAction)hudKnappTrykket:(UISwitch *)knapp
{
    if(knapp.isOn)
    {
        self.fartLabel.transform = CGAffineTransformScale(self.fartLabel.transform, 1.0, -1.0);
        self.forkjorBilde.transform = CGAffineTransformScale(self.forkjorBilde.transform, 1.0, -1.0);
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else
    {
        self.fartLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.forkjorBilde.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

#pragma mark - PosisjonDelegate

- (void) posisjonOppdatering:(Posisjon *)posisjon
{
    [self.vegObjKont oppdaterMedBreddegrad:posisjon.breddegrad OgLengdegrad:posisjon.lengdegrad];
}

- (void) posisjonFeil:(NSError *)feil
{
    NSLog(@"\n### Feil: %@", [feil description]);
}

#pragma mark - VegObjektDelegate

- (void) vegObjekterErOppdatert:(NSDictionary *)data
{
    self.nyesteData = data;
    
    NSString * fart = [data objectForKey:@"fart"];
    
    if(fart == nil)
    {
        // Fartsgrense skal ikke vises på skjermen
    }
    else if([fart isEqualToString:@"-1"])
    {
        [self.fartLabel setTextColor:[UIColor grayColor]];
        self.fartBilde.image = [UIImage imageNamed:@"fartsgrense_feil.gif"];
    }
    else
    {
        if([fart length] == 3)
            [self.fartLabel setFont:[UIFont boldSystemFontOfSize:80]];
        else
            [self.fartLabel setFont:[UIFont boldSystemFontOfSize:115]];
        
        self.fartLabel.text = fart;
        [self.fartLabel setTextColor:[UIColor blackColor]];
        self.fartBilde.image = [UIImage imageNamed:@"fartsgrense.gif"];
    }
    
    NSString * forkjorsveg = [data objectForKey:@"forkjorsveg"];
    
    if(forkjorsveg == nil)
    {
        // Forkjørsvei skal ikke vises på skjermen
    }
    else if ([forkjorsveg isEqualToString: @"yes"])
    {
        self.forkjorBilde.image = [UIImage imageNamed:@"forkjorsvei.gif"];
    }
    else
    {
        self.forkjorBilde.image = [UIImage imageNamed:@"opphevet_forkjorsvei.gif"];
    }
    
    NSString * vilttrekk = [data objectForKey:@"vilttrekk"];
    
    if(vilttrekk == nil || [vilttrekk isEqualToString:@"-1"])
    {
        // Vilttrekk skal ikke vises på skjermen
    }
    else
    {
        NSLog(@"\n### Viser vilttrekkskilt med: %@", vilttrekk);
    }
}

@end
