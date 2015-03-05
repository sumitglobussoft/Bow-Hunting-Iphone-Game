//
//  IAPHelper.h
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "KeychainItemWrapper.h"
#import "VerificationController/VerificationController.h"

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

@protocol IAPHelperDelegate <NSObject>

-(void) updateAfterArrowPurchase:(BOOL)value;

@end

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject<VerificationControllerDelegate>{
    BOOL checkRestore;
    
    //Rajeev
    
//    KeychainItemWrapper *keyChainPowerBooster;
    KeychainItemWrapper *keyChainMultiArrow;
}

@property (nonatomic,retain) id <IAPHelperDelegate> delegate;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;

@end