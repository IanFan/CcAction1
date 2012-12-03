//
//  SimpleActionLayer.h
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface SimpleActionLayer : CCLayer
{
  CCSprite *ballSprite;
  CCLabelTTF *infoLabel;
  
  BOOL isSpriteMoving;
}

@property (nonatomic,retain) CCActionInterval *preActionInterval;

+(CCScene *) scene;

@end
