//
//  MCManager.h
//  MultiPeerTest
//
//  Created by Minh Nguyen on 4/6/14.
//  Copyright (c) 2014 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCSession * session;
@property (nonatomic, strong) MCPeerID * localPeerId;
@property (nonatomic, strong) MCNearbyServiceBrowser * browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser * advertiser;
@property (nonatomic, strong) MCAdvertiserAssistant * assistant;

+(MCManager *)instance;

@end
