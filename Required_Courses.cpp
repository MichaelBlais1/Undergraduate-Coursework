#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
#include <fstream>   // allow file reading
#include "Required_Courses.h"	

using namespace std;
namespace Courses
{
	void Required_Course::setFile(string FileName)
	{
		char seperator = ',';
		string row, item;

		ifstream in(FileName.c_str());
		while (getline(in, row))
		{
			vector <string> data;
			stringstream ss(row);
			while (getline(ss, item, seperator))
			{
				data.push_back(item);
			}
			File.push_back(data);
		}
		in.close();
		cout << FileName << " read." << endl;
		cout << File.size() << " Items Loaded" << endl;
		return;
	}
	void Required_Course::readFile()
	{
		for (int i = 0; i < File.size(); i++)
		{
			for (int j = 0; j < File[i].size(); j++)
			{
				cout << File[i][j];
				cout << "  ";
			}
			cout << endl;
		}
	}
	void Required_Course::courseSearch(string cNum)
	{
		cout << "Searching for" << cNum << endl;
		for (int i = 0; i < File.size(); i++)
		{
			if (File[i][2] == cNum)
			{
				cout << "Match found:" << endl;
				for (int j = 0; j < File[i].size(); j++)
				{
					cout << File[i][j] << "   ";
				}
			}
		}
		cout << endl << endl;
	}
	void Required_Course::SetColumnW()
	{

		int check;
		for (int j = 0; j < File[0].size(); j++)
		{
			check = File[0][j].length() + 2;
			ColumnSizes.push_back(check);
		}
		for (int i = 0; i < File.size(); i++)
		{
			for (int j = 0; j < File[i].size(); j++)
			{
				check = File[i][j].length() + 2;
				if (check > ColumnSizes[j])
				{
					ColumnSizes[j] = check;
				}
			}
		}
		return;
	}
	void Required_Course::printFile()
	{
		int space = 0;
		for (int i = 0; i < File.size(); i++)
		{
			for (int j = 0; j < File[i].size(); j++)
			{
				cout << "|  " << setw(ColumnSizes[j]) << left << File[i][j];
			}
			cout << endl;
		}
		return;
	}

	vector<int> Required_Course::get_column_size(vector<int> & sizes)
	{

		for (int i = 0; i < ColumnSizes.size(); i++)
		{
			sizes.push_back(ColumnSizes[i]);
		}
		return sizes;
	}

}

