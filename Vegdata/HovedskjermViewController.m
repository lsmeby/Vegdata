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
#import "AppDelegate.h"

@interface HovedskjermViewController()
- (IBAction)hudKnappTrykket:(UISwitch *)knapp;
- (BOOL)erFireTommerRetina;
@end

@implementation HovedskjermViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
    self.vegObjKont = [[VegObjektKontroller alloc] initMedDelegate:self
                                            OgManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate]
                                                                    managedObjectContext]];
    
    self.layoutArray = [self settOppLayoutArray];
    
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

- (NSArray *)settOppLayoutArray
{
    NSMutableArray * retur = [[NSMutableArray alloc] init];
    
    [retur addObject:@[self.bilde1, self.label1, self.detalj1]];
    [retur addObject:@[self.bilde2, self.label2, self.detalj2]];
    [retur addObject:@[self.bilde3, self.label3, self.detalj3]];
    
    if(self.erFireTommerRetina)
    {
        [retur addObject:@[self.bilde6, self.label6, self.detalj6]];
        [retur addObject:@[self.bilde7, self.label7, self.detalj7]];
    }
    
    [retur addObject:@[self.bilde4, self.label4, self.detalj4]];
    
    if(false) // Hvis HUD-knappen er skjult
        [retur addObject:@[self.bilde5, self.label5, self.detalj5]];
    
    return retur;
}

- (IBAction)hudKnappTrykket:(UISwitch *)knapp
{
    if(knapp.isOn)
    {
        self.bilde1.transform = CGAffineTransformScale(self.bilde1.transform, 1.0, -1.0);
        self.bilde2.transform = CGAffineTransformScale(self.bilde2.transform, 1.0, -1.0);
        self.bilde3.transform = CGAffineTransformScale(self.bilde3.transform, 1.0, -1.0);
        self.bilde4.transform = CGAffineTransformScale(self.bilde4.transform, 1.0, -1.0);
        self.bilde5.transform = CGAffineTransformScale(self.bilde5.transform, 1.0, -1.0);
        self.bilde6.transform = CGAffineTransformScale(self.bilde6.transform, 1.0, -1.0);
        self.bilde7.transform = CGAffineTransformScale(self.bilde7.transform, 1.0, -1.0);
        
        self.label1.transform = CGAffineTransformScale(self.label1.transform, 1.0, -1.0);
        self.label2.transform = CGAffineTransformScale(self.label2.transform, 1.0, -1.0);
        self.label3.transform = CGAffineTransformScale(self.label3.transform, 1.0, -1.0);
        self.label4.transform = CGAffineTransformScale(self.label4.transform, 1.0, -1.0);
        self.label5.transform = CGAffineTransformScale(self.label5.transform, 1.0, -1.0);
        self.label6.transform = CGAffineTransformScale(self.label6.transform, 1.0, -1.0);
        self.label7.transform = CGAffineTransformScale(self.label7.transform, 1.0, -1.0);
        
        self.detalj1.transform = CGAffineTransformScale(self.detalj1.transform, 1.0, -1.0);
        self.detalj2.transform = CGAffineTransformScale(self.detalj2.transform, 1.0, -1.0);
        self.detalj3.transform = CGAffineTransformScale(self.detalj3.transform, 1.0, -1.0);
        self.detalj4.transform = CGAffineTransformScale(self.detalj4.transform, 1.0, -1.0);
        self.detalj5.transform = CGAffineTransformScale(self.detalj5.transform, 1.0, -1.0);
        self.detalj6.transform = CGAffineTransformScale(self.detalj6.transform, 1.0, -1.0);
        self.detalj7.transform = CGAffineTransformScale(self.detalj7.transform, 1.0, -1.0);
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else
    {
        self.bilde1.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.bilde2.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.bilde3.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.bilde4.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.bilde5.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.bilde6.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.bilde7.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        self.label1.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.label2.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.label3.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.label4.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.label5.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.label6.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.label7.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        self.detalj1.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.detalj2.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.detalj3.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.detalj4.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.detalj5.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.detalj6.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.detalj7.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

- (BOOL)erFireTommerRetina
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
            &&
            [UIScreen mainScreen].bounds.size.height == 568;
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
    
    int element = 0;
    int antallPlasser = [self.layoutArray count];
    NSArray * rad;
    NSString * dataObjekt;
    
    
    // -- FARTSGRENSE --
    
    dataObjekt = [data objectForKey:@"fart"];
    if(dataObjekt != nil && element < antallPlasser)
    {
        rad = self.layoutArray[element];
        
        if([dataObjekt isEqualToString:@"-1"])
        {
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fartsgrense_feil.gif"];
            [(UILabel *)rad[1] setTextColor:[UIColor grayColor]];
        }
        else
        {
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fartsgrense.gif"];
            ((UILabel *)rad[1]).text = dataObjekt;
            [(UILabel *)rad[1] setTextColor:[UIColor blackColor]];
            
            if(element == 0)
            {
                if([dataObjekt length] == 3)
                    [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:70]];
                else
                    [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:100]];
            }
            else if(element < 3)
            {
                if([dataObjekt length] == 3)
                    [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:45]];
                else
                    [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:65]];
            }
            else
            {
                if([dataObjekt length] == 3)
                    [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:24]];
                else
                    [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:32]];
            }
        }
        
        ((UILabel *)rad[2]).text = nil;
        element++;
    }
    
    
    // -- FORKJØRSVEI --
    
    dataObjekt = [data objectForKey:@"forkjorsveg"];
    if(dataObjekt != nil && element < antallPlasser && [dataObjekt isEqualToString:@"yes"])
    {
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"forkjorsvei.gif"];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        element++;
    }
    
    
    // -- VILTTREKK --
    
    dataObjekt = [data objectForKey:@"vilttrekk"];
    if(dataObjekt != nil && ![dataObjekt isEqualToString:@"-1"] && element < antallPlasser)
    {
        rad = self.layoutArray[element];
        
        if([dataObjekt isEqualToString:@"Hjort"])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_hjort.gif"];
        else if([dataObjekt isEqualToString:@"Rein"])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_rein.gif"];
        else
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_elg.gif"];
        
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        element++;
    }
    
    
    // -- HØYDEBEGRENSNING --

    dataObjekt = [data objectForKey:@"hoydebegrensning"];
    if(dataObjekt != nil && ![dataObjekt isEqualToString:@"-1"] && element < antallPlasser)
    {
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"hoydegrense.gif"];
        ((UILabel *)rad[1]).text = [dataObjekt stringByAppendingString:@" m"];
        [(UILabel *)rad[1] setTextColor:[UIColor blackColor]];
        
        if(element == 0)
            [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:45]];
        else if(element < 3)
            [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:30]];
        else
            [(UILabel *)rad[1] setFont:[UIFont boldSystemFontOfSize:15]];
        
        ((UILabel *)rad[2]).text = nil;
        element++;
    }
    
    
    // -- JERNBANEKRYSSING --
    
    dataObjekt = [data objectForKey:@"jernbanekryssing"];
    if(dataObjekt != nil && ![dataObjekt isEqualToString:@"-1"] && element < antallPlasser)
    {
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_jernbane.gif"];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        element++;
    }
    
    
    // -- FARTSDEMPER --
    
    dataObjekt = [data objectForKey:@"fartsdemper"];
    if(dataObjekt != nil && ![dataObjekt isEqualToString:@"-1"] && element < antallPlasser)
    {
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_fartsdemper.gif"];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        element++;
    }
    
    
    while(element < antallPlasser)
    {
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = nil;
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        element++;
    }
}

@end
