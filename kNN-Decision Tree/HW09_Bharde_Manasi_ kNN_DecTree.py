import math
import csv
import operator
import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D

__author__ = 'Manasi'

class KNN:

    __slots__ = {"data", "old_data", "distances", "header"}

    def __init__(self):
        self.data = []
        self.header = None

    """
    Reading training data from csv
    """
    def get_records(self):
        with open('HW09_DEC_TREE_TRAINING_data__v720.csv', mode='r') as infile:
            reader = csv.reader(infile)
            self.header = next(reader)
            x = 0
            for row in reader:
                self.data.append([float(x) for x in row[0: len(row)]])

    """
    Clean data off outliers
    """
    def clean_data(self):
        self.distances = [{} for x in range(len(self.data))]
        for i in range(len(self.data)):
            for j in range(len(self.data)):
                self.distances[i][j] = self.get_distance(self.data[i], self.data[j])
        new_data = []
        new_distances = []
        for i in range(len(self.distances)):
            self.distances[i] = sorted(self.distances[i].items(), key=operator.itemgetter(1))
            #self.distances[i] = sorted(self.distances[i])
            if(self.distances[i][5][1] < 1.0):
                new_data.append(self.data[i])
                new_distances.append(self.distances[i])
                # else self.data_to_impute.append(i)
        self.old_data = self.data
        self.data = new_data
        self.distances = new_distances

    """
    Calculating euclidean distance
    """
    def get_distance(self, record1, record2):
        distance = 0
        for i in range(len(record1) - 1):
            distance += (record1[i]-record2[i])**2
        distance = math.sqrt(distance)
        return distance
        pass

    """
    Hold one out algorithm for deciding k and plotting to visualize best k
    """
    def k_fold_cross_verify(self):
        mis_classification_rates = [[] for x in range(len(self.data))]
        test_record_misclass_rate = [[] for x in range(len(self.data))]
        for i in range(len(self.data)):
            test_record = self.data[i]
            training_data = self.data[0:i] + self.data[i+1:len(self.data)]
            distances = self.distances[0:i] + self.distances[i+1:len(self.data)]
            for k in range(1, 11):
                expected_classes = []
                training_data_classification = []
                for record_no in range(len(training_data)):
                    closest_k_outputs = distances[record_no][1:k+1]
                    max_class = self.get_max_class(closest_k_outputs)
                    training_data_classification.append(max_class)
                    expected_classes.append(training_data[record_no][len(training_data[record_no])-1])
                mis_class_rate_i_k = self.get_mis_classification_rate(training_data_classification, expected_classes)
                mis_classification_rates[i].append(mis_class_rate_i_k)
                test_record_classified = self.get_max_class(self.distances[i][1:k+1])
                if test_record_classified == test_record[len(test_record)-1]:
                    test_record_misclass_rate[i].append(0)
                else:
                    test_record_misclass_rate[i].append(1)
        xx, yy = np.meshgrid(range(k),range(len(self.data)))
        fig = plt.figure()
        ax = fig.gca(projection='3d')
        ax.set_xlabel("K")
        ax.set_ylabel("iteration")
        ax.set_zlabel("Mis-classification error")
        ax.plot_surface(xx,yy, mis_classification_rates)
        #plt.show(fig)

    """
    Reclassifying the records for cleaning data
    """
    def reclassify(self, k):
        changed = 0
        for record_no in range(len(self.data)):
            closest_k_outputs = self.distances[record_no][1:k+1]
            max_class = self.get_max_class(closest_k_outputs)
            if max_class != self.data[record_no][len(self.data[record_no]) -1]:
                self.data[record_no][len(self.data[record_no]) -1] = max_class
                changed +=1
        print(changed)

    """
    Deciding output class of record based on K- nearest neighbors class
    """
    def get_max_class(self, classes):
        count_0, count_1 = 0, 0
        for x in classes:
            if self.old_data[x[0]][len(self.old_data[0])-1] == 1.0:
                count_1 += 1
            else:
                count_0 += 1
        if count_0 >= count_1:
            return 0.0
        else:
            return 1.0

    """
    Calculates miss classification rate
    """
    def get_mis_classification_rate(self, actual, expected):
        missed_classes = 0.0
        for i in range(len(actual)):
            if(actual[i] != expected[i]):
                missed_classes += 1.0
        return missed_classes/len(actual)
        pass

    """
    Writing cleaned data back to csv to be accessed by decision ree trainer
    """
    def write_data(self):
        with open('cleaned_data.csv', 'w', newline='') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=',',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
            spamwriter.writerow(self.header)
            for x in self.data:
                spamwriter.writerow(x)

def main():
    cleaner = KNN()
    cleaner.get_records()
    cleaner.clean_data()
    cleaner.k_fold_cross_verify()
    cleaner.reclassify(5)
    cleaner.write_data()


if __name__ == "__main__":
    main()