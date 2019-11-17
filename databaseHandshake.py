from insertData import insertData
from deleteData import deleteData
from getKey import getKey

option = int(input("Option 1: Add user pair \n Option 2: Delete user pair \n Option 3: View key for user pair \n Enter an option: \n"))

if option == 1:
    user1 = input("Enter user 1: \n")
    user2 = input("Enter user 2: \n")
    insertData(user1, user2)
elif option == 2:
    user1 = input("Enter user 1: \n")
    user2 = input("Enter user 2: \n")
    deleteData(user1, user2)
elif option == 3:
    user1 = input("Enter user 1: \n")
    user2 = input("Enter user 2: \n")
    print(getKey(user1, user2))
else:
    print("Not a valid option")



