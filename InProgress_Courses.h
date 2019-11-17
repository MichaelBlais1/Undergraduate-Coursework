//#pragma once
#ifndef InProgress_Courses_H
#define InProgress_Courses_H
#include "Required_Courses.h"
#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
//Tasks included here

using namespace std;
namespace Courses
{
	class InProgress_Courses : public Required_Course
	{
	public:
	 
		void InProgress_Print();
		void Set_Tasklist(string);
		void readTasklist();
		void printTasklist();
		void Set_current_sem();
		void Set_TaskColumnW();
		void Get_current_sem();
		void MenuTasklist();
		// constructors
	protected:
		vector< vector<string> > Tasklist;
		vector<int> TaskColumnW;
		string current_sem;

	};
}
#endif
