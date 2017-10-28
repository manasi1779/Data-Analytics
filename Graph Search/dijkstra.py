__author__ = 'Manasi'

import math
import functools
from Homework1.Dijkstra import graph

class Path:
    __slots__ = ("nodeList", "pathValue")

    def __init__(self):
        self.nodeList = []

    def addNode(self,node):
        self.nodeList.append(node)

def compareNodes(x, y):
    """
    Comparator for comparing Paths as per path cost
    :param x: x location
    :param y: y location
    :return:
    """
    return x.pathValue - y.pathValue

class Dijkstra:
    """
    Implements Dijkstra's algorithm for shortest path
    """

    __slots__ = ("shortestDistanceMap", "floorGraph")

    def __init__(self):
        self.shortestDistanceMap = {}

    def makeGraph(self):
        """
        Creates graph reading edges.csv
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
        Finds shortest path between src and destination
        :param src:
        :param dest:
        :return:
        """
        vertices = self.floorGraph.getVertList()
        unvisitedQueue = []
        srcPath = Path()
        srcPath.addNode(src)
        srcPath.pathValue = 0
        unvisitedQueue.append(srcPath)
        connections = self.floorGraph.getVertex(src).getConnections()
        #initialisez distances
        for vertex in vertices:
            newPath = Path()
            newPath.nodeList = list(srcPath.nodeList)
            newPath.addNode(vertex)
            if self.floorGraph.getVertex(vertex) in connections:
                newPath.pathValue = self.floorGraph.getVertex(src).getWeight(self.floorGraph.getVertex(vertex))
                unvisitedQueue.append(newPath)
            else:
                newPath.pathValue = math.inf
            self.shortestDistanceMap[src+vertex] = newPath
        # updates distances as per shorter routes
        while len(unvisitedQueue) is not 0:
            unvisitedQueue = sorted(unvisitedQueue, key=functools.cmp_to_key(compareNodes))
            chkPath = unvisitedQueue.pop(0)
            chkNode = chkPath.nodeList[len(chkPath.nodeList)-1]
            for vertex in vertices:
                if(self.floorGraph.getVertex(vertex) in self.floorGraph.getVertex(chkNode).getConnections()):
                    newWeight = chkPath.pathValue + self.floorGraph.getVertex(chkNode).getWeight(self.floorGraph.getVertex(vertex))
                    if(newWeight < self.shortestDistanceMap[src+vertex].pathValue):
                        self.shortestDistanceMap[src+vertex].pathValue = newWeight
                        self.shortestDistanceMap[src+vertex].nodeList = list(chkPath.nodeList)
                        self.shortestDistanceMap[src+vertex].nodeList.append(vertex)
                        newPath = Path()
                        newPath.nodeList = list(self.shortestDistanceMap[src+vertex].nodeList)
                        newPath.pathValue = newWeight
                        unvisitedQueue.append(newPath)
        print(self.shortestDistanceMap[src+dest].nodeList)
        print(self.shortestDistanceMap[src+dest].pathValue)

def main():
    n = Dijkstra()
    n.makeGraph()
    n.getShortestPath("RND", "Honors")

if __name__ == '__main__':
    main()