import pandas as pd

def main():
	print("Loading test data")
	print("expected	actual")
	data=pd.read_csv("HW_04B_DecTree_Testing___v121.csv")
	for i in range(0, len(data)):
		record = data[i:i+1]
		print(str(record['Class'][i])+",	"+str(classify(record,i)))
	output = []
	data=pd.read_csv("HW_04B_DecTree_validation_data___v121.csv")
	for i in range(0, len(data)):
		record = data[i:i+1]
		output.append(classify(record,i))
	validationOutput = pd.DataFrame(output)
	validationOutput.to_csv("HW_04B_Bharde_Manasi_MyClassifications.csv")

def classify(record,i):

   if record['Attr2'][i] <= 7.9:
      if record['Attr1'][i] <= 5.01:
         return 1
      else:
         if record['Attr2'][i] <= 4.85:
            return 0
         else:
            return 1
   else:
      return 0

if __name__ == "__main__":
	main()