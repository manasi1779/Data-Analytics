import re

__author__ = 'Manasi'


class SequentialAnalysis:

    __slots__ = {"data", "biGraph", "triGraph"}

    """
    Initializing bigraph and trigraph
    """
    def __init__(self):
        self.data = []
        self.triGraph = []
        for i in range(27):
            self.triGraph.append([])
            for j in range(26):
                self.triGraph[i].append([])
                for k in range(27):
                    self.triGraph[i][j].append(0)
        self.biGraph = []
        for i in range(27):
            self.biGraph.append([])
            for j in range(27):
                self.biGraph[i].append(0)


    """
    Cleaning and loading data
    """
    def getData(self):
        file = open("words.txt", "r")
        for line in file.readlines():
            line = line.strip()
            line = line.lower()
            if(line.endswith("'s")):
                line = line[:-2]
            line = re.sub('[^A-Za-z]+', '', line)
            self.data.append("^"+line+"$")
        pass

    """
    Constructing trigraph
    """
    def constructTriGraph(self):
        for word in self.data:
            for i in range(len(word)-2):
                if word[i] == '^' and word[i+2] == '$':
                    self.triGraph[26][ord(word[i+1])-97][26] += 1
                elif word[i] == '^':
                    self.triGraph[26][ord(word[i+1])-97][ord(word[i+2])-97] += 1
                elif word[i+2] == '$':
                    self.triGraph[ord(word[i])-97][ord(word[i+1])-97][26] += 1
                else:
                    self.triGraph[ord(word[i])-97][ord(word[i+1])-97][ord(word[i+2])-97] += 1
        pass

    """
    Constructing bigraph
    """
    def constructBiGraph(self):
        for word in self.data:
            for i in range(len(word)-1):
                if word[i] == '^':
                    self.biGraph[26][ord(word[i+1])-97] += 1
                elif word[i+1] == '$':
                    self.biGraph[ord(word[i])-97][26] += 1
                else:
                    self.biGraph[ord(word[i])-97][ord(word[i+1])-97] += 1
        pass

    def getMaxTioIon(self):
        tio = self.triGraph[ord('t')-97][ord('i')-97][ord('o')-97]
        ion = self.triGraph[ord('i')-97][ord('o')-97][ord('n')-97]
        print(tio, ion)
        pass

    def getMaxEneIne(self):
        ene = self.triGraph[ord('e')-97][ord('n')-97][ord('e')-97]
        ine = self.triGraph[ord('i')-97][ord('n')-97][ord('e')-97]
        print(ene, ine)
        pass

    def getMaxAntEnt(self):
        ant = self.triGraph[ord('a')-97][ord('n')-97][ord('t')-97]
        ent = self.triGraph[ord('e')-97][ord('n')-97][ord('t')-97]
        print(ant, ent)
        pass

    def getErEd(self):
        er = self.triGraph[ord('e')-97][ord('r')-97][26]
        ed = self.triGraph[ord('e')-97][ord('d')-97][26]
        print(er, ed)

    def getNNSS(self):
        nn = self.biGraph[ord('n')-97][ord('n')-97]
        ss = self.biGraph[ord('s')-97][ord('s')-97]
        print(nn, ss)

    def getThSh(self):
        th = self.biGraph[ord('t')-97][ord('h')-97]
        sh = self.biGraph[ord('s')-97][ord('h')-97]
        print(th, sh)

    def getQFollower(self):
        qfollower = sorted(self.biGraph[ord('q')-97][0:26])
        print(chr(self.biGraph[ord('q')-97].index(qfollower[24]) + 97))

    def getTFollower(self):
        tfollower = sorted(self.biGraph[ord('t')-97])
        print(tfollower[26])
        print(chr(self.biGraph[ord('t')-97].index(tfollower[26]) + 97))

    def getUFollower(self):
        ufollower = sorted(self.biGraph[ord('u')-97])
        print(chr(self.biGraph[ord('u')-97].index(ufollower[26]) + 97))

    def getQUFollower(self):
        quFollower = sorted(self.triGraph[ord('q')-97][ord('u')-97])
        print(chr(self.triGraph[ord('q')-97][ord('u')-97].index(quFollower[26])+97))

    def getWHFollower(self):
        quFollower = sorted(self.triGraph[ord('w')-97][ord('h')-97])
        print(chr(self.triGraph[ord('w')-97][ord('h')-97].index(quFollower[26])+97))

    def getMaxStartsWith(self):
        maxStarter = sorted(self.biGraph[26])
        print(maxStarter[26])
        print(chr(self.biGraph[26].index(maxStarter[26])+97))

    def getMaxEndsWith(self):
        neatArray = [row[26] for row in self.biGraph]
        maxEnd = sorted(neatArray)
        print(maxEnd[26])
        print(chr(neatArray.index(maxEnd[26])+97))


    def getAndEnd(self):
        annd = self.triGraph[ord('a')-97][ord('n')-97][ord('d')-97]
        end = self.triGraph[ord('e')-97][ord('n')-97][ord('d')-97]
        print(annd, end)


def main():
    search = SequentialAnalysis()
    search.getData()
    search.constructTriGraph()

    search.constructBiGraph()

    print("Which is more common tio or  ion?")
    search.getMaxTioIon()
    print("Which is more common ene or ine?")
    search.getMaxEneIne()
    print("Which is more ant or ent?")
    search.getMaxAntEnt()
    print("Which is most common letter that words start with?")
    search.getMaxStartsWith()
    print("Which is more common er or ed?")
    search.getErEd()
    print("Which is most common NN or SS?")
    search.getNNSS()
    print("Which is most common after q except u?")
    search.getQFollower()
    print("Which is most common after qu?")
    search.getQUFollower()
    print("Which is most common after t?")
    search.getTFollower()
    print("Which is most common after u?")
    search.getUFollower()
    print("Which is most common letter to end word with?")
    search.getMaxEndsWith()

    print("Which is more common and or end?")
    search.getAndEnd()

    print("Which is more common th ot sh?")
    search.getThSh()

    print("Which is most common followed letter after wh?")
    search.getWHFollower()
    pass

if __name__ == "__main__":
    main()