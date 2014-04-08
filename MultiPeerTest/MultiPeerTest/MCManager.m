//
//  MCManager.m
//  MultiPeerTest
//
//  Created by Minh Nguyen on 4/6/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import "MCManager.h"

static NSString * const XXServiceType = @"mp-test";

@implementation MCManager

+ (MCManager *)instance {
    static MCManager *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[MCManager alloc] init];
    });
    
    return _instance;
}

- (id)init {
    self = [super init];
    
    self.localPeerId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    self.session = [[MCSession alloc] initWithPeer:self.localPeerId];
    self.session.delegate = self;
    
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerId serviceType:XXServiceType];
    self.browser.delegate = self;

    //self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerId
      //                                                  discoveryInfo:nil
        //                                                  serviceType:XXServiceType];
    
    NSLog(@"Start advertising");
    //[self.advertiser startAdvertisingPeer];
    
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:XXServiceType discoveryInfo:nil session:self.session];
    [self.assistant start];
    return self;
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    
    //if ([self.mutableBlockedPeers containsObject:peerID]) {
    //    invitationHandler(NO, nil);
    //    return;
    // }
    NSLog(@"Did receive invitation from peer");
    MCSession *session = [[MCSession alloc] initWithPeer:_localPeerId
                                        securityIdentity:nil
                                    encryptionPreference:MCEncryptionNone];
    session.delegate = self;
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"didReceiveData");
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"didChangeState");
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSLog(@"Found peer");
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"Lost peer");
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    NSLog(@"Did not start browsing for peers");
}


@end
