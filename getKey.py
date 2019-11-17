# This function returns the shared key given user1 and user2 in any order
# It can be called in another function; see databaseHandshake.py for an example

import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode

def getKey(user_1, user_2):

    try:
        # replace with correct connection info for your database
         connection = mysql.connector.connect(host='localhost',
                database='paired_users',
                user='MichaelBlais',
                password='@Pioneers2000')

         cursor = connection.cursor()
         # replace 'user_pairs' with your table name
         query = """SELECT * FROM user_pairs WHERE (user_1 = %s OR user_2 = %s) AND (user_1 = %s OR user_2 = %s);"""
         cursor.execute(query, (user_1,user_1,user_2,user_2,))
         record = cursor.fetchall()

         for row in record:
             return row[3]
         

    except Error as error:
        print(error)

    finally:
        cursor.close()
       

