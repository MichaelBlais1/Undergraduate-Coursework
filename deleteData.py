import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode

def deleteData(user_1, user_2):
    query = "DELETE FROM user_pairs WHERE (user_1 = %s OR user_2 = %s) AND (user_1 = %s OR user_2 = %s);"

    try:
         connection = mysql.connector.connect(host='localhost',
                                         database='paired_users',
                                         user='MichaelBlais',
                                         password='@Pioneers2000')
         cursor = connection.cursor()
         cursor.execute(query, (user_1,user_1,user_2,user_2,))
         connection.commit()
 
    except Error as error:
        print(error)
 
    finally:
        cursor.close()
        connection.close()
        

