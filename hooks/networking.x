#import "TikTokHeaders.h"
#import "common.h"

%hook SparkViewController // alwaysOpenSafari
- (void)viewWillAppear:(BOOL)animated {
    if (![DouXManager alwaysOpenSafari]) {
        return %orig;
    }
    
    // NSURL *url = self.originURL;
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.originURL resolvingAgainstBaseURL:NO];
    NSString *searchParameter = @"url";
    NSString *searchValue = nil;
    
    for (NSURLQueryItem *queryItem in components.queryItems) {
        if ([queryItem.name isEqualToString:searchParameter]) {
            searchValue = queryItem.value;
            break;
        }
    }
    
    // In-app browser is used for two-factor authentication with security key,
    // login will not complete successfully if it's redirected to Safari
    // if ([urlStr containsString:@"twitter.com/account/"] || [urlStr containsString:@"twitter.com/i/flow/"]) {
    //     return %orig;
    // }

    if (searchValue) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:searchValue] options:@{} completionHandler:nil];
        [self didTapCloseButton];
    } else {
        return %orig;
    }
}
%end

%hook CTCarrier // changes country 
- (NSString *)mobileCountryCode {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"mcc"];
        }
        return %orig;
    }
    return %orig;
}

- (void)setIsoCountryCode:(NSString *)arg1 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return %orig(selectedRegion[@"code"]);
        }
        return %orig(arg1);
    }
    return %orig(arg1);
}

- (NSString *)isoCountryCode {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}

- (NSString *)mobileNetworkCode {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"mnc"];
        }
        return %orig;
    }
    return %orig;
}
%end
%hook TTKStoreRegionService
- (id)storeRegion {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return [selectedRegion[@"code"] lowercaseString];
        }
        return %orig;
    }
    return %orig;
}
- (id)getStoreRegion {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return [selectedRegion[@"code"] lowercaseString];
        }
        return %orig;
    }
    return %orig;
}
- (void)setStoreRegion:(id)arg1 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return %orig([selectedRegion[@"code"] lowercaseString]);
        }
        return %orig(arg1);
    }
    return %orig(arg1);
}
%end
%hook TIKTOKRegionManager
+ (NSString *)systemRegion {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}
+ (id)region {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}
+ (id)mccmnc {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return [NSString stringWithFormat:@"%@%@", selectedRegion[@"mcc"], selectedRegion[@"mnc"]];
        }
        return %orig;
    }
    return %orig;
}
+ (id)storeRegion {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}
+ (id)currentRegionV2 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}
+ (id)localRegion {
        if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}

%end

%hook TTKPassportAppStoreRegionModel
- (id)storeRegion {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return [selectedRegion[@"code"] lowercaseString];
        }
        return %orig;
    }
    return %orig;
}
- (void)setStoreRegion:(id)arg1 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return %orig([selectedRegion[@"code"] lowercaseString]);
        }
        return %orig(arg1);
    }
    return %orig(arg1);
}
- (void)setLocalizedCountryName:(id)arg1 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return %orig(selectedRegion[@"name"]);
        }
        return %orig(arg1);
    }
    return %orig(arg1);
}
- (id)localizedCountryName {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"name"];
        }
        return %orig;
    }
    return %orig;
}
%end

%hook ATSRegionCacheManager
- (id)getRegion {
 if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return [selectedRegion[@"code"] lowercaseString];
        }
        return %orig;
    }
    return %orig;
}
- (id)storeRegionFromCache {
 if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return [selectedRegion[@"code"] lowercaseString];
        }
        return %orig;
    }
    return %orig;
}
- (id)storeRegionFromTTNetNotification:(id)arg1 {
 if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return [selectedRegion[@"code"] lowercaseString];
        }
        return %orig;
    }
    return %orig;
}
- (void)setRegion:(id)arg1 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return %orig([selectedRegion[@"code"] lowercaseString]);
        }
        return %orig(arg1);
    }
    return %orig(arg1);
}
- (id)region {
 if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return [selectedRegion[@"code"] lowercaseString];
        }
        return %orig;
    }
    return %orig;
}
%end

%hook TTKStoreRegionModel
- (id)storeRegion {
 if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}
- (void)setStoreRegion:(id)arg1 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return %orig(selectedRegion[@"code"]);
        }
        return %orig(arg1);
    }
    return %orig(arg1);
}
%end

%hook TTInstallIDManager
- (id)currentAppRegion {
 if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}
- (void)setCurrentAppRegion:(id)arg1 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return %orig(selectedRegion[@"code"]);
        }
        return %orig(arg1);
    }
    return %orig(arg1);
}
%end

%hook BDInstallGlobalConfig
- (id)currentAppRegion {
 if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return selectedRegion[@"code"];
        }
        return %orig;
    }
    return %orig;
}
- (void)setCurrentAppRegion:(id)arg1 {
    if ([DouXManager regionChangingEnabled]) {
        if ([DouXManager selectedRegion]) {
            NSDictionary *selectedRegion = [DouXManager selectedRegion];
            return %orig(selectedRegion[@"code"]);
        }
        return %orig(arg1);
    }
    return %orig(arg1);
}
%end