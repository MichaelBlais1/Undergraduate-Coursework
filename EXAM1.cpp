// EXAM1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <iostream>
#include <vector>
using namespace std;

void frequency(vector<int> & myValues) {  //passes inputValues (from main) by reference
	unsigned int freq;
	unsigned int i;
	unsigned int j; 
	unsigned int k;
	for (j = 0; j < myValues.size(); j++) {  //tracks the current index
		int found = 0;
		for (k = 0; k < j; k++) {  //tracks whether a number has already been used
			if (myValues.at(k) == myValues.at(j)) found++;  //increments every time a number has been previously used
		}
		if (found == 0) {  //only allows the program to continue if no previous occurences of the number at current index are found
			int freq = 0;
			for (i = 0; i < myValues.size(); i++) {
				if (myValues.at(i) == myValues.at(j)) {  //compare all indices to current index
					freq++;  //increment freq each time an index equals the current index
				}
			}
			cout << "The frequency of " << myValues.at(j) << " is " << freq << endl;  //output the frequency of each value
		}
	}	
}

int main()
{
	int vectorSize = NULL;
	vector<int> inputValues(vectorSize);
	unsigned int i;

	cout << "What size is your vector?" << endl;  //ask for size of vector
	cin >> vectorSize;
	inputValues.resize(vectorSize);  //Set vector to the desired size; vector is now ready for inputs
	for (i = 0; i < inputValues.size(); ++i) {
		cout << "Enter a value: ";  //ask for values for each index one at a time
		cin >> inputValues.at(i);
	}
	
	frequency(inputValues);  //function call

	return 0;
}


