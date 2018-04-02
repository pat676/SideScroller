//
//  Constants.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 13.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

//MARK: SYSTEM CONSTANTS

let MAX_ASPECT_RATIO:CGFloat = 16.0/9.0 //Max aspect ration for the used devices
let MAX_DT:TimeInterval = 1/30

//WORLD CONSTANTS

let GRAVITY: CGFloat = -1400
let CAMERA_VELOCITY: CGFloat = 400
let TILE_SIZE:CGFloat = 64 //Standard tile size
let REMOVE_NODES_DISTANCE: CGFloat = 1000 //Removes nodes when they are this distance outside viewable screen

//DESTROYED_TILES_NUMBER

let DESTROYED_TILES_NUMBER: Int = 2
let DESTROYED_TILE_ALPHA: CGFloat = 0.8
let DESTROYED_TILE_MAX_VELOCITY: UInt32 = 500 //The max velocity a destroyed tile starts with
let DESTROYED_TILE_SIZE_MULTIPLIER:CGFloat = 0.4 //The scaling constant of TILE_SIZE
let DESTROYED_TILE_ROTATION_SPEED:CGFloat = 0.4 //Lower numbers give higher speed

//TOUCH CONSTANTS

// Splits the screen in two parts where a touch at a position further left than LEFT_SCREEM_AMOUNT * screen width
// is considered as a touch on the left screen
let LEFT_SCREEN_AMOUNT: CGFloat = 0.3


//PLAYER CONSTANTS
let PLAYER_MARGIN: CGFloat = 250 //The default distance to the left camera corner
let PLAYER_VELOCITY_OFF_MARGIN_MUL: CGFloat = 0.3 //Velocity increase/decrease if the player is off margin
let PLAYER_PHYSICS_FRAME_SCALE = CGPoint(x: 0.4, y: 0.8)

let PLAYER_JUMP_SPEED: CGFloat = 1000
let STANDARD_TIME_PER_FRAME:TimeInterval = 0.05
let SHOOTING_TIME_PER_FRAME:TimeInterval = 0.1

let PLAYER_BULLET_DAMAGE:CGFloat = 0
let PLAYER_BULLET_DAMAGE_TYPE:DamageType = .Piercing
let PLAYER_BULLET_DAMAGE_PUSHBACK:CGFloat = 0

let PLAYER_BULLET_AOE_RANGE = CGPoint(x: 40, y: 40)
let PLAYER_BULLET_AOE_DAMAGE:CGFloat = 100
let PLAYER_BULLET_AOE_DAMAGE_TYPE:DamageType = .Explosion
let PLAYER_BULLET_AOE_DAMAGE_PUSHBACK: CGFloat = 1

let PLAYER_BULLET_PHYSICS_FRAME_SCALE = CGPoint(x: 0.8, y: 0.8)
let PLAYER_BULLET_SPEED: CGFloat = 1500

let PLAYER_MUZZLE_POSITION = CGPoint(x: 0.87, y: 0.5)

//The time used to scale the bullet from 0 to bullet size when fired
let PLAYER_BULLET_SCALE_DURATION:TimeInterval = 0.2
// The bullet starts at player.position + player.size * PLAYER_BULLET_START_POSITION
let PLAYER_BULLET_START_POSITION = CGPoint(x: PLAYER_MUZZLE_POSITION.x - 0.15, y: PLAYER_MUZZLE_POSITION.y)

//LIVING CONSTANTS:
let LIVING_STANDARD_DEATH_PUSHBACK = CGPoint(x: 800, y: 800)
let LIVING_STANDARD_DEATH_ROTATION_ANGLE:CGFloat = CGFloat.pi
let LIVING_DEATH_ROTATION_TIME:TimeInterval = 2

//ZOMBIE CONSTANTS
let ZOMBIE_PHYSICS_FRAME_SCALE = CGPoint(x: 0.4, y: 0.8)

let ZOMBIE_SPEED:CGFloat = 100;
let ZOMBIE_VIEW_DISTANCE: CGFloat = 1500 
let ZOMBIE_DAMAGE:CGFloat = 1
let ZOMBIE_PUSHBACK:CGFloat = 0
let ZOMBIE_HEALTH: CGFloat = 100

let ZOMBIE_IDLE_TIME_PER_FRAME:TimeInterval = 8
let ZOMBIE_MOVE_TIME_PER_FRAME:TimeInterval = 8
let ZOMBIE_BLOOD_POSITION = CGPoint(x: 0.7, y: 0.3)
