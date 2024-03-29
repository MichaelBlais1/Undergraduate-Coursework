#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
#include <fstream> 

//Included class and sub-classes
#include "Required_Courses.cpp"
#include "Taken_Courses.cpp"
#include "InProgress_Courses.cpp"

/*#include "InProgress_Courses.cpp"
#include "Taken_Courses.cpp"
#include "Required_Courses.cpp"*/

using namespace std;
using namespace Courses;
// class heirachy
// Required courses <- Taken courses
// Required courses <- In-progress courses (with task list)
//function prototyping


int main()
{
	//read files, initialize classes, vectors, and test functions
	Required_Course Req;
	InProgress_Courses Inprog;
	Taken_Course Taken;

	Req.setFile("Required_Courses.csv");
	Req.SetColumnW();
	//	Req.readFile();
	//	Req.printFile();
	cout << endl << endl;

	Taken.setFile("Taken_Courses.csv");
	Taken.SetColumnW();
	//	Taken.readFile();
	//	Taken.printFile();
	cout << endl << endl;
	//	Taken.Cal_GPA();

	Inprog.setFile("InProgress_Courses.csv");
	Inprog.SetColumnW();
	//	Inprog.readFile();
	Inprog.Set_current_sem();
	//	Inprog.printFile();
	cout << endl << endl;

	Inprog.Set_Tasklist("InProgress_Tasks.csv");
	//	Inprog.readTasklist();
	Inprog.Set_TaskColumnW();
	//	Inprog.printTasklist();
	cout << endl << endl;


	//	Taken.courseSearch("EE 1322");


	//begin menu loop.
	int menuSelection(0);
	string studentName = "James Hooge";

	cout << "Please select: " << endl << "[1]Transcript      [2]Task List      [3]Exit" << endl;
	cin >> menuSelection;

	while (menuSelection != 3)
	{
		cout << "selection verified. Fetching results:" << endl;

		if (menuSelection == 1)
		{
			cout << "Transcript for student : " << studentName << endl << endl;

			Taken.Cal_GPA();
			cout << endl << "Classes Taken" << endl;
			Taken.printFile();
			cout << endl << "Classes In Progress:" << endl;
			Inprog.printFile();
			cout << endl;
		}
		else if (menuSelection == 2)
		{
			cout << "Task List for student: " << studentName << endl << endl;
			Inprog.Get_current_sem();
			cout << endl;
			Inprog.MenuTasklist();
		}
		else
		{
			cout << "Invalid selection: " << endl;
		}
		cout << endl << "Please select: " << endl << "[1]Transcript      [2]Task List      [3]Exit" << endl;
		cin >> menuSelection;
	}

	return 0;
}





