import pandas as pd

def main():
	print("Loading test data")
	print("expected	actual")
	output = []
	data=pd.read_csv("HW09_DEC_tree_testing__data__v720.csv")
	for i in range(0, len(data)):
		record = data[i:i+1]
		output.append(classify(record,i))
	validationOutput = pd.DataFrame(output)
	validationOutput.to_csv("HW09_Bharde_Manasi_Classes.csv")

def classify(record,i):

   if record['Attrib03'][i] <= 4.77:
      if record['Attrib03'][i] <= 3.54:
         if record['Attrib02'][i] <= 0.41:
            if record['Attrib02'][i] <= 0.25:
               return 1.0
            else:
               return 0.0
         else:
            return 1.0
      else:
         if record['Attrib01'][i] <= 5.69:
            if record['Attrib03'][i] <= 4.61:
               return 0.0
            else:
               return 1.0
         else:
            return 1.0
   else:
      if record['Attrib01'][i] <= 6.74:
         if record['Attrib02'][i] <= 7.6:
            return 0.0
         else:
            if record['Attrib01'][i] <= 4.17:
               return 0.0
            else:
               return 1.0
      else:
         return 1.0

if __name__ == "__main__":
	main()