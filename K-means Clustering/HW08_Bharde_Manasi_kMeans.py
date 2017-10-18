import csv
import math
import random
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np

__author__ = 'Manasi'


class KMeans:

    __slots__ = {"SSEArray", "clusters", "SSE", "k", "data", "clusterAssigned", "KMeans", "header", "distances"}

    def __init__(self):
        self.data = []
        self.header = None
        self.SSEArray = []
        self.k = 12
        self.KMeans = []
        self.clusterAssigned = []
        self.clusters = {}
        self.distances = [self.k][len(self.data)]

    """
    Retrieves records from the file and initializes classifier
    """
    def get_records(self):
        with open('HW08_KMEANS_DATA_v300.csv', mode='r') as infile:
            reader = csv.reader(infile)
            self.header = next(reader)
            x = 0
            for row in reader:
                self.data.append([float(x) for x in row[0: len(row)]])

    """
    Method to calculate SSE
    """
    def getSSE(self):
        self.SSE = 0
        for j in range (len(self.data)):
            self.SSE += self.distances[j][self.clusterAssigned[j]]
        pass

    """
    Clean data off outliers
    """
    def cleanData(self):
        distances = [[0 for x in range(len(self.data))] for x in range(len(self.data))]
        for i in range(len(self.data)):
            for j in range(len(self.data)):
                distances[i][j] = self.getDistance(self.data[i], self.data[j])
        newData = []
        for i in range(len(distances)):
            distances[i] = sorted(distances[i])
            if(distances[i][9] < 1):
                newData.append(self.data[i])
        self.data = newData
        print(len(self.data))

    """
    Assign clusters to data points as per minimum distant centroid
    """
    def assignClusters(self):
        self.clusterAssigned = [0 for x in range(len(self.data))]
        self.distances = [[0 for x in range(self.k)] for x in range(len(self.data))]
        for i in range(self.k):
            self.clusters[i] = []
        for j in range(len(self.data)):
            for i in range(self.k):
                self.distances[j][i] = self.getDistance(self.data[j], self.KMeans[i])
            self.clusterAssigned[j] = self.distances[j].index(min(self.distances[j]))
            self.clusters[self.distances[j].index(min(self.distances[j]))].append(j)
        pass

    """
    Method to calculate the euclidean distance
    """
    def getDistance(self, record1, mean):
        distance = 0
        for i in range(len(record1)):
            distance += (record1[i] - mean[i])**2
        distance = math.sqrt(distance)
        return distance
        pass

    """
    Method that runs k-means algorithm to iterate till centroid don't move
    """
    def getKmeans(self, k):
        self.k = k
        for i in range(k):
            self.KMeans.append(self.data[random.randint(0,len(self.data)-1)])
        changed = True
        while(changed):
            self.assignClusters()
            self.getSSE()
            changed = self.getNewCentroids()
        pass

    """
    Method to calculate new centroids
    """
    def getNewCentroids(self):
        changed = False
        for i in range(self.k):
            x,y,z = 0,0,0
            for data_point in self.clusters[i]:
                x += self.data[data_point][0]
                y += self.data[data_point][1]
                z += self.data[data_point][2]
            x = x/len(self.clusters[i])
            y = y/len(self.clusters[i])
            z = z/len(self.clusters[i])
            if(x != self.KMeans[i][0] or y != self.KMeans[i][1] or z != self.KMeans[i][2]):
                changed = True
            self.KMeans[i] = [x, y, z]
        return changed
        pass

    """
    Method to plot SSE vs K
    """
    def plotData(self, k):
        ks = [x for x in range(1, k)]
        plt.plot(ks, self.SSEArray)
        plt.show()
        pass

    """
    Method to plot clusters in 3D
    """
    def plotData3D(self, sortedKeys):
        colors = ["red", "green", "blue", "yellow", "magenta", "black", "gray", "brown", "orange", "pink", "cyan"]
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        for key in sortedKeys:
            x, y, z = [], [], []
            for item in self.clusters[key]:
                x.append(self.data[item][0])
                y.append(self.data[item][1])
                z.append(self.data[item][2])
            ax.scatter(np.array(x), np.array(y), np.array(z), c=colors[key])
        plt.show(fig)
        pass

def main():
    classifier = KMeans()
    classifier.get_records()
    classifier.cleanData()
    for i in range(1, 12):
        classifier.getKmeans(i)
        classifier.SSEArray.append(classifier.SSE)
        if(i==5):
            print(classifier.SSE)
            sortedValues = sorted(classifier.clusters.values(), key=len)
            sortedKeys = []
            sortedClusterSize = []
            for x in sortedValues:
                sortedKeys.append(classifier.clusterAssigned[x[0]])
                sortedClusterSize.append(len(classifier.clusters[classifier.clusterAssigned[x[0]]]))
            print(sortedClusterSize)
    classifier.plotData(12)
    keys = [x for x in range(0,11)]
    classifier.plotData3D(keys)
    pass

if __name__ == "__main__":
    main()