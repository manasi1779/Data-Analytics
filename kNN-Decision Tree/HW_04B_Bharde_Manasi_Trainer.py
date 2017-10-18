import pandas as pd
from operator import itemgetter
import math

class Node:
    __slots__ = {"root","value", "left", "right", "isLeaf", "outputClass"}

    def __init__(self, root, value):
        self.root = root
        self.value = value
        self.isLeaf = False
        self.left = None
        self.right = None
        self.outputClass = None

    def classifyStream(self, x):
        for record in x:
            pass

    def printProgram(self):
        file = open("HW_09_Bharde_Manasi_Classifier.py", "w")
        tree = "def classify(record,i):\n"+self.printDecisionTree("","")
        header = "import pandas as pd\n\ndef main():\n\tprint(\"Loading test data\")\n\toutput = []\n\tdata=pd.read_csv(\"HW09_DEC_tree_testing__data__v720.csv\")\n\tfor i in range(0, len(data)):\n\t\trecord = data[i:i+1]\n\t\toutput.append(int(classify(record,i)))\n\tvalidationOutput = pd.DataFrame(output)\n\tvalidationOutput.to_csv(\"HW09_Bharde_Manasi_Classes.csv\")\n\n"
        file.write(header)
        file.write(tree)
        file.write("\n\nif __name__ == \"__main__\":\n\tmain()")


    def printDecisionTree(self, buffer, text):
        buffer = buffer+"   "
        if self.isLeaf == True:
            return text+"\n"+buffer+"return "+str(self.outputClass)
        text+="\n"+buffer+"if record['"+self.root +"'][i] <= "+str(self.value)+":"
        text=self.left.printDecisionTree(buffer,text)
        text+="\n"+buffer+"else:"
        text=self.right.printDecisionTree(buffer,text)
        return text

class Decision:

    __slots__ = {"data"}

    def getData(self):
        self.data = pd.read_csv("cleaned_data.csv")
        pass

    """
    This method builds decision tree recursively
    """
    def buildTree(self, data):
        giniIndex = getGini(data.RedDwarf)
        if giniIndex == 0.0:
            decisionTree = Node("Leaf", 0)
            decisionTree.isLeaf = True
            decisionTree.outputClass = data.RedDwarf[0:1][0]
            return decisionTree
        giniTable = {}
        for i in range(0, len(list(data))-1):
            giniTable[i]= self.getBestThreshold(pd.DataFrame(data = data, columns = [list(data)[i], list(data)[len(list(data))-1]]))
        sortedGiniTable = sorted(giniTable.items(), key=itemgetter(1))
        leastGiniAttribute = sortedGiniTable[0][0]
        left, right = splitValueArray(data, leastGiniAttribute, sortedGiniTable[0][1][1])
        decisionTree = Node(list(data)[leastGiniAttribute],sortedGiniTable[0][1][1])
        if len(left) > 0:
            decisionTree.left = self.buildTree(left )
        if len(right) > 0:
            decisionTree.right = self.buildTree(right )
        return decisionTree

    """
    This method will sort attribute-output class pair iterate through quantized values and
    returns the threshold which gives minimum weighted gini index
    """
    def getBestThreshold(self, values):
        attributeArray = values.sort_values(by=list(values)[0])
        attributeArray = attributeArray.reset_index(drop=True)
        totalRecords = len(attributeArray)
        minWeightedGini = math.inf
        bestThreshold = 0
        for i in range(0, totalRecords):
            weightedGini = getWeightedGini(attributeArray['RedDwarf'], i, totalRecords)
            if(weightedGini <= minWeightedGini):
                minWeightedGini = weightedGini
                bestThreshold = attributeArray[list(attributeArray)[0]][i]
        return minWeightedGini, bestThreshold
        pass

"""
Calculates gini for given data
"""
def getGini(data):
    count0 = getCount(data, 0)
    count1 = getCount(data, 1)
    gini = 1 - math.pow(count0/len(data), 2.0) - math.pow(count1/len(data), 2.0)
    return gini
    pass

"""
Splits dataframe based on value
"""
def splitValueArray(data, leastGiniAttribute, threshold):
    left = pd.DataFrame()
    right = pd.DataFrame()
    columnName = list(data)[leastGiniAttribute]
    for i in range(0, len(data)):
        if data[columnName][i] <= threshold:
            left = left.append(data[i:i+1])
        else:
            right = right.append(data[i:i+1])
    left = left.reset_index(drop=True)
    right = right.reset_index(drop=True)
    return left, right

"""
Splits dataframe based on index
"""
def splitArray(values, i):
    return values[0:i+1], values[i+1:len(values)]

"""
Counting the occurrences of member in values list
"""
def getCount(values, member):
    count = 0
    for x in values:
        if x==member:
            count+=1
    return count

"""
This method calculates Gini index of the set of records
"""
def getWeightedGini(attributeArray, i, totalRecords):
    leftSet, rightSet = splitArray(attributeArray, i)
    leftCount = i
    rightCount = totalRecords - i
    leftGini, rightGini = 0, 0
    if len(leftSet) != 0:
        leftGini = getGini(leftSet)
    if len(rightSet) != 0:
        rightGini = getGini(rightSet)
    return (leftCount/totalRecords)*(leftGini) + (rightCount/totalRecords)*(rightGini)
    pass

def main():
    d = Decision()
    d.getData()
    decisionTreeModel = d.buildTree(d.data)
    decisionTreeModel.printProgram()
    #decisionTreeModel.classify(d.data)

if __name__ == "__main__":
    main()