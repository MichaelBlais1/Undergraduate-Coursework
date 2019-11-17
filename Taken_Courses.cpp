#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
#include <fstream>
#include "Taken_Courses.h"

using namespace std;
namespace Courses
{
	//constructors
	Taken_Course::Taken_Course()
	{

	}

	void Taken_Course::Cal_GPA()
	{
		float valSum = 0.0;
		float hour = 0.0;
		Total_Hours = 0.0;
		Total_GPA = 0.0;
		//semester
		for (int k = 1; k <= 8; k++)
		{
			for (int i = 0; i < File.size(); i++)
			{
				if (stoi(File[i][3]) == k)
				{
					if (File[i][6] == "A")
					{
						valSum = 4.0;
					}
					else if (File[i][6] == "B")
					{
						valSum = 3.0;
					}
					else if (File[i][6] == "C")
					{
						valSum = 2.0;
					}
					else if (File[i][6] == "D")
					{
						valSum = 1.0;
					}
					else
					{
						valSum = 0.0;
					}
					hour = stof(File[i][4]);

					Total_Hours = Total_Hours + hour;
					Total_GPA = Total_GPA + (hour*valSum);
				}
			}
			if (Total_Hours != 0.0)
			{
				cout << "Semester " << k << " GPA: " << fixed << setprecision(2) << Total_GPA / Total_Hours << "     ";
			}
			Total_Hours = 0.0;
			Total_GPA = 0.0;
		}
		//total
		for (int i = 0; i < File.size(); i++)
		{
			if (File[i][6] == "A")
			{
				valSum = 4.0;
			}
			else if (File[i][6] == "B")
			{
				valSum = 3.0;
			}
			else if (File[i][6] == "C")
			{
				valSum = 2.0;
			}
			else if (File[i][6] == "D")
			{
				valSum = 1.0;
			}
			else
			{
				valSum = 0.0;
			}
			hour = stof(File[i][4]);

			Total_Hours = Total_Hours + hour;
			Total_GPA = Total_GPA + (hour*valSum);
		}
		if (Total_Hours == 0.0)
		{
			return;
		}
		else
		{
			cout << "Total GPA: " << fixed << setprecision(2) << Total_GPA / Total_Hours << endl;
		}
		Total_Hours = 0.0;
		Total_GPA = 0.0;

		return;
	}


}


