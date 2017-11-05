//
//  BinaryHeap.swift
//  Heap
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Silverback IT. All rights reserved.
//

import Foundation

public struct BinaryHeap<Element>
{
    public init<S: Sequence>(elements: S, isOrderedBefore: @escaping (Element, Element) -> Bool) where S.Iterator.Element == Element
    {
        self.isOrderedBefore = isOrderedBefore
        for e in elements
        {
            push(e)
        }
    }
    
    public init(isOrderedBefore: @escaping (Element, Element) -> Bool)
    {
        self.isOrderedBefore = isOrderedBefore
    }
    
    public var count : Int { return heap.count }
    
    public var isEmpty : Bool { return heap.isEmpty }
    
    /**
     Push a new element onto the heap
     - parameter element: The element to add to the heap
     */
    public mutating func push(_ element: Element)
    {
        // use only append() and removeLast(), as they are MUCH faster than any other Array insert/remove
        heap.append(element)
        
        siftUp()
    }
    
    /**
     Peek at the top of the heap (the smallest (by isOrderedBefore) element)
     - returns: The top of the heap (or nil if the heap is empty)
    */
    public func peek() -> Element?
    {
        return heap.first
    }
    
    /** Removes the top of the heap (the smallest (by isOrderedBefore) element) and rebalances the heap
     
     - returns: the top of the heap (or nil if the heap is empty
     */
    public mutating func pop() -> Element?
    {
        let result: Element?
        
        switch heap.endIndex
        {
        case 0:
            result = nil
            
        case 1:
            result = heap.removeLast()
            
        case 2:
            result = heap.removeFirst()
            
        default:
            heap.swapAt(heap.startIndex, heap.endIndex - 1)
            
            result = heap.removeLast()
            
            siftDown()
        }
        
        return result
    }
    
    // MARK: - Private
    
    // The actual heap of elements
    private var heap = Array<Element>()
    
    // The less-than closure
    private let isOrderedBefore: (Element, Element) -> Bool
    
    private func parentIndex(forChildIndex childIndex: Int) -> Int?
    {
        guard childIndex > 0 else { return nil }
        
        return (childIndex - 1) / 2
    }

    private func indexForLeastChildOfParent(atIndex parentIndex: Int) -> Int?
    {
        var childIndex : Int?
        
        let leftChildIndex = 2 * parentIndex + 1
        
        if leftChildIndex < heap.endIndex
        {
            childIndex = leftChildIndex
        }
        
        let rightChildIndex = leftChildIndex + 1
        
        if rightChildIndex < heap.endIndex
        {
            if isOrderedBefore(heap[rightChildIndex], heap[leftChildIndex])
            {
                childIndex = rightChildIndex
            }
        }
        
        return childIndex
    }
    
    // Moves the top of the heap "down" to its proper position
    private mutating func siftDown()
    {
        guard heap.endIndex > 1 else { return }
        
        var parentIndex = heap.startIndex
        
        while let leastChildIndex = indexForLeastChildOfParent(atIndex: parentIndex)
        {
            if isOrderedBefore(heap[parentIndex], heap[leastChildIndex]) { break }
            
            heap.swapAt(leastChildIndex, parentIndex)
            
            parentIndex = leastChildIndex
        }
    }
    
    // Moves the bottom/last element "up" through the heap to its proper position
    private mutating func siftUp()
    {
        guard heap.endIndex > 1 else { return }
        
        var childIndex = heap.endIndex - 1
        
        while let parentIndex = parentIndex(forChildIndex: childIndex)
        {
            if isOrderedBefore(heap[parentIndex], heap[childIndex]) { break }
            
            heap.swapAt(childIndex, parentIndex)
            
            childIndex = parentIndex
        }
    }
}

// MARK: - Comparable

extension BinaryHeap where Element : Comparable
{
    public init()
    {
        self.init(isOrderedBefore: <)
    }
    
    public init<S: Sequence>(elements: S) where S.Iterator.Element == Element
    {
        self.init(elements: elements, isOrderedBefore: <)
    }
}
