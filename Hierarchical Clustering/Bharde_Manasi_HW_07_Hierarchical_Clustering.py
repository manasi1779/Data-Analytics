import math
import csv
import operator
from scipy import cluster as temp
import matplotlib.pyplot as plt
import numpy as np
from ete3 import Tree
from ete3 import TreeNode

__author__ = 'Manasi Bharde'

class Distance:
    __slots__ = {"ID", "distance", "record_ID"}

    def __init__(self, ID, distance, record):
        self.ID = ID
        self.distance = distance
        self.record_ID = record

class Cluster:

    __slots__ = {"cluster_record_ID_map", "count", "header", "center_of_masses", "clusters_assigned"}

    def __init__(self):
        self.header = None
        self.count = 0
        self.clusters_assigned = {}
        self.cluster_record_ID_map = {}
        self.center_of_masses = {}

    """
    Retrieves records from the file and initializes clustering
    """
    def get_records(self):
        with open('HW_07_SHOPPING_CART_v137.csv', mode='r') as infile:
            reader = csv.reader(infile)
            self.header = next(reader)
            for row in reader:
                ID, attributes = int(row[0]), [int(x) for x in row[1: len(row)]]
                self.cluster_record_ID_map[ID] = [ID]
                self.clusters_assigned[ID] = ID
                self.center_of_masses[ID] = attributes
                self.count += 1
        pass

    """
    Method to calculate euclidean distance
    """
    def get_distance(self, record1, record2):
        distance = 0
        for attribute_index in range(len(record1)):
            distance += (record1[attribute_index]-record2[attribute_index])**2
        return math.sqrt(distance)

    """
    Finds sum of record attributes for calculating center of mass for the cluster
    """
    def calculate_center_of_mass(self, record1, record2):
        center = []
        for attribute_index in range(0, len(record1)):
            values_sum = record1[attribute_index] + record2[attribute_index]
            center.append(values_sum)
        return center

    """
    Finds distance between available current clusters and determines minimum distance until number of clusters is 3
    """
    def get_clusters(self):
        while self.count > 3:
            distances = []
            for record in self.center_of_masses.keys():
                for center_of_mass in self.center_of_masses.keys():
                    if record != center_of_mass:
                        distances.append(Distance(center_of_mass, self.get_distance(self.center_of_masses[record], self.center_of_masses[center_of_mass]), record))
            self.merge(min(distances, key=operator.attrgetter("distance")))

    """
    Merges two clusters having minimum distcnce between them to form a new cluster
    """
    def merge(self, mergePoint):
        if mergePoint.ID > mergePoint.record_ID:
            temp = mergePoint.ID
            mergePoint.ID = mergePoint.record_ID
            mergePoint.record_ID = temp
        number_of_points1 = len(self.cluster_record_ID_map[mergePoint.ID])
        number_of_points2 = len(self.cluster_record_ID_map[mergePoint.record_ID])
        print(min(number_of_points1, number_of_points2))
        sum_record1 = [x*number_of_points1 for x in self.center_of_masses[mergePoint.ID]]
        sum_record2 = [x*number_of_points2 for x in self.center_of_masses[mergePoint.record_ID]]
        new_center = self.calculate_center_of_mass(sum_record1, sum_record2)
        new_center = [attribute_sum/(number_of_points1+number_of_points2) for attribute_sum in new_center]
        self.center_of_masses[mergePoint.ID] = new_center
        for record in self.cluster_record_ID_map[mergePoint.record_ID]:
            self.clusters_assigned[record] = mergePoint.ID
            self.cluster_record_ID_map[mergePoint.ID].append(record)
        del [self.cluster_record_ID_map[mergePoint.record_ID]]
        del [self.center_of_masses[mergePoint.record_ID]]
        self.count -= 1
        pass

    """
    Creates the dendrogram
    """
    def drawDendrogram(self):
        X = np.asarray([x for x in self.center_of_masses.values()])
        Z = temp.hierarchy.linkage(X, method='centroid')
        figure1 = plt.figure()
        dn = temp.hierarchy.dendrogram(Z)
        #plt.show(figure1)

def main():
    agglomerative_cluster = Cluster()
    agglomerative_cluster.get_records()
    agglomerative_cluster.drawDendrogram()
    # Printing number of points from shorter cluster of the two clusters merged
    print("Minimum number of points from two clusters merged")
    agglomerative_cluster.get_clusters()
    #for cluster in agglomerative_cluster.center_of_masses.keys():
    #    print(cluster, agglomerative_cluster.center_of_masses[cluster], len(agglomerative_cluster.cluster_record_ID_map[cluster]))
    #Printing IDS from belonging to the clusters formed
    print(agglomerative_cluster.cluster_record_ID_map)


if __name__ == "__main__":
    main()