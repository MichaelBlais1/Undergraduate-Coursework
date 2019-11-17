//#pragma once
#ifndef Taken_Courses_H
#define Taken_Courses_H
#include "Required_Courses.h"
#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
#include <fstream>
using namespace std;
namespace Courses
{
	class Taken_Course : public Required_Course
	{
	public:
		Taken_Course();//constructor
		void Cal_GPA();//member function
	protected:
		float Total_GPA;
		float Total_Hours;
	};

}
#endif
