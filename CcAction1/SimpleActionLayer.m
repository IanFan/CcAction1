//
//  SimpleActionLayer.m
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleActionLayer.h"

@implementation SimpleActionLayer

@synthesize preActionInterval;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];	
	SimpleActionLayer *layer = [SimpleActionLayer node];
	[scene addChild: layer];
  
	return scene;
}

#pragma mark -
#pragma mark Update

-(void)update:(ccTime)dt {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  //if the ball out of the board or the ball is too big or too small, just default position and scale of the ball.
  int halfLength = 0.5*ballSprite.boundingBox.size.width;
  int maxX = winSize.width + halfLength;
  int minX = -halfLength;
  int maxY = winSize.height + halfLength;
  int minY = -halfLength;
  float maxScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? 10:38;
  float minScale = 0.06;
  
  if (ballSprite.position.x > maxX || ballSprite.position.x < minX || ballSprite.position.y > maxY || ballSprite.position.y < minY || ballSprite.scale > maxScale || ballSprite.scale < minScale) {
    [self CCPlace];
  }  
  
  //informationLabel always below the ball
  int belowDis = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? -70:-150;
  [infoLabel setPosition:ccp(ballSprite.position.x, ballSprite.position.y + belowDis)];
}

#pragma mark -
#pragma mark CCAction

//Position:
-(void)CCPlace {
  [ballSprite stopAllActions];
  
  CGSize screen = [CCDirector sharedDirector].winSize;
  id placeAction = [CCPlace actionWithPosition:ccp(screen.width/2, screen.height/2)];
  [ballSprite runAction:placeAction];
  
  [ballSprite setScale:1];
  [ballSprite setRotation:0];
  [ballSprite setOpacity:255];
  [ballSprite runAction:[CCShow action]];
  
  [infoLabel setString:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",@"Place on Default Position",@"Stop All Actions",@"Set Scale: 1.0",@"Set Rotation: 0",@"Set Opacity: 255",@"CCShow"]];
  isSpriteMoving = NO;
}

-(void)CCMoveBy {
  if (isSpriteMoving == YES) return;
  
  id moveByAction = [CCMoveBy actionWithDuration:1 position:ccp(98, 0)];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"CCMoveBy End"];
  
  [ballSprite runAction:[CCSequence actions:moveByAction,callFuncNDAction, nil]];
  
  [infoLabel setString:@"CCMoveBy is Acting"];
  isSpriteMoving = YES;
  self.preActionInterval = moveByAction;
}

-(void)CCBezierBy {
  if (isSpriteMoving == YES) return;
  
  ccBezierConfig bezierConfig;
  bezierConfig.controlPoint_1 = ccp(0, 98);
  bezierConfig.controlPoint_2 = ccp(98, -98);
  bezierConfig.endPosition = ccp(98,49);
  id bezierByAction = [CCBezierBy actionWithDuration:1 bezier:bezierConfig];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"CCBezierBy End"];
  
  [ballSprite runAction:[CCSequence actions:bezierByAction,callFuncNDAction, nil]];
  
  [infoLabel setString:@"CCBezierBy is Acting"];
  isSpriteMoving = YES;
  self.preActionInterval = bezierByAction;
}

-(void)CCJumpBy {
  if (isSpriteMoving == YES) return;
  
  id jumpByAction = [CCJumpBy actionWithDuration:1.5 position:ccp(0, 0) height:150 jumps:1];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"CCJumpBy End"];
  
  [ballSprite runAction:[CCSequence actions:jumpByAction,callFuncNDAction, nil]];
  
  [infoLabel setString:@"CCJumpBy is Acting"];
  isSpriteMoving = YES;
  self.preActionInterval = jumpByAction;
}

//Rotation:
-(void)CCRotateBy {
  id rotationByAction = [CCRotateBy actionWithDuration:1 angle:360];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"CCRotateBy End"];
  
  [ballSprite runAction:[CCSequence actions:rotationByAction,callFuncNDAction, nil]];
  
  [infoLabel setString:@"CCRotateBy is Acting"];
  isSpriteMoving = YES;
  self.preActionInterval = rotationByAction;
}

//Scale:
-(void)CCScaleBy {
  if (isSpriteMoving == YES) return;
  
  id scaleByAction = [CCScaleBy actionWithDuration:1 scale:1.5];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"CCScaleBy End"];
  
  [ballSprite runAction:[CCSequence actions:scaleByAction,callFuncNDAction, nil]];
  
  [infoLabel setString:@"CCScaleBy is Acting"];
  isSpriteMoving = YES;
  self.preActionInterval = scaleByAction;
}

//ReverseAciton:
-(void)Reverse {
  if (isSpriteMoving == YES) return;
  
  id reverseAction = [preActionInterval reverse];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"Reverse End"];
  
  [ballSprite runAction:[CCSequence actions:reverseAction,callFuncNDAction, nil]];
  
  [infoLabel setString:@"Reverse is Acting"];
  isSpriteMoving = YES;
  self.preActionInterval = reverseAction;
}

//Spawn Actions
-(void)CCSpawn {
  if (isSpriteMoving == YES) return;
  
  CGSize screen = [CCDirector sharedDirector].winSize;
  id moveByAction = [CCMoveBy actionWithDuration:1 position:ccp(screen.width/10, 0)];
  id jumpByAction = [CCJumpBy actionWithDuration:1 position:ccp(0, 0) height:150 jumps:1];
  id scaleByAction = [CCScaleBy actionWithDuration:1 scale:1.0/1.5];
  id rotationByAction = [CCRotateBy actionWithDuration:1 angle:360];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"CCSpawn End"];

  CCSpawn *spawn = [CCSpawn actions:moveByAction,jumpByAction,scaleByAction,rotationByAction,nil];
  [ballSprite runAction:[CCSequence actions:spawn,callFuncNDAction, nil]];
  
  [infoLabel setString:@"CCSpawn is Acting"];
  isSpriteMoving = YES;
  self.preActionInterval = spawn;
}

//Sequence Actions
-(void)CCSequence {
  if (isSpriteMoving == YES) return;
  
  id moveByAction = [CCMoveBy actionWithDuration:0.5 position:ccp(98, 0)];
  id scaleByAction = [CCScaleBy actionWithDuration:0.5 scale:1.5];
  id rotationByAction = [CCRotateBy actionWithDuration:0.5 angle:360];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"CCSequence End"];
  
  CCSequence *sequence = [CCSequence actions:moveByAction,scaleByAction,rotationByAction,[rotationByAction reverse],[scaleByAction reverse],[moveByAction reverse],nil];
  [ballSprite runAction:[CCSequence actions:sequence,callFuncNDAction, nil]];
  
  [infoLabel setString:@"CCSequence is Acting"];
  isSpriteMoving = YES;
  self.preActionInterval = sequence;
}

//Repeat Action:
-(void)CCRepeat {
  if (isSpriteMoving == YES) return;
  
  id repeatAction = [CCRepeat actionWithAction:preActionInterval times:2];
  id callFuncNDAction = [CCCallFuncND actionWithTarget:self selector:@selector(doCallFuncND: data:) data:@"CCRepeat End"];
  
  [ballSprite runAction:[CCSequence actions:repeatAction,callFuncNDAction, nil]];
  
  [infoLabel setString:@"CCRepeat is Acting"];
  isSpriteMoving = YES;
}

-(void)doCallFuncND:(id)sender data:(void*)data {
  [infoLabel setString:data];
  isSpriteMoving = NO;
}

#pragma mark -
#pragma mark ActionMenu

-(void)setActionMenu {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  int fontSize = 20;
  
  CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Place&Defaut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(CCPlace)];
  
  CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"MoveBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(CCMoveBy)];
  
  CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"BezierBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(CCBezierBy)];
  
  CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"JumpBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(CCJumpBy)];
  
  CCLabelTTF *label5 = [CCLabelTTF labelWithString:@"RotateBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel5 = [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(CCRotateBy)];
  
  CCLabelTTF *label6 = [CCLabelTTF labelWithString:@"ScaleBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel6 = [CCMenuItemLabel itemWithLabel:label6 target:self selector:@selector(CCScaleBy)];
  
  CCLabelTTF *label7 = [CCLabelTTF labelWithString:@"Reverse" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel7 = [CCMenuItemLabel itemWithLabel:label7 target:self selector:@selector(Reverse)];
  
  CCLabelTTF *label8 = [CCLabelTTF labelWithString:@"Spawn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel8 = [CCMenuItemLabel itemWithLabel:label8 target:self selector:@selector(CCSpawn)];
  
  CCLabelTTF *label9 = [CCLabelTTF labelWithString:@"Sequence" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel9 = [CCMenuItemLabel itemWithLabel:label9 target:self selector:@selector(CCSequence)];
  
  CCLabelTTF *label10 = [CCLabelTTF labelWithString:@"Repeat" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel10 = [CCMenuItemLabel itemWithLabel:label10 target:self selector:@selector(CCRepeat)];
  
  CCMenu *menu = [CCMenu menuWithItems:menuItemLabel1,menuItemLabel2,menuItemLabel3,menuItemLabel4,menuItemLabel5,menuItemLabel6,menuItemLabel7,menuItemLabel8,menuItemLabel9,menuItemLabel10, nil];
  [menu alignItemsVertically];
  [self addChild:menu];
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    [menu setPosition:CGPointMake(90, winSize.height/2)];
  }else {
    [menu setPosition:CGPointMake(90, winSize.height/2-200)];
  }
}

#pragma mark -
#pragma mark InformationLabel

-(void)setInformationLabel {
  int fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? 16:28;
  int belowDis = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? -70:-150;
  
  infoLabel = [CCLabelTTF labelWithString:@"Tap An ActionItem" fontName:@"Helvetica" fontSize:fontSize];
  [infoLabel setPosition:ccp(ballSprite.position.x, ballSprite.position.y + belowDis)];
  [self addChild:infoLabel];
}

#pragma mark -
#pragma mark Ball

-(void)setBallAndDefaultAction {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  ballSprite = [CCSprite spriteWithFile:@"ball.png"];
  ballSprite.position = ccp(winSize.width/2, winSize.height/2);
  [self addChild:ballSprite];
  
  self.preActionInterval = [CCMoveBy actionWithDuration:1 position:ccp(98, 0)];
  
  isSpriteMoving = NO;
}

#pragma mark -
#pragma mark Init

/*
 Target: Run many types of CCAction with the CCSrpite, know when the action started and finished.
 
 1. Set the ball, action menu, and information label
 2. Tap any CCMenuItem in CCMenu to make the sprite run the specific CCAction.
 3. Information label will show when the action started and finished.
 4. Update function to make sure the ball have proper scale and in proper place.
 */

-(id)init {
	if( (self = [super init]) ) {
    [self setBallAndDefaultAction];
    
    [self setInformationLabel];
    
    [self setActionMenu];
    
    [self schedule:@selector(update:) interval:1.0f/60.0f];
	}
  
	return self;
}

-(void)dealloc {
  self.preActionInterval = nil;
  
	[super dealloc];
}

@end
