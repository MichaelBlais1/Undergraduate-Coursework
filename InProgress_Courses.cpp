#include <iostream>
#include <string>
#include "InProgress_Courses.h"

using namespace std;
namespace Courses
{
	//Ensure to include Tasks
	InProgress_Courses *Inprogress_courses = new InProgress_Courses;

	void InProgress_Courses::InProgress_Print()
	{

	}
	void InProgress_Courses::Set_Tasklist(string TasksFile)
	{
		char seperator = ',';
		string row, item;

		ifstream in(TasksFile.c_str());
		while (getline(in, row))
		{
			vector <string> data;
			stringstream ss(row);
			while (getline(ss, item, seperator))
			{
				data.push_back(item);
			}

			Tasklist.push_back(data);
		}
		in.close();
		cout << TasksFile << " read successfully." << endl;
		cout << Tasklist.size() << " Items Loaded" << endl;
		return;
	}
	void InProgress_Courses::readTasklist()
	{
		for (int a = 0; a < Tasklist.size(); ++a)
		{
			for (int j = 0; j < Tasklist[a].size(); j++)
			{
				cout << Tasklist[a][j];
				cout << "  ";
			}
			cout << endl;
		}
	}
	void InProgress_Courses::Set_TaskColumnW()
	{
		int check;
		for (int j = 0; j < Tasklist[0].size(); j++)
		{
			check = Tasklist[0][j].length() + 2;
			TaskColumnW.push_back(check);
		}
		for (int i = 1; i < Tasklist.size(); i++)
		{
			for (int j = 0; j < Tasklist[i].size(); j++)
			{
				check = (Tasklist[i][j].length() + 2);
				if (check > TaskColumnW[j])
				{
					TaskColumnW[j] = check;
				}
			}
		}
		return;
	}
	void InProgress_Courses::printTasklist()
	{
		for (int i = 0; i < Tasklist.size(); i++)
		{
			for (int j = 0; j < Tasklist[i].size(); j++)
			{
				cout << "|  " << setw(TaskColumnW[j]) << left << Tasklist[i][j];
			}
			cout << endl;
		}
		cout << endl;
		return;
	}
	void InProgress_Courses::Set_current_sem()
	{
		current_sem = File[0][3];
	}
	void InProgress_Courses::Get_current_sem()
	{
		cout << "Current Semester: " << current_sem;
		return;
	}
	void InProgress_Courses::MenuTasklist()
	{

		for (int a = 0; a < Tasklist.size(); a++)
		{
			for (int b = 0; b < File.size(); b++)
			{
				if (Tasklist[a][0] == File[b][2])
				{
					cout << setw(ColumnSizes[0]) << left << File[b][0];
					for (int j = 0; j < Tasklist[a].size(); j++)
					{
						cout << "|  " << setw(TaskColumnW[j]) << left << Tasklist[a][j];
					}
					cout << endl;
				}
			}
		}
		return;
	}


}
