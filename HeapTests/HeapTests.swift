//
//  HeapTests.swift
//  HeapTests
//
//  Created by Christian Otkjær on 06/11/16.
//  Copyright © 2016 Silverback IT. All rights reserved.
//

import XCTest
@testable import Heap

class HeapTests: XCTestCase
{
    func elements() -> Array<(Int, Float)>
    {
        return stride(from: 0, to: 10000, by: 1).map({(Int(arc4random()), Float($0))})
    }
    
    func test_init_heap()
    {
        let _ = BinaryHeap<Bool>(isOrderedBefore: { $0 ? !$1 : $1 })
        let _ = BinaryHeap<Int>()
        let _ = BinaryHeap<String>()
        let _ = BinaryHeap<(Int, Float)>(isOrderedBefore: {$0.0 < $1.0})
        
        let _ = BinaryHeap(elements: self.elements(), isOrderedBefore: {$0.0 < $1.0})
        let _ = BinaryHeap(elements: [0,2,1,5,9])
    }
    
    func test_push_and_peek()
    {
        var heap = BinaryHeap<Int>()
        
        XCTAssertEqual(heap.count, 0)
        
        heap.push(3)
        XCTAssertEqual(heap.count, 1)
        XCTAssertEqual(heap.peek(), 3)
        
        heap.push(4)
        
        XCTAssertEqual(heap.count, 2)
        XCTAssertEqual(heap.peek(), 3)
        
        heap.push(1)
        
        XCTAssertEqual(heap.count, 3)
        XCTAssertEqual(heap.peek(), 1)
    }
    
    func test_push_performance()
    {
        var heap = BinaryHeap<(Int, Float)>(isOrderedBefore: {$0.0 < $1.0})
        
        let elements = self.elements()
        
        var counter = 0
        measure
            {
                counter += 1
                for e in elements
                {
                    heap.push(e)
                }
        }
        
        XCTAssertEqual(heap.count, elements.count * counter)
    }
    
    func test_heap_pop_performance()
    {
        var heap = BinaryHeap<(Int, Float)>(isOrderedBefore: {$0.0 < $1.0})
        
        for e in elements()
        {
            heap.push(e)
        }
        
        measure
            {
                while !heap.isEmpty
                {
                    let _ = heap.pop()
                }
        }
    }
    
    func test_heap_pop()
    {
        var heap = BinaryHeap<Int>()
        
        for e in elements()
        {
            heap.push(e.0)
        }
        
        var top = heap.pop()
        
        XCTAssertNotNil(top)
        
        while let nextTop = heap.pop()
        {
            print(top!)
            XCTAssertLessThanOrEqual(top!, nextTop)
            top = nextTop
        }
    }
}
