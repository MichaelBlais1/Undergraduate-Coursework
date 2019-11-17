//#pragma once
#ifndef Required_Courses_H
#define Required_Courses_H
#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <fstream>   // allow file reading
#include <iomanip>

using namespace std;
namespace Courses
{
	class Required_Course
	{
	public:
		//constructor
		void courseSearch(string);
		void setFile(string FileName);
		void readFile();
		void SetColumnW();
		void printFile();
		vector<int> get_column_size(vector<int> &);

	protected:
		// Private Members 
		vector< vector<string> > File;
		vector<int> ColumnSizes;
	};
}
#endif
