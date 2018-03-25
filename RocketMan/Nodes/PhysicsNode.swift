//
//  Character.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 15.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class PhysicsNode: SKSpriteNode{
    
    //MARK: - Game properties
    
    //The frame used for physics calculations
    var physicsFrame: CGRect = CGRect(x:0, y:0, width:0, height:0){
        willSet(newValue){
            if(newValue.width != physicsFrame.width || newValue.height != physicsFrame.height){
                shouldUpdateSensorPoints = true
            }
        }
    }
    var shouldUpdateSensorPoints = false; //If true the sensor points are updated next time the getSensorPoints methodes are called
    var shouldUpdatePhysicsFrameSize = true; //Setting this to false will keep the physicsFrameSize from updating when frame size updates
    var velocity = CGPoint.zero
    var isOnSolidGround = false
    
    //MARK: - Physics Engine Properties
    
    var hasPhysicsFrame = true
    
    override var position: CGPoint{
        willSet(newValue){
            super.position = newValue
            updatePhysicsFramePosition()
        }
    }
    override var size: CGSize{
        willSet(newValue){
            super.size = newValue
            updatePhysicsFrameSize()
        }
    }
    
    //The scale of the physics frame in relation to the actual frame
    var physicsFrameScale:CGPoint = CGPoint(x: 1, y: 1){
        didSet(oldValue){
            updatePhysicsFrameSize()
        }
    }
    
    var isAffectedByGravity = false; //Determines if the nodes velocity is updated with gravity
    var isAffectedByWorldSolids = true //Determines if collision check between node and world tiles are performed
    
    //Sensor points are used for collision detetection. Should only be read throught the get___SensorPoints() methodes
    private var _leftSensorPoints = [CGPoint]()
    private var _rightSensorPoints = [CGPoint]()
    private var _bottomSensorPoints = [CGPoint]()
    private var _topSensorPoints = [CGPoint]()
    
    //MARK: - Debug properties
    
    var shouldDrawFrame = false
    var shouldDrawPhysicsFrame = false
    var shouldDrawSensorPoints = false
    
    //MARK: - System
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(imageNamed: String, shouldHavePhysicsFrame:Bool = true){
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(texture: texture, color: .clear, size: texture.size())
        hasPhysicsFrame = shouldHavePhysicsFrame
        if(hasPhysicsFrame){
            physicsFrame = frame.scale(physicsFrameScale)
            calculateSensorPoints()
        }
    }
    
    //MARK: - Super util overrides
    
    override func scale(to size: CGSize) {
        super.scale(to: size)
        updatePhysicsFrameSize()
    }
    
    override func setScale(_ scale: CGFloat) {
        super.setScale(scale)
        updatePhysicsFrameSize()
    }
    
    //MARK: - Update

    func willUpdatePhysics(){
        isOnSolidGround = false //Will be set in hitSolidGroundMethode()
    }
    
    func didUpdatePhysics(){
        if(shouldDrawFrame) {drawFrame()}
        if(shouldDrawPhysicsFrame && hasPhysicsFrame) {drawPhysicsFrame()}
        if(shouldDrawSensorPoints && hasPhysicsFrame) {drawSensorPoints()}
    }
    
    
    //MARK: - World Interactions
    
    //Called by the physics engine. WorldPosition coordinates are in the world frame!
    func hitSolidLeft(in world: WorldNodes, at worldPosition: CGPoint){}
    func hitSolidRight(in world: WorldNodes, at worldPosition: CGPoint){}
    func hitSolidGround(in world: WorldNodes, at worldPosition: CGPoint){isOnSolidGround = true}
    func hitSolidRoof(in world: WorldNodes, at worldPosition: CGPoint){}
    
    
    //MARK: - physicsFrame
    
    //Moves the node so that the physics frame bottom left corner ends up at the newPosition
    func moveRelativeToPhysicsFrame(to newPosition: CGPoint){
        position.x = newPosition.x - (physicsFrame.minX - frame.minX)
        position.y = newPosition.y - (physicsFrame.minY - frame.minY)
    }
    
    //Updates the size of the physicsFrame in by using the frame parameter
    func updatePhysicsFrameSize(){
        guard shouldUpdatePhysicsFrameSize else {return}
        physicsFrame = frame.scale(physicsFrameScale)
    }
    
    //Updates the position of the physicsFrame in by using the frame parameter
    func updatePhysicsFramePosition(){
        physicsFrame = CGRect(x: frame.minX+frame.width*(1-physicsFrameScale.x)/2, y: frame.minY+frame.height*(1-physicsFrameScale.y)/2, width: physicsFrame.width, height: physicsFrame.height)
    }
    
    //MARK: - Sensor Points
    
    /*
     * Sets the sensor points on each side with a max distance of TILE_SIZE between each sensor point.
     *
     * The sensor points are ment to be used for world collision checks. The points given are relative to the physics frame
     * and should be added to the phyics frame offset(minX and minY) before use in world frame.
     */
    private func calculateSensorPoints(){
        _leftSensorPoints = [CGPoint]()
        _rightSensorPoints = [CGPoint]()
        _topSensorPoints = [CGPoint]()
        _bottomSensorPoints = [CGPoint]()
        
        let height = physicsFrame.height
        let width = physicsFrame.width
        
        let numHorizontal = 2 + Int(width+1)/Int(TILE_SIZE)
        let numVertical = 2 + Int(height+1)/Int(TILE_SIZE)
        let distHorizontal = width/(CGFloat(numHorizontal) - 1)
        let distVertical = height/(CGFloat(numVertical) - 1)
        _leftSensorPoints.append(CGPoint(x: 0, y: 0))
        _rightSensorPoints.append(CGPoint(x: width, y: 0))
        _bottomSensorPoints.append(CGPoint(x: 0, y: 0))
        _topSensorPoints.append(CGPoint(x: 0, y:height))
        
        for i in 1..<(numVertical-1){
            _leftSensorPoints.append(CGPoint(x:0, y: distVertical*CGFloat(i)))
            _rightSensorPoints.append(CGPoint(x:width, y: distVertical*CGFloat(i)))
        }
        
        for i in 1..<(numHorizontal-1){
            _bottomSensorPoints.append(CGPoint(x:CGFloat(i)*distHorizontal, y: 0))
            _topSensorPoints.append(CGPoint(x:CGFloat(i)*distHorizontal, y: height))
        }
        
        _leftSensorPoints.append(CGPoint(x: 0, y: height))
        _rightSensorPoints.append(CGPoint(x: width, y: height))
        _bottomSensorPoints.append(CGPoint(x: width, y: 0))
        _topSensorPoints.append(CGPoint(x: width, y:height))
        shouldUpdateSensorPoints = false
    }
    
    //Returns the sensor points of the left physics frame boundary + physics frame offset in parent node
    func getLeftSensorPoints() -> [CGPoint]{
        if(shouldUpdateSensorPoints){
            calculateSensorPoints()
        }
        var leftSensorPoints = [CGPoint]()
        for point in _leftSensorPoints{
            leftSensorPoints.append(CGPoint(x: physicsFrame.minX + point.x, y: physicsFrame.minY + point.y))
        }
        return leftSensorPoints
    }
    
    //Returns the sensor points of the right physics frame boundry + physics frame offset in parent node
    func getRightSensorPoints() -> [CGPoint]{
        if(shouldUpdateSensorPoints){
            calculateSensorPoints()
        }
        var rightSensorPoints = [CGPoint]()
        for point in _rightSensorPoints{
            rightSensorPoints.append(CGPoint(x: physicsFrame.minX + point.x, y: physicsFrame.minY + point.y))
        }
        return rightSensorPoints
    }
    
    //Returns the sensor points of the top physics frame boundry + physics frame offset in parent node
    func getTopSensorPoints() -> [CGPoint]{
        if(shouldUpdateSensorPoints){
            calculateSensorPoints()
        }
        var topSensorPoints = [CGPoint]()
        for point in _topSensorPoints{
            topSensorPoints.append(CGPoint(x: physicsFrame.minX + point.x, y: physicsFrame.minY + point.y))
        }
        return topSensorPoints
    }
    
    //Returns the sensor points of the bottom physics frame boundry + physics frame offset in parent node
    func getBottomSensorPoints() -> [CGPoint]{
        if(shouldUpdateSensorPoints){
            calculateSensorPoints()
        }
        var bottomSensorPoints = [CGPoint]()
        for point in _bottomSensorPoints{
            bottomSensorPoints.append(CGPoint(x: physicsFrame.minX + point.x, y: physicsFrame.minY + point.y))
        }
        return bottomSensorPoints
    }
    
    //MARK: - Debug
    
    //Draws the frame of the current node
    private var _lastFrameNode: SKShapeNode?
    func drawFrame(){
        _lastFrameNode?.removeFromParent()
        _lastFrameNode = SKShapeNode(rect: frame)
        scene?.addChild(_lastFrameNode!)
    }
    
    //Draws the physicsFrame of the current node
    private var _lastPhysicsFrameNode: SKShapeNode?
    func drawPhysicsFrame(){
        _lastPhysicsFrameNode?.removeFromParent()
        _lastPhysicsFrameNode = SKShapeNode(rect: physicsFrame)
        _lastPhysicsFrameNode?.alpha = 0.5
        _lastPhysicsFrameNode?.fillColor = .red
        scene?.addChild(_lastPhysicsFrameNode!)
    }
    
    //Draws the sensor points of the current node
    private var _lastSensorPointNode: SKSpriteNode?
    func drawSensorPoints(){
        _lastSensorPointNode?.removeFromParent()
        _lastSensorPointNode = SKSpriteNode(color: .clear, size: physicsFrame.size)
        _lastSensorPointNode?.anchorPoint = CGPoint.zero
        
        for point in getLeftSensorPoints(){
            let node = SKShapeNode(circleOfRadius: 6)
            node.position = point
            node.fillColor = .blue
            _lastSensorPointNode!.addChild(node)
        }
        for point in getRightSensorPoints(){
            let node = SKShapeNode(circleOfRadius: 6)
            node.position = point
            node.fillColor = .blue
            _lastSensorPointNode!.addChild(node)
        }
        for point in getTopSensorPoints(){
            let node = SKShapeNode(circleOfRadius: 6)
            node.position = point
            node.fillColor = .blue
            _lastSensorPointNode!.addChild(node)
        }
        for point in getBottomSensorPoints(){
            let node = SKShapeNode(circleOfRadius: 6)
            node.position = point
            node.fillColor = .blue
            _lastSensorPointNode!.addChild(node)
        }
        _lastSensorPointNode!.zPosition = zPosition+1
        scene?.addChild(_lastSensorPointNode!)
    }
    
    override func removeFromParent(){
        _lastFrameNode?.removeFromParent()
        _lastPhysicsFrameNode?.removeFromParent()
        _lastSensorPointNode?.removeFromParent()
        super.removeFromParent()
    }
    
    //MARK: - Data Storage
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
