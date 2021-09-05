import cx_Oracle

conn = cx_Oracle.connect ('JYS', 'JYS', 'localhost:1521/XE', encoding='UTF-8', nencoding='UTF-8')


# with conn.cursor() as cursor:
#     cursor.execute ("select * from DOCTOR")
#     res = cursor.fetchall()

# for row in res:
#     print(row)

# cursor = conn.cursor()



######################1번######################
def doc_insert(): 
    drname = input("의사명을 입력하세요: ")
    medisubj = input("진료과목을 입력하세요: ")

    cursor = conn.cursor()

    sql="Insert into DOCTOR (DR#,DRNAME,MEDISUBJ) values (  'DR' || LPAD ( to_CHAR( doctor_seq.nextval ) , 3, '0'), '" + drname   + "','" + medisubj + "')"
    cursor.execute(sql)
 #   print (sql)
    cursor.close()
    conn.commit()
    print("\n추가되었습니다.")


######################2번######################
def doc_update():
    print("\n=========================의사목록=========================\n")
    sql="SELECT * FROM DOCTOR ORDER BY DR#"
    #cursor.execute(sql)

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)
    

    drnum = input("수정할 의사번호를 입력하세요: ")
    drname = input("의사명을 변경하세요: ")
    medisubj = input("진료과목을 변경하세요: ")

    cursor = conn.cursor()

    sql="UPDATE DOCTOR SET DRNAME = '" + drname + "', MEDISUBJ = '" + medisubj + "' WHERE DR# = '" + drnum + "'"
    
    cursor.execute(sql)
    
    cursor.close()
    conn.commit()
    print("\n수정되었습니다.")


######################3번######################
def doc_delete():
    print("\n=========================의사목록=========================\n")
    sql="SELECT * FROM DOCTOR ORDER BY DR#"
    #cursor.execute(sql)

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)

    drnum = input("삭제할 의사번호를 입력하세요: ")

    cursor = conn.cursor()

    sql="DELETE FROM DOCTOR WHERE DR#='" + drnum + "'"
    cursor.execute(sql)
    #print(sql)
    cursor.close()
    conn.commit()
    print("\n삭제되었습니다.")

######################4번######################
def drwork_insert():
    print("\n=========================의사목록=========================\n")
    sql="SELECT * FROM DOCTOR ORDER BY DR#"
    #cursor.execute(sql)

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)

    drnum = input("근무시간을 추가할 의사의 의사번호를 입력하세요: ")
    d_workdate = input("추가할 근무 날짜를 입력하세요(YYYY-MM-DD): ")
    print("\n===================================(%s) %s님의 예약 현황===================================\n" % (d_workdate, drnum))
    sql="SELECT TO_CHAR( W.WORKDATETIME, 'HH24:MI') WORKTIME, NVL(P.PTNAME, '예약없음') PTNAME, P.GENDER, TO_CHAR(P.BIRTHDAY, 'YYYY-MM-DD') BIRTHDAY FROM DRWORK W LEFT OUTER JOIN PTBOOK B ON W.DR# = B.DR# AND W.WORKDATETIME = B.BOOKDATETIME LEFT OUTER JOIN PATIENT P ON B.PT# = P.PT# WHERE W.DR# = '" + drnum + "' AND TO_CHAR(W.WORKDATETIME, 'YYYY-MM-DD') = '" + d_workdate + "' ORDER BY W.WORKDATETIME"

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)
    
    t_workdate = input("\n추가할 근무 시간을 입력하세요(HH24:MI): ")

    cursor = conn.cursor()

    sql="INSERT INTO DRWORK (DR#, WORKDATETIME, WORK_YN) VALUES ('" + drnum + "', TO_DATE('" + d_workdate +" " + t_workdate +"', 'YYYY-MM-DD HH24:MI' ), 'Y')"

    cursor.execute(sql)

    cursor.close()
    conn.commit()
    print("\n추가되었습니다.")

######################5번######################
def drwork_delete():
    print("\n=========================의사목록=========================\n")
    sql="SELECT * FROM DOCTOR ORDER BY DR#"
    #cursor.execute(sql)

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)

    drnum = input("근무시간을 삭제할 의사의 의사번호를 입력하세요: ")
    d_workdate = input("삭제할 근무 날짜를 입력하세요(YYYY-MM-DD): ")
    print("\n===================================(%s) %s님의 예약 현황===================================\n" % (d_workdate, drnum))
    sql="SELECT TO_CHAR( W.WORKDATETIME, 'HH24:MI') WORKTIME, NVL(P.PTNAME, '예약없음') PTNAME, P.GENDER, TO_CHAR(P.BIRTHDAY, 'YYYY-MM-DD') BIRTHDAY FROM DRWORK W LEFT OUTER JOIN PTBOOK B ON W.DR# = B.DR# AND W.WORKDATETIME = B.BOOKDATETIME LEFT OUTER JOIN PATIENT P ON B.PT# = P.PT# WHERE W.DR# = '" + drnum + "' AND TO_CHAR(W.WORKDATETIME, 'YYYY-MM-DD') = '" + d_workdate + "' ORDER BY W.WORKDATETIME"

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)
    
    t_workdate = input("\n삭제할 근무 시간을 입력하세요(HH24:MI): ")

    cursor = conn.cursor()
    
    sql="DELETE FROM DRWORK WHERE DR# = '" + drnum + "' AND WORKDATETIME = TO_DATE('" + d_workdate + " " + t_workdate +"', 'YYYY-MM-DD HH24:MI' )"

    cursor.execute(sql)

    cursor.close()
    conn.commit()
    print("\n삭제되었습니다.")

######################6번######################
def drbook():
    print("\n=========================의사목록=========================\n")
    sql="SELECT * FROM DOCTOR ORDER BY DR#"
    #cursor.execute(sql)

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)

    drnum = input("예약 현황을 확인할 의사의 의사번호를 입력하세요: ")
    d_workdate = input("날짜를 입력하세요(YYYY-MM-DD): ")
    print("\n===================================(%s) %s님의 예약 현황===================================\n" % (d_workdate, drnum))
    sql="SELECT TO_CHAR( W.WORKDATETIME, 'HH24:MI') WORKTIME, NVL(P.PTNAME, '예약없음') PTNAME, P.GENDER, TO_CHAR(P.BIRTHDAY, 'YYYY-MM-DD') BIRTHDAY FROM DRWORK W LEFT OUTER JOIN PTBOOK B ON W.DR# = B.DR# AND W.WORKDATETIME = B.BOOKDATETIME LEFT OUTER JOIN PATIENT P ON B.PT# = P.PT# WHERE W.DR# = '" + drnum + "' AND TO_CHAR(W.WORKDATETIME, 'YYYY-MM-DD') = '" + d_workdate + "' ORDER BY W.WORKDATETIME"

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)


######################7번######################
def hospbook():
    workdate = input("예약을 확인하고 싶은 날짜를 입력하세요(YYYY-MM-DD): ")
    print("\n=================================== %s 예약 현황===================================\n" %(workdate))

    sql="SELECT d.medisubj, D.DRNAME, TO_CHAR(  W.WORKDATETIME ,'HH24:MI') WORKTIME, NVL( P.PTNAME, '예약없음') PTNAME, P.GENDER,  TO_CHAR(P.BIRTHDAY,'YYYY-MM-DD')   BIRTHDAY FROM DRWORK W LEFT OUTER JOIN PTBOOK B ON  W.DR#  = B.DR# AND W.WORKDATETIME = B.BOOKDATETIME LEFT OUTER JOIN PATIENT P ON B.PT# = P.PT# JOIN DOCTOR D ON W.DR# = D.DR# WHERE  TO_CHAR(W.WORKDATETIME,'YYYY-MM-DD') = '" + workdate + "' ORDER BY  d.medisubj, D.DRNAME, W.WORKDATETIME"

    with conn.cursor() as cursor_sel:
        cursor_sel.execute (sql)
        res = cursor_sel.fetchall()
    for row in res:
        print(row)


#############################################
################# mainflow #################
#############################################

print ("-----------------------------------------------")
print ("숙명병원 예약관리 프로그램에 접속되었습니다.")
print ("-----------------------------------------------")

menu =  "1"

while (menu != "0"):
    print("\n")
    print ("1. 의료진 정보 추가")
    print ("2. 의료진 정보 수정")
    print ("3. 의료진 정보 삭제")
    print ("4. 근무 시간 추가")
    print ("5. 근무 시간 삭제")
    print ("6. 의사 별 예약 현황")  
    print ("7. 날짜 별 병원 예약 현황") 
    print ("0. 프로그램 종료") 
    menu = input (">> 위의 메뉴 번호를 참조하여 선택하세요: ")    
  
    
    if menu == "1":
        doc_insert()
    elif menu == "2":
        doc_update()
    elif menu == "3":
        doc_delete()
    elif menu == "4":
        drwork_insert()
    elif menu == "5":
        drwork_delete()
    elif menu == "6":
        drbook()
    elif menu == "7":
        hospbook()
    elif menu == "0":
        conn.close()
        print("프로그램을 종료합니다.")
    else:
        print("ERROR : 메뉴 선택이 잘못되었습니다.")
