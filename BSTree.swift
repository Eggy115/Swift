//
//  BSTree.swift
//  SwiftStructures
//
//  Created by Wayne Bishop on 9/16/17.
//  Copyright © 2017 Arbutus Software Inc. All rights reserved.
//

import Foundation

 /*
 note: self-balancing binary search tree (BST). Elements are positioned based on their value.
 After insertion, model is checked for balance and automatically completes required rotations.
 */


class BSTree<T: Comparable>{
    
   var root = BSNode<T>()
   private var elementStack = Stack<BSNode<T>>()
    
    
    func append(element key: T) {
        
        
        //initialize root
        guard root.key != nil else {
            
            root.key = key
            root.height = 0
            
            return
        }
        
        
        //set initial indicator
        var current: BSNode<T> = root

        
        while current.key != nil {

            //send reference of current item to stack
            push(element: &current)
            
            
            //check left side
            if key < current.key! {
                
                if current.left != nil {
                    current = current.left!
                }
                    
                    
                else {
                    
                    //create new element
                    let childToAdd = BSNode<T>()
                    childToAdd.key = key
                    childToAdd.height = 0
                    current.left = childToAdd
                    break
                }
            }
            
            //check right side
            if key > current.key! {
                
                if current.right != nil {
                    current = current.right!
                }
                    
                    
                else {
                    
                    //create new element
                    let childToAdd = BSNode<T>()
                    childToAdd.key = key
                    childToAdd.height = 0
                    current.right = childToAdd
                    break
                }
            }
            
        } //end while
        
        
        //calculate height and balance of call stack..
        rebalance()
        
    }
    
    
    //equality test - O(log n)
    func contains(_ key: T) -> Bool {
        
        var current: BSNode<T>? = root
        
        while current != nil {
            
            guard let testkey = current?.key else {
                return false
            }
            
            //test match
            if testkey == key {
                return true
            }
            
            //check left side
            if key < testkey {
                if current?.left != nil {
                    current = current?.left
                    continue
                }
                else {
                    return false
                }
            }
            
            //check right side
            if key > testkey {
                if current?.right != nil {
                    current = current?.right
                    continue
                }
                else {
                    return false
                }
            }
            
        } //end while
        
        return false
    }
    
    
    
   //stack elements for later processing - memoization
   private func push(element: inout BSNode<T>) {
        elementStack.push(withKey: element)
        print("the stack count is: \(elementStack.count)")
    }
    

  //determine height and balance
  private func rebalance() {
        
        for _ in stride(from: elementStack.count, through: 1, by: -1) {
            
            //obtain generic stack node - by reference
            let current = elementStack.peek()
            
            guard let bsNode: BSNode<T> = current.key else {
                print("element reference not found..")
                continue
            }
            
            setHeight(for: bsNode)
            rotate(element: bsNode)
            
            
            //remove stacked item
            elementStack.pop()
        }
    }
    

    //MARK: Height Methods
    
    
   private func findHeight(of element: BSNode<T>?) -> Int {
        
        //check empty leaves
        guard let bsNode = element else {
            return -1
        }

        return bsNode.height
    }
    

   private func setHeight(for element: BSNode<T>) {
        
        //set leaf variables
        var elementHeight: Int = 0
        
        //do comparison and calculate height
        elementHeight = max(findHeight(of: element.left), findHeight(of: element.right)) + 1
        element.height = elementHeight
        
    }
    
    
    //MARK: Balancing Methods
    
    
    
    //determine if the tree is "balanced" - operations on a balanced tree is O(log n)
    func isTreeBalanced(for element: BSNode<T>?) -> Bool {
        
        guard element?.key != nil else {
            print("no element provided..")
            return false
        }
        
        
        //use absolute value to manage right and left imbalances
        if (abs(findHeight(of: element?.left) - findHeight(of: element?.right)) <= 1) {
            return true
        }
        else {
            return false
        }
    }
    

    
    //perform left or right rotation
   private func rotate(element: BSNode<T>) {
        
        guard element.key != nil else {
            print("cannot rotate: no key provided..")
            return
        }
        
        
        if (self.isTreeBalanced(for: element) == true) {
            print("node: \(element.key!) already balanced..")
            return
        }
        
        
        //create new element
        let childToUse = BSNode<T>()
        childToUse.height = 0
        childToUse.key = element.key

        
        //determine side imbalance
        let rightSide = findHeight(of: element.left) - findHeight(of: element.right)
        let leftSide =  findHeight(of: element.right) - findHeight(of: element.left)
        
        
        if rightSide > 1 {
            
            print("\n starting right rotation on \(element.key!)..")
            
            //reset the root node
            element.key = element.left?.key
            element.height = findHeight(of: element.left)
            
            
            //assign the new right node
            element.right = childToUse
            
            
            //adjust the left node
            element.left = element.left?.left
            element.left?.height = 0
            
            print("root is: \(element.key!) | left is : \(element.left!.key!) | right is : \(element.right!.key!)..")
        }
        
        else if leftSide > 1 {
            
            print("\n starting left rotation on \(element.key!)..")
            
            //reset the root node
            element.key = element.right?.key
            element.height = findHeight(of: element.right)
            
            
            //assign the new left node
            element.left = childToUse
            
            
            //adjust the right node
            element.right = element.right?.right
            element.right?.height = 0
            
            print("root is: \(element.key!) | left is : \(element.left!.key!) | right is : \(element.right!.key!)..")
            
        }
    }
    
    
    
}
