module list;

import std.range;

/**
 * Authors: Chris - contact form bedroomcoders.co.uk
 */

/**
 * License: Boost Software License 1.0 (BSL-1.0) 
 */
 
/***********************************
 * dList (doubly linked list) 
 * 
 * The class is a template meaning that all nodes contain
 * the same type of data pointers
 * 
 * The list can be iterated forward and backwards, with foreach
 * and foreach_reverse.
 *     
 * It can be sorted using a quick sort algorith, 
 * the sort must be given a callback function so it can compare the
 * "value" of your data type.
 *   
 * Nodes can be added, inserted and deleted.
 * 
 * Searching for a node containing a particular pointer is
 * by brute force.
 *
 *
 * 
 */

class dList(T)
{
    /** a node points to its next and previous nodes
    and contains data of a templated type */
    class dNode
    {
        private
        {
            dNode _prev;
            dNode _next;
            T* _data;
        }

        T* data()
        {
            return _data;
        }
        

        /** used to manually iterate forward, stop looping if null */
        ref dNode next()
        {
            return this._next;
        }

        /** used to manually iterate backwards, stop looping if null */
        ref dNode prev()
        {
            return this._prev;
        }
        
        this() {
            _prev = null;
            _next = null;
        }
    }

    private
    {
        // the nodes at the start and end of the list
        dNode head;
        dNode tail;
        // running count of number of nodes in the list
        int count;
    }

    public
    
    this()
    {
        count = 0;
        head = null;
        tail = null;
    }

    /** the uses a quick sort algorithm the cmp (compare) function
     * pointer should calculate the "value" of one node and another 
     * usually by subtracting 
     *
     * Params:
     * cmp = the compare callback function
     */
    void sort(int function(ref dNode, ref dNode) cmp) 
    {
        doQsort(this.head, this.tail, cmp);
    }
    
    /** returns the first node in the list */
    ref dNode front()
    {
        return this.head;
    }

    /** returns the last node in the list */
    ref dNode back()
    {
        return this.tail;
    }


    /** adds a new node to end of the list 
     * 
     * Params:
     *
     * data = a pointer to the templated data 
     */
     
     
    dNode addNode(T* data)
    {
        dNode n = new dNode();
        n._prev = this.tail;
        n._next = null;
        if (n.prev !is null) n._prev._next = n;
        if (this.head is null) this.head = n;
        this.tail = n;
        n._data = data;
        count++;
        return n;
    }
    
     /** allows you to add a new node by "assigning" with
     * ---
     * anode = alist ~= &someData;
     * ---
     * or
     * ---
     * alist ~= &someData;
     * ---
     */    
    dNode opOpAssign(string op)(T* data) if(op == "~") {
        return addNode(data);
    }

    /** creates a new node and inserts it into the list
     * at the specified node.
     * 
     * Params:
     * 
     * node = the insertion point
     * data = pointer to templated data
     */
    dNode insertNewNode(dNode node, T* data)
    {
        dNode n = new dNode();
        n._next = node;
        n._prev = node._prev;
        if (node._prev !is null) node._prev._next = n;
        node._prev = n;
        if (this.head == node) this.head = n;
        n._data = data;
        count++;
        return n;
    }

    /** brute force find a node holding specific data 
     * 
     * Params:
     * 
     * data = the data pointer you're looking for
     */
    dNode findNode(T* data)
    {
        dNode node = this.head;
        while (node !is null)
        {
            if (node.data == data) return node;
            node = node._next;
        }
        node = null;
        return node;
    }

    /** removes a specific node from the list 
     * 
     * Params:
     * 
     * node = the node to remove from the list
     */
     
    void deleteNode(dNode node)
    {
        if (node._prev !is null) node._prev._next = node._next;
        if (node._next !is null) node._next._prev = node._prev;
        if (this.head == node) this.head = node._next;
        if (this.tail == node) this.tail = node._prev;
        node = null;
        count--;
    }

    /** delete a node from the list that contains specific data 
     * 
     * Params:
     * 
     * data = deletes the node that holds this data pointer
     */
    void deleteNodeFromData(T* data)
    {
        dNode n;
        n = findNode(data);
        if (n is null) return;
        deleteNode(n);
    }

    /** remove all nodes from a list */
    void emptyList()
    {
        dNode node;
        while (this.head !is null)
        {
            node = this.head; // protect head from nulling by deleteNode
            deleteNode(node);
        }
    }

    /** returns how many nodes there are in the list */
    int length()
    {
        return count;
    }
    
    /** used by foreach to iterrate the list - 
     * thanks to weltensturm on reddit for example
     * and explanations
     */
    int opApply(int delegate(ref dNode) dg)
    {   
        dNode node = this.head;
        int result;
        while (node !is null)
        {
            result = dg(node);
            if(result) break;
            node = node._next;
        }
        return result;
    }
    
    /** used by foreach_reverse to iterate
     * backwards through a list
     */
    int opApplyReverse(int delegate(ref dNode) dg)
    {
        dNode node = this.tail;
        int result;
        while (node !is null)
        {
            result = dg(node);
            if (result) break;
            node = node._prev;
        }
        return result;
    }


    /** returns true if there are no nodes in a list */
    bool empty()
    {
        return !this.head;
    }

    /** builds an array from all of the nodes in the list */
    T*[] toArray()
    {
        T*[] ar;
        ar.length = this.count;
        int n = 0;
        dNode node = this.head;
        while (node !is null)
        {
            ar[n] = node.data;
            n++;
            node = node.next;
        }
        return ar;
    }


    // used by sort (partition)
    private void swap( ref dNode a, ref dNode b)
    {
        T* t = a._data;
        a._data = b._data;
        b._data = t;
    }

    // used by sort
    private dNode partition( ref dNode l, ref dNode h, int function(ref dNode n1, ref dNode n2) cmp)
    {
        dNode x = h;
        dNode i = l.prev;
        
        for (dNode j = l; j != h; j = j.next)
        {
            if ( cmp(j,x) < 0 )
            {
                i = (i is null) ? l : i.next;
                swap(i, j);
            }
        }
        i = (i is null) ? l : i.next;
        swap(i, h);
        return i;
    }
    
    // needs to be seperate from sort as it's recursive
    private void doQsort(ref dNode l, ref dNode h, int function(ref dNode n1, ref dNode n2) cmp)
    {
        if (h !is null && l != h && l != h.next)
        {
            // could insert the partition code here...
            dNode p = partition(l, h, cmp);
            doQsort(l, p.prev, cmp);
            doQsort(p.next, h, cmp);
        }
    }
}
