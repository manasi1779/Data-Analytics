import pandas as pd
from operator import itemgetter
import numpy as np
import pylab as pl
import math

__author__ = 'Manasi Bharde'

class Classification:

    """
        This class uses otsu's method to determine threshold for classifying data using 1D thresholding
    """
    """
        Calculating ripeness of fruit data in training dataset
    """
    def getRipeness(self, data):
        ripeness = data['Deflection (mm)']/data['Force (Newtons)']
        return ripeness

    """
        Converting the ripeness coefficients into bins
    """
    def quantizeRipeness(self, ripeness, classes):
        quantized_ripeness = []
        # Creating 2D array to store quantized ripeness and class from training data
        for i in range(0, len(classes)):
            quantized_ripeness.append([])
            quantized_ripeness[i].append(round(ripeness[i]*50)/50)
            quantized_ripeness[i].append(classes[i])
        return quantized_ripeness

    """
        Getting thresholds for classification using otsu's method
    """
    def getThreeOtsuClusters(self, quantized_ripeness):
        thresholds = []
        quantized_ripeness = sorted(quantized_ripeness, key=itemgetter(1))
        boundry1 = 1
        boundry2 = 60
        # array of false alarm rate
        X = []
        # array of correct hit rate
        Y = []
        bestX, bestY = 0, 0
        minDist = np.inf
        minValue = np.inf
        n_wrongValues = []
        values = []
        # choosing upper threshold for class 1, 2. To get three classes
        for i in (1, 2):
            best_missclass_rate = np.inf
            t = 0
            for x in range(boundry1, boundry2):
                value = x/50
                left, right = self.splitArrays(quantized_ripeness , value)

                # Number of false alarms
                n_fa = 0
                for y in left:
                    if y[1] != i:
                        n_fa+=1
                n_true_positive = len(left) - n_fa

                # number of misses
                n_misses = 0
                for y in right:
                    if y[1] == i:
                        n_misses+=1
                n_true_negative = len(right) - n_misses
                n_wrong = n_misses + n_fa

                # calculating euclidean distance to determine the point with max true positive rate and min false alarm rate
                if((n_fa+ n_true_negative) > 0 and (n_true_positive + n_misses) > 0 and i == 1):
                    true_positive_rate = n_true_positive/(n_true_positive + n_misses)
                    Y.append(true_positive_rate)
                    false_alarm_rate = n_fa/(n_fa+ n_true_negative)
                    X.append(false_alarm_rate)
                    distance = (1 - true_positive_rate)**2 + (false_alarm_rate)**2
                    distance = math.sqrt(distance)
                    if(distance < minDist):
                        minDist = distance
                        minValue = value
                        bestX = false_alarm_rate
                        bestY = true_positive_rate
                # getting values for mis-classification plot
                if(i==1):
                    n_wrongValues.append(n_wrong/len(quantized_ripeness))
                    values.append(value)
                #updating least mis-classification rate
                if n_wrong <= best_missclass_rate:
                    best_missclass_rate = n_wrong
                    t = value
                    #print(str(n_misses)+" "+str(n_fa)+" "+str(value))
            thresholds.append(t)
            boundry1 = int(t * 50)
        print("Best threshold:")
        print(minValue)
        pl.figure("Misclassification")
        pl.scatter(values, n_wrongValues)
        pl.xlabel("Ripeness Threshold")
        pl.ylabel("Misclassification")
        #highlighting the best thrshold
        #pl.axhline(y=6)
        pl.show(block=False)

        pl.figure("Scatter plot: ROC")
        pl.scatter(X, Y)
        pl.xlabel("False Alarm Rate")
        pl.ylabel("Correct hit rate")

        #highlighting the best thrshold
        pl.plot(bestX, bestY, 'o',ms=10, mec='b', mfc='none', mew=2)
        pl.annotate('best threshold', xy=(bestX, bestY),xytext=(0.08, 1.05),arrowprops=dict(facecolor='black'))
        pl.show(block=False)
        return thresholds


    """
        Splitting array on new threshold
    """
    def splitArrays(self, array, value):
        left = []
        right = []
        for x in array:
            if(x[0] <= value):
                left.append(x)
            else:
                right.append(x)
        return left, right

    """
        Classify test data based on threshold
    """
    def classify(self, testData, thresholds):
        data = pd.read_csv(testData)
        ripeness = self.getRipeness(data)
        classes = []
        #in order to maximize customer satisfaction, classifying ripeness equal to threshold as unripe
        for x in ripeness:
            if(x <= thresholds[0]):
                classes.append(0)
            else:
                classes.append(1)
        return classes

def main():
    c = Classification()
    data = pd.read_csv("CSCI420_2161_HW03_Classified_Data.csv")
    classes = data['Class']
    thresholds = c.getThreeOtsuClusters(c.quantizeRipeness(c.getRipeness(data), classes))
    output = c.classify("CSCI420_2161_HW03_MELONS_TO_CLASSIFY_2016.csv", thresholds)
    df = pd.DataFrame(output, columns=['output'])
    df.reset_index(level = None)
    df.to_csv("HW_03_Bharde_Manasi_CLASSIFICATIONS.csv", sep  = ',')
    pl.show()

if __name__ == "__main__":
    main()
