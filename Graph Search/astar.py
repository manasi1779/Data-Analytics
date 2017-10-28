__author__ = 'Manasi'

import math
import functools

from Homework1.aStar import graph

class Path:
    __slots__ = ("nodeList", "pathValue", "heuristicValue")

    def __init__(self):
        self.nodeList = []

    def addNode(self,node):
        self.nodeList.append(node)

class Location:
    __slots__ = ("room","x", "y","heuristic")

    def __init__(self, name, x, y):
        self.room = name
        self.x = x
        self.y = y

    def setHeuristic(self, sld):
        self.heuristic = sld

def compareNodes(x, y):
    """
    Comparator for comparing paths
    :param x: x location
    :param y: y location
    :return:
    """
    return (x.pathValue+x.heuristicValue) - (y.pathValue+y.heuristicValue)

class NavigationSystem:
    """
    Implements Astar algorithm for shortest path
    """
    __slots__ = ("locations", "straightLineDistances", "floorGraph")

    def readLocations(self):
        """
        Reads locations to calculate straight line distances
        :return:
        """
        self.locations = []
        file = open("coordinates.csv")
        lines = file.readlines()
        for line in lines:
            params = line.split(",")
            self.locations.append(Location(params[0],float(params[1]),float(params[2])))

    def getHeuristics(self):
        """
        Calculates staright line distances and normalizes it to relate to real cost considered in graph
        :return:
        """
        self.straightLineDistances = {}
        for loc1 in self.locations:
            for loc2 in self.locations:
                distance = math.sqrt((loc1.x-loc2.x)**2+(loc1.y-loc2.y)**2)
                self.straightLineDistances[loc1.room+loc2.room] = distance*10000*33/23

    def makeGraph(self):
        """
        Creates graph using floor map considering it at scale
        :return:
        """
        self.floorGraph = graph.Graph()
        file = open("edges.csv")
        edges = file.readlines()
        for edge in edges:
            params = edge.split(",")
            self.floorGraph.addEdge(params[0],params[1],float(params[2]))
            self.floorGraph.addEdge(params[1],params[0],float(params[2]))

    def getShortestPath(self, src, dest):
        """
        Finds shortest path between source and destination
        :param src:
        :param dest:
        :return:
        """
        if(not (self.floorGraph.__contains__(src) and self.floorGraph.__contains__(dest))):
            print("Invalid Input")
        else:
            pathList = []
            path = Path()
            path.addNode(src)
            path.pathValue =0
            path.heuristicValue = self.straightLineDistances[src+dest]
            pathList.append(path)
            pathList = sorted(pathList, key=functools.cmp_to_key(compareNodes))
            expandNode = pathList.pop(0)
            while(not dest in expandNode.nodeList):
                selectedNode = expandNode.nodeList[len(expandNode.nodeList)-1]
                selectedVertex = self.floorGraph.getVertex(selectedNode)
                availableNodes = self.floorGraph.getVertex(selectedNode).getConnections()
                for node in availableNodes:
                    if(not node.id in expandNode.nodeList):
                        newPathValue = expandNode.pathValue + selectedVertex.getWeight(node)
                        hValue = self.straightLineDistances[node.id+dest]
                        newNode = Path()
                        newNode.nodeList = list(expandNode.nodeList)
                        newNode.nodeList.append(node.id)
                        newNode.pathValue = newPathValue
                        newNode.heuristicValue = hValue
                        pathList.append(newNode)
                pathList = sorted(pathList, key=functools.cmp_to_key(compareNodes))
                expandNode = pathList.pop(0)
            print("Following is shortest path from "+src+" to "+dest+" with cost "+str(expandNode.pathValue))
            print(expandNode.nodeList)

def main():
    n = NavigationSystem()
    n.readLocations()
    n.getHeuristics()
    n.makeGraph()
    n.getShortestPath("RND", "35171")

if __name__ == '__main__':
    main()