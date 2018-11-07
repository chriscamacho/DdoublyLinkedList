module list;

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
 * The list can be iterated forward and backwards.  
 * It can be sorted using a quick sort algorith, 
 * the sort must be given a callback function so it can compare the
 * "value" of your data type.  
 * Nodes can be added, inserted and deleted.
 * Searching for a node containing a particular pointer is
 * by brute force.
 * Callbacks can optionally be used for iterating
 * 
 */

class dList (T)
{
    /** a node points to its next and previous nodes
    and contains data of a templated type */
    class dNode
    {
        private
        {
            dNode prev;
            dNode next;
        }

        /** the data pointer is public to allow the
        end user to change it */
        T* data;

        /** used to manually iterate forward, stop looping if null */
        dNode getNext()
        {
            return this.next;
        }

        /** used to manually iterate backwards, stop looping if null */
        dNode getPrev()
        {
            return this.prev;
        }
    }

    private
    {
        // the nodes at the start and end of the list
        dNode head;
        dNode tail;
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
    void sort(int function(dNode n1, dNode n2) cmp) 
    {
        doQsort(this.head, this.tail, cmp);
    }
    
    /** returns the first node in the list */
    dNode getHead()
    {
        return this.head;
    }

    /** returns the last node in the list */
    dNode getTail()
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

        n.prev = this.tail;
        n.next = null;
        if (n.prev !is null) n.prev.next = n;
        if (this.head is null) this.head = n;
        this.tail = n;
        n.data = data;
        count++;
        return n;
    }

    /** creates a new node and inserts it into the list
     * 
     * Params:
     * 
     * node = the insertion point
     * data = pointer to tempated data
     */
    dNode insertNewNode(dNode node, T* data)
    {
        dNode n = new dNode();
        n.next = node;
        n.prev = node.prev;
        if (node.prev !is null) node.prev.next = n;
        node.prev = n;
        if (this.head == node) this.head = n;
        n.data = data;
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
            node = node.next;
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
        if (node.prev !is null) node.prev.next = node.next;
        if (node.next !is null) node.next.prev = node.prev;
        if (this.head == node) this.head = node.next;
        if (this.tail == node) this.tail = node.prev;
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

    /** calls a callback function for every node in the list 
     * 
     * Params:
     * 
     * nodeFunction = the function that is called for each node
     */
    void iterateForward( void function(dNode node) nodeFunction )
    {
        dNode node = this.head;
        while (node !is null)
        {
            nodeFunction(node);
            node = node.next;
        }
    }

    /** call a callback for each node while iterating backwards */
    void iterateBackward( void function(dNode node) nodeFunction )
    {
        dNode node = this.tail;
        while (node !is null)
        {
            nodeFunction(node);
            node = node.prev;
        }
    }


    /** returns how many nodes there are in the list */
    int totalItems()
    {
        /*
        int c = 0;
        dNode node = this.head;
        while (node !is null)
        {
            c++;
            node = node.next;
        }
        return c;
        */
        return count;
    }

    /** returns true if there are no nodes in a list */
    bool isEmpty()
    {
        return !this.head;
    }

    /** builds an array from all of the nodes in the list */
    T*[] toArray()
    {
        int n = this.totalItems();
        T*[] ar;
        ar.length = n;
        n=0;
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
    private void swap( dNode a, dNode b)
    {
        T* t = a.data;
        a.data = b.data;
        b.data = t;
    }

    // used by sort
    private dNode partition( dNode l, dNode h, int function(dNode n1, dNode n2) cmp)
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
    private void doQsort(dNode l, dNode h, int function(dNode n1, dNode n2) cmp)
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
