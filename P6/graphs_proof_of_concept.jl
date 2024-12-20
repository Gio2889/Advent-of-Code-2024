using Graphs
using GraphPlot

elist = [(1,2),(2,3),(3,4)] #,(3,4),(4,1),(1,5)];
g = SimpleGraph(Graphs.SimpleEdge.(elist));
gplot(g)
if cycle_basis(g) == []
    println("true")
end