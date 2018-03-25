//
//  ReusableNodes.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 25.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import Foundation

class ReusableNodes<NodeType>{
    
    /*
     * A thread safe class for queueing and dequeueing reusable nodes
     */
    
    private var _reusableNodes = [NodeType]()
    private var _accessQueue: DispatchQueue
    
    init(label: String){
        _accessQueue = DispatchQueue(label: label)
    }
    
    func deque() -> NodeType?{
        var node: NodeType? = nil
            if (self._reusableNodes.count > 0){
                node = self._reusableNodes.remove(at: self._reusableNodes.count-1)
        }
        return node
    }
    
    func queue(_ node: NodeType){
        self._reusableNodes.append(node)
    }
    
    func reset(){
        self._reusableNodes = [NodeType]()
    }
}

