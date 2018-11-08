module main;

import std.stdio;
import std.string;
import std.range;
import list;

// example data to demo sorting
struct bundle
{
    string str;
    int val;
};
/*
// example iterate callback
void printNode(dList!string.dNode node)
{
    writeln("> ",*node.data);
}
*/
// prints a list by iterating forward and backwards
// using the print node callback
void dumplist(string msg, dList!string l)
{
    writeln("---- ",msg);
    write("iterate forward - ");
    //l.iterateForward(&printNode);
    foreach(dList!string.dNode n; l)
    {
        write(*n.data,"  ");
    }
    writeln();
    write("iterate backward - ");
    //l.iterateBackward(&printNode);
    foreach_reverse(dList!string.dNode n; l)
    {
        write(*n.data,"  ");
    }
    writeln();
}

// the node compare (sorting) callback for bundle
int cmpNodes(dList!bundle.dNode n1, dList!bundle.dNode n2)
{
    bundle* rn1 = n1.data;
    bundle* rn2 = n2.data;

    return rn1.val - rn2.val;
}

void main()
{
    string s1="first";
    string s2="second";
    string s3="third";
    string si1="insert 1";
    string si2="insert 2";

    // when instancing a list provide the template type
    // for the node data.
    dList!string l = new dList!string();

    dList!string.dNode n1, n2, n3, i1, i2;

    // often you might not need to keep list nodes
    n1 = l ~= &s1;
    dumplist("added one node", l);

    n2 = l ~= &s2;
    n3 = l ~= &s3;
    dumplist("added another two nodes", l);

    i1 = l.insertNewNode(n2, &si1);
    dumplist("inserted node @ node 2", l);

    i2 = l.insertNewNode(n3, &si2);
    dumplist("inserted node @ node 3", l);

    l.deleteNode(i1);
    l.deleteNode(i2);
    dumplist("deleted insert 1 & 2", l);

    l.deleteNode(n1);
    dumplist("delete node 1", l);

    l.deleteNode(n3);
    dumplist("delete node 3", l);

    l.deleteNode(n2);
    dumplist("delete node 2", l);

    l ~= &s3;
    l ~= &s2;
    l ~= &s1;
    dumplist("add 3 nodes in reverse order", l);

    // looking for a node containing a specific item
    dList!string.dNode found;
    found = l.findNode(&s2);
    if (found !is null)
    {
        l.deleteNode(found);
    }
    else
    {
        writeln("ERROR didn't find node containing s2 in list");
    }

    dumplist("find and then delete node pointing to s2", l);

    found = l.findNode(&s2);
    if (found !is null)
    {
        writeln("ERROR found node containing s2 in list after deleting it");
    }
    else
    {
        writeln("correctly didn't find node containing s2 in list");
    }

    l.emptyList();
    dumplist("emptied list", l);

    bundle st1 = { "item 9", 9 };
    bundle st2 = { "item 6", 6 };
    bundle st3 = { "item 5", 5 };
    bundle st4 = { "item 2", 2 };
    bundle st5 = { "item 8", 8 };
    bundle st6 = { "item 7", 7 };
    bundle st7 = { "item 3", 3 };
    bundle st8 = { "item 4", 4 };
    bundle st9 = { "item 1", 1 };

    dList!bundle l2 = new dList!bundle();
    l2 ~= &st1;
    l2 ~= &st2;
    l2 ~= &st3;
    l2 ~= &st4;
    l2 ~= &st5;
    l2 ~= &st6;
    l2 ~= &st7;
    l2 ~= &st8;
    l2 ~= &st9;
    
    dList!bundle.dNode node = l2.front();
    writeln("foreach");
 
    foreach (dList!bundle.dNode b; l2) 
    {
        write(b.data.str,"  ");
    }
    
    writeln("\nforeach reverse");
    foreach_reverse (dList!bundle.dNode b; l2) 
    {
        write(b.data.str,"  ");
    }

    
    writeln("\nitems in list ", l2.length());
    node = l2.front();
    while (node !is null)
    {
        write(node.data.str,"  ");
        node = node.next();
    }
    writeln("\nsort..");
    l2.sort( &cmpNodes );

    node = l2.front();
    while (node !is null)
    {
        write( node.data.str, " - ", node.data.val,"  ");
        node = node.next;
    }

    writeln("\nitems in list ", l2.length());

    writeln("copy to array and iterate");
    bundle*[] ar = l2.toArray();
    foreach(bundle* a; ar )
    {
        write(a.str,"  ");
    }
    

    writeln("\ndelete st1, st2, st3");
    l2.deleteNodeFromData(&st1);
    l2.deleteNodeFromData(&st2);
    l2.deleteNodeFromData(&st3);

    writeln("items in list ", l2.length());
    writeln("empty ? ", l2.empty());
    writeln("delete st4 to st9");
    l2.deleteNodeFromData(&st4);
    l2.deleteNodeFromData(&st5);
    l2.deleteNodeFromData(&st6);
    l2.deleteNodeFromData(&st7);
    l2.deleteNodeFromData(&st8);
    l2.deleteNodeFromData(&st9);

    writeln("items in list ",l2.length());
    writeln("empty ? ",l2.empty());

}

