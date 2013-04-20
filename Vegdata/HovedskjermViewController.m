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
#import <AudioToolbox/AudioToolbox.h>
#import "MapQuestRoute.h"

@interface HovedskjermViewController()
- (IBAction)hudKnappTrykket:(UISwitch *)knapp;
- (BOOL)erFireTommerRetina;
- (BOOL)skalViseHUDKnapp;
+ (NSString *)finnTypeMedStreng:(NSString *)streng;
+ (NSString *)finnAvstandstekstMedStreng:(NSString *)streng ErVariabeltSkilt:(BOOL)erVariabelt;
@end

@implementation HovedskjermViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settOppLayoutArray)
                                                 name:@"appDidBecomeActive" object:nil];*/
	
    self.vegObjKont = [[VegObjektKontroller alloc] initMedDelegate:self
                                            OgManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    
    [self settOppLayoutArray];
    
    NSString * sti = [[NSBundle mainBundle] pathForResource:@"Purr" ofType:@"aiff"];
    SystemSoundID ssid;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:sti], &ssid);
    self.lydID = ssid;
    
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

- (void)settOppLayoutArray
{
    self.key1 = @"";
    self.key2 = @"";
    self.key3 = @"";
    self.key4 = @"";
    self.key5 = @"";
    self.key6 = @"";
    self.key7 = @"";
    
    self.skiltetAvstand1 = @"";
    self.skiltetAvstand2 = @"";
    self.skiltetAvstand3 = @"";
    self.skiltetAvstand4 = @"";
    self.skiltetAvstand5 = @"";
    self.skiltetAvstand6 = @"";
    self.skiltetAvstand7 = @"";
    
    NSMutableArray * retur = [[NSMutableArray alloc] init];
    
    [retur addObject:[@[self.bilde1, self.label1, self.detalj1, self.key1, self.skiltetAvstand1] mutableCopy]];
    [retur addObject:[@[self.bilde2, self.label2, self.detalj2, self.key2, self.skiltetAvstand2] mutableCopy]];
    [retur addObject:[@[self.bilde3, self.label3, self.detalj3, self.key3, self.skiltetAvstand3] mutableCopy]];
    
    if(self.erFireTommerRetina)
    {
        [retur addObject:[@[self.bilde6, self.label6, self.detalj6, self.key6, self.skiltetAvstand6] mutableCopy]];
        [retur addObject:[@[self.bilde7, self.label7, self.detalj7, self.key7, self.skiltetAvstand7] mutableCopy]];
    }
    
    [retur addObject:[@[self.bilde4, self.label4, self.detalj4, self.key4, self.skiltetAvstand4] mutableCopy]];
    
    if(!self.skalViseHUDKnapp)
    {
        self.hudSwitch.hidden = true;
        self.hudLabel.hidden = true;
        [retur addObject:[@[self.bilde5, self.label5, self.detalj5, self.key5, self.skiltetAvstand5] mutableCopy]];
    }
    else
    {
        self.hudSwitch.hidden = false;
        self.hudLabel.hidden = false;
    }
    
    self.layoutArray = retur;
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

- (BOOL)skalViseHUDKnapp
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:HUDKNAPP_BRUKERPREF];
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
    int element = 0;
    int antallPlasser = [self.layoutArray count];
    NSMutableArray * rad;
    NSString * dataObjekt;
    NSString * forrigeObjekt;
    BOOL spillLyd = NO;
    BOOL skalVurdereForkjorsvei = YES;
    
    // -- FARTSGRENSE --
    
    dataObjekt = [data objectForKey:FARTSGRENSE_KEY];
    if(dataObjekt && element < antallPlasser)
    {
        rad = self.layoutArray[element];
        
        if([dataObjekt isEqualToString:INGEN_OBJEKTER])
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
        rad[3] = FARTSGRENSE_KEY;
        rad[4] = @"";
        element++;
    }
    
    
    // -- MOTORVEG --
    
    dataObjekt = [data objectForKey:MOTORVEG_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        rad = self.layoutArray[element];
        
        if([dataObjekt isEqualToString:MOTORVEG_TYPE_MOTORVEG])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"motorveg.gif"];
        else
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"motortrafikkveg.gif"];
        
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = MOTORVEG_KEY;
        rad[4] = @"";
        
        skalVurdereForkjorsvei = NO; // Motorvei erstatter eventuell forkjørsvei
        element++;
    }
    
    
    // -- FORKJØRSVEI --
    
    dataObjekt = [data objectForKey:FORKJORSVEG_KEY];
    if(skalVurdereForkjorsvei && dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"forkjorsvei.gif"];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = FORKJORSVEG_KEY;
        rad[4] = @"";
        element++;
    }
    
    
    // -- VILTTREKK --
    
    dataObjekt = [data objectForKey:VILTTREKK_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:VILTTREKK_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        
        if([dataObjekt isEqualToString:VILTTREKK_TYPE_HJORT])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_hjort.gif"];
        else if([dataObjekt isEqualToString:VILTTREKK_TYPE_REIN])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_rein.gif"];
        else
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_elg.gif"];
        
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = VILTTREKK_KEY;
        rad[4] = @"";
        element++;
    }
    
    
    // -- HØYDEBEGRENSNING --

    dataObjekt = [data objectForKey:HOYDEBEGRENSNING_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:HOYDEBEGRENSNING_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
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
        rad[3] = HOYDEBEGRENSNING_KEY;
        rad[4] = @"";
        element++;
    }
    
    
    // -- JERNBANEKRYSSING --
    
    dataObjekt = [data objectForKey:JERNBANEKRYSSING_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:JERNBANEKRYSSING_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_jernbane.gif"];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = JERNBANEKRYSSING_KEY;
        rad[4] = @"";
        element++;
    }
    
    
    // -- FARTSDEMPER --
    
    dataObjekt = [data objectForKey:FARTSDEMPER_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:FARTSDEMPER_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@"fareskilt_fartsdemper.gif"];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = FARTSDEMPER_KEY;
        rad[4] = @"";
        element++;
    }
    
    
    // -- FARLIG(E) SVING(ER) --
    
    dataObjekt = [data objectForKey:FARLIGSVING_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:FARLIGSVING_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        
        NSString * type = [HovedskjermViewController finnTypeMedStreng:dataObjekt];
        
        if([type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGESVINGER_H])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGESVINGER_V])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_FARLIGSVING_H])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = FARLIGSVING_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:YES];
        element++;
    }
    
    
    // -- BRATT BAKKE --
    
    dataObjekt = [data objectForKey:BRATTBAKKE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:BRATTBAKKE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        
        NSString * type = [HovedskjermViewController finnTypeMedStreng:dataObjekt];
        
        if([type isEqualToString:SKILTPLATE_SKILTNUMMER_BRATTBAKKE_STIGNING])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = BRATTBAKKE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:YES];
        element++;
    }
    
    
    // -- SMALERE VEG --
    
    dataObjekt = [data objectForKey:SMALEREVEG_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:SMALEREVEG_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        
        NSString * type = [HovedskjermViewController finnTypeMedStreng:dataObjekt];
        
        if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SMALEREVEG_H])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else if ([type isEqualToString:SKILTPLATE_SKILTNUMMER_SMALEREVEG_V])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = SMALEREVEG_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:YES];
        element++;
    }
    
    
    // -- UJEVN VEG --
    
    dataObjekt = [data objectForKey:UJEVNVEG_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:UJEVNVEG_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = UJEVNVEG_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- VEGARBEID --
    
    dataObjekt = [data objectForKey:VEGARBEID_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:VEGARBEID_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = VEGARBEID_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- STEINSPRUT --
    
    dataObjekt = [data objectForKey:STEINSPRUT_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:STEINSPRUT_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = STEINSPRUT_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- RASFARE --
    
    dataObjekt = [data objectForKey:RASFARE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:RASFARE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        
        NSString * type = [HovedskjermViewController finnTypeMedStreng:dataObjekt];
        
        if([type isEqualToString:SKILTPLATE_SKILTNUMMER_RASFARE_H])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = RASFARE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:YES];
        element++;
    }
    
    
    // -- GLATT KJØREBANE --
    
    dataObjekt = [data objectForKey:GLATTKJOREBANE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:GLATTKJOREBANE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = GLATTKJOREBANE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- FARLIG VEGSKULDER --
    
    dataObjekt = [data objectForKey:FARLIGVEGSKULDER_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:FARLIGVEGSKULDER_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = FARLIGVEGSKULDER_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- BEVEGELIG BRU --
    
    dataObjekt = [data objectForKey:BEVEGELIGBRU_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:BEVEGELIGBRU_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = BEVEGELIGBRU_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- KAI, STRAND ELLER FERJELEIE --
    
    dataObjekt = [data objectForKey:KAISTRANDFERJELEIE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:KAISTRANDFERJELEIE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = KAISTRANDFERJELEIE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- TUNNEL --
    
    dataObjekt = [data objectForKey:TUNNEL_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:TUNNEL_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = TUNNEL_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- FARLIG VEGKRYSS --
    
    dataObjekt = [data objectForKey:FARLIGVEGKRYSS_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:FARLIGVEGKRYSS_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = FARLIGVEGKRYSS_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- RUNDKJØRING --
    
    dataObjekt = [data objectForKey:RUNDKJORING_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:RUNDKJORING_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = RUNDKJORING_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- TRAFIKKLYSSIGNAL --
    
    dataObjekt = [data objectForKey:TRAFIKKLYSSIGNAL_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:TRAFIKKLYSSIGNAL_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = TRAFIKKLYSSIGNAL_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- AVSTAND TIL GANGFELT --
    
    dataObjekt = [data objectForKey:AVSTANDTILGANGFELT_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:AVSTANDTILGANGFELT_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = AVSTANDTILGANGFELT_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- BARN --
    
    dataObjekt = [data objectForKey:BARN_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:BARN_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = BARN_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- SYKLENDE --
    
    dataObjekt = [data objectForKey:SYKLENDE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:SYKLENDE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = SYKLENDE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- KU --
    
    dataObjekt = [data objectForKey:KU_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:KU_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = KU_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- SAU --
    
    dataObjekt = [data objectForKey:SAU_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:SAU_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = SAU_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- MØTENDE TRAFIKK --
    
    dataObjekt = [data objectForKey:MOTENDETRAFIKK_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:MOTENDETRAFIKK_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = MOTENDETRAFIKK_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- KØ --
    
    dataObjekt = [data objectForKey:KO_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:KO_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = KO_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- FLY --
    
    dataObjekt = [data objectForKey:FLY_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:FLY_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = FLY_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- SIDEVIND --
    
    dataObjekt = [data objectForKey:SIDEVIND_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:SIDEVIND_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = SIDEVIND_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- SKILØPERE --
    
    dataObjekt = [data objectForKey:SKILOPERE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:SKILOPERE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = SKILOPERE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- RIDENDE --
    
    dataObjekt = [data objectForKey:RIDENDE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:RIDENDE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = RIDENDE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- ANNEN FARE --
    
    dataObjekt = [data objectForKey:ANNENFARE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:ANNENFARE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = ANNENFARE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- AUTOMATISK TRAFIKKONTROLL --
    
    dataObjekt = [data objectForKey:AUTOMATISKTRAFIKKONTROLL_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:AUTOMATISKTRAFIKKONTROLL_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = AUTOMATISKTRAFIKKONTROLL_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    
    // -- VIDEOKONTROLL / -OVERVÅKNING --
    
    dataObjekt = [data objectForKey:VIDEOKONTROLL_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:VIDEOKONTROLL_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = VIDEOKONTROLL_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:NO];
        element++;
    }
    
    // -- SÆRLIG ULYKKESFARE --
    
    dataObjekt = [data objectForKey:SAERLIGULYKKESFARE_KEY];
    if(dataObjekt && ![dataObjekt isEqualToString:INGEN_OBJEKTER] && element < antallPlasser)
    {
        forrigeObjekt = [self.nyesteData objectForKey:SAERLIGULYKKESFARE_KEY];
        if(!forrigeObjekt || [forrigeObjekt isEqualToString:INGEN_OBJEKTER])
            spillLyd = YES;
        
        rad = self.layoutArray[element];
        
        NSString * type = [HovedskjermViewController finnTypeMedStreng:dataObjekt];
        
        if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_1])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_2])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_3])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else if([type isEqualToString:SKILTPLATE_SKILTNUMMER_SAERLIGULYKKESFARE_4])
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];
        else
            ((UIImageView *)rad[0]).image = [UIImage imageNamed:@""];

        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = SAERLIGULYKKESFARE_KEY;
        rad[4] = [HovedskjermViewController finnAvstandstekstMedStreng:dataObjekt ErVariabeltSkilt:YES];
        element++;
    }
    
    
    while(element < antallPlasser)
    {
        rad = self.layoutArray[element];
        ((UIImageView *)rad[0]).image = nil;
        ((UILabel *)rad[1]).text = nil;
        ((UILabel *)rad[2]).text = nil;
        rad[3] = @"";
        rad[4] = @"";
        element++;
    }
    
    BOOL lydvarslingErAktivert = [[NSUserDefaults standardUserDefaults] boolForKey:LYDVARSLING_BRUKERPREF];
    if(lydvarslingErAktivert && spillLyd)
        AudioServicesPlaySystemSound(self.lydID);
    
    self.nyesteData = data;
}

- (void)avstandTilPunktobjekt:(NSDecimalNumber *)avstand MedKey:(NSString *)key
{
    for(NSMutableArray * rad in self.layoutArray)
    {
        if([rad[3] isEqualToString:key])
        {
            NSDecimalNumber * nyAvstand = [[NSDecimalNumber alloc] initWithDouble:avstand.doubleValue];
            
            if([rad[4] length] > 0)
            {
                NSError * feil = nil;
                
                NSRegularExpression * tallRegex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9,.]+" options:NSRegularExpressionCaseInsensitive error:&feil];
                
                if(feil)
                {
                    NSLog(@"\n### Ukjent feil ved oppretting av RegEx.");
                    break;
                }
                
                feil = nil;
                
                NSRegularExpression * kmRegex = [NSRegularExpression regularExpressionWithPattern:@"km" options:NSRegularExpressionCaseInsensitive error:&feil];
                
                if(feil)
                {
                    NSLog(@"\n### Ukjent feil ved oppretting av RegEx.");
                    break;
                }
                
                NSRegularExpression * kommaRegex = [NSRegularExpression regularExpressionWithPattern:@"," options:0 error:&feil];
                
                feil = nil;
                
                if(feil)
                {
                    NSLog(@"\n### Ukjent feil ved oppretting av RegEx.");
                    break;
                }
                
                NSArray * avstandstall = [tallRegex matchesInString:rad[4] options:0 range:NSMakeRange(0, [rad[4] length])];
                
                if(!avstandstall || [avstandstall count] == 0)
                {
                    NSLog(@"\n### Ukjent feil ved tolking av tekstskilt.");
                    break;
                }
                
                NSString * avstandsstreng = [rad[4] substringWithRange:((NSTextCheckingResult *)avstandstall[0]).range];
                
                if([avstandsstreng length] == 0)
                {
                    NSLog(@"\n### Ukjent feil ved tolking av tekstskilt.");
                    break;
                }
                
                avstandsstreng = [kommaRegex stringByReplacingMatchesInString:avstandsstreng
                                                                      options:0
                                                                        range:NSMakeRange(0, [rad[4] length])
                                                                 withTemplate:@"."];
                
                if([avstandsstreng length] == 0)
                {
                    NSLog(@"\n### Ukjent feil ved tolking av tekstskilt.");
                    break;
                }
                
                NSDecimalNumber * avstandstillegg = [[NSDecimalNumber alloc] initWithString:avstandsstreng];
                
                if(!avstandstillegg)
                {
                    NSLog(@"\n### Ukjent feil ved tolking av tekstskilt.");
                    break;
                }
                
                NSArray * km = [kmRegex matchesInString:rad[4] options:0 range:NSMakeRange(0, [rad[4] length])];
                
                if(km && [km count] > 0)
                    nyAvstand = [nyAvstand decimalNumberByAdding:avstandstillegg];
                else
                    nyAvstand = [nyAvstand decimalNumberByAdding:
                                 [avstandstillegg decimalNumberByDividingBy:
                                  [[NSDecimalNumber alloc] initWithInt:1000]]];
                
            }
            
            if(nyAvstand.doubleValue < 1)
            {
                NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:-1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber * meter = [nyAvstand decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithInt:1000] withBehavior:handler];
                ((UILabel *)rad[2]).text =  [[meter stringValue] stringByAppendingString:@" m"];
            }
            else if(nyAvstand.doubleValue < 10)
            {
                NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber * km = [nyAvstand decimalNumberByRoundingAccordingToBehavior:handler];
                ((UILabel *)rad[2]).text =  [[km stringValue] stringByAppendingString:@" km"];
            }
            else
            {
                NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber * km = [nyAvstand decimalNumberByRoundingAccordingToBehavior:handler];
                ((UILabel *)rad[2]).text =  [[km stringValue] stringByAppendingString:@" km"];
            }

            break;
        }
    }
}

#pragma mark - Statiske hjelpemetoder for strengtolkning

+ (NSString *)finnTypeMedStreng:(NSString *)streng
{
    NSRange skille = [streng rangeOfString:SKILLETEGN_SKILTOBJEKTER];
    
    if(skille.location == NSNotFound)
        return streng;
    
    return [streng substringToIndex:skille.location];
}

+ (NSString *)finnAvstandstekstMedStreng:(NSString *)streng ErVariabeltSkilt:(BOOL)erVariabelt
{
    NSRange skille = [streng rangeOfString:SKILLETEGN_SKILTOBJEKTER];
    
    if(skille.location == NSNotFound)
    {
        if(erVariabelt)
            return @"";
        return streng;
    }
    
    return [streng substringFromIndex:skille.location+1];
}

@end
