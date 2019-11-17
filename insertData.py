# Use this to add new user pairs
# If you try to add a pair in any order, which already exists in any order,
# no record will be added.
from generateKey import generateKey
import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode

def dataToInsert(user_1, user_2):
    shared_key = generateKey()
    query = "INSERT INTO user_pairs(user_1, user_2, shared_key)" "VALUES (%s,%s,%s)"
    args = (user_1, user_2, shared_key)
    try:
	 
         connection = mysql.connector.connect(host='localhost',
                database='paired_users',
                user='MichaelBlais',
                password='@Pioneers2000')

         cursor = connection.cursor()
         result = cursor.execute(query, args)
         connection.commit()
         cursor.close()

    except mysql.connector.Error as error:
        print(error)

    finally:
        if (connection.is_connected()):
            connection.close()


def insertData(user_1, user_2):
    try:
        # replace with correct connection info for your database
         connection = mysql.connector.connect(host='localhost',
                database='paired_users',
                user='MichaelBlais',
                password='@Pioneers2000')

         cursor = connection.cursor()
         query = """SELECT * FROM user_pairs WHERE (user_1 = %s OR user_2 = %s) AND (user_1 = %s OR user_2 = %s);"""
         cursor.execute(query, (user_1,user_1,user_2,user_2,))
         exists = cursor.fetchone()
         if not exists:
             dataToInsert(user_1, user_2)
         else:
             pass
         cursor.close()

    except Error as error:
        print(error)

    finally:
         if (connection.is_connected()):
            connection.close()









