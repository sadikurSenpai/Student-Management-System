IFS=','
add_user()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo -e "\nADD A $1\n"
while true
do
read -p "Enter $1's id : " uId
flag=0
while read id name pass
do
if [ $id -eq $uId ]
then
flag=1
fi
done < $1.csv
if [ $flag -eq 1 ]
then
echo -e "$uId already exits !!"
else
read -p "Enter $1's name : " uName
read -p "Enter $1's password : " uPass
echo "$uId,$uName,$uPass" >> $1.csv
break
fi
done
echo -e "Added successfully\nPress 1 to create a $1 again/ 2 to return : " 
read ch
if [ "$ch" -eq "1" ]
then
add_user $1
else
admin_panel
fi
}


remove_teacher()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
touch temp.csv
while read id name pass
do
if [ "$id" != "$2" ]
then
echo "$id,$name,$pass" >> temp.csv
fi
done < teacher.csv
cat temp.csv > teacher.csv
rm temp.csv
touch temp.csv
while read s_id t_id t_name c_code att quiz mid final total grade
do
if [ "$t_id" != "$2" ]
then
echo "$s_id,$t_id,$t_name,$c_code,$att,$quiz,$mid,$final,$total,$grade" >> temp.csv
fi
done < enroll.csv
cat temp.csv > enroll.csv
rm temp.csv
touch temp.csv
while read cCode iId
do
if [ "$iId" != "$2" ]
then
echo "$cCode,$iId" >> temp.csv
fi
done < course.csv
cat temp.csv > course.csv
rm temp.csv
echo "Deleted $2 successfully"
read -p "Enter anything to return : " ch
case "$ch" in
*) view_user $1 ;;
esac
}


remove_student()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
touch temp.csv
while read id name pass
do
if [ "$id" != "$2" ]
then
echo "$id,$name,$pass" >> temp.csv
fi
done < student.csv
cat temp.csv > student.csv
rm temp.csv
touch temp.csv
while read s_id t_id t_name c_code att quiz mid final total grade
do
if [ "$s_id" != "$2" ]
then
echo "$s_id,$t_id,$t_name,$c_code,$att,$quiz,$mid,$final,$total,$grade" >> temp.csv
fi
done < enroll.csv
cat temp.csv > enroll.csv
rm temp.csv
touch temp.csv
while read id name msg
do
if [ "$2" != "$id" ]
then
echo "$id,$name,$msg" >> temp.csv
fi
done < messageAdmin.csv
cat temp.csv > messageAdmin.csv
rm temp.csv
echo "Deleted $2 successfully"
read -p "Enter anything to return : " ch
case "$ch" in
*) view_user $1 ;;
esac
}


details_view_user()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
if [ "$1" == "student" ]
then
flag=0
while read id name pass
do
if [ "$2" == "$id" ]
then
flag=1
fi
done < student.csv
if [ $flag -eq 1 ]
then
	flag=0
	echo -e "\nCourse-Code	Attendance	Quiz	Mid-Term	Final	Total	Grade  Teacher-ID	Teacher Name"
	while read s_id t_id t_name c_code att quiz mid final total grade
	do
	if [ "$2" == "$s_id" ]
	then
	flag=1
	echo "$c_code    	$att              $quiz         $mid          $final       $total        $grade          $t_id	$t_name"
	fi
	done < enroll.csv
	if [ $flag -eq 0 ]
	then
	echo "The student isn't enrolled into any course"
	fi
read -p "Enter 'd' to delete his profile/ anything to return: " ch
case "$ch" in
'd') remove_student $1 $2 ;;
*) view_user $1 ;;
esac
else
echo "You have entered Invalid ID"
read -p "Enter anything to return: " ch
case "$ch" in
*) view_user $1 ;;
esac
fi
else
flag=0
while read id name pass
do
if [ "$2" == "$id" ]
then
flag=1
fi
done < teacher.csv
if [ $flag -eq 1 ]
then
	flag=0
	while read cCode iId
	do
	if [ "$2" == "$iId" ]
	then
	flag=1
	echo "$cCode"
	fi
	done < course.csv
	if [ $flag -eq 0 ]
	then
	echo "The teacher isn't conducting any course"
	fi
read -p "Enter 'd' to delete his profile/ anything to return: " ch
case "$ch" in
'd') remove_teacher $1 $2 ;;
*) view_user $1 ;;
esac
else
echo "You have entered Invalid ID"
read -p "Enter anything to return: " ch
case "$ch" in
*) view_user $1 ;;
esac
fi
fi
}


view_user()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
flag=0
echo -e "$1 lists\n"
echo "Id             Name"
while read id name pass
do
flag=1
echo "$id      $name"
done < $1.csv
if [ $flag -eq 0 ]
then
echo -e "\nThere are no $1s available"
fi
read -p "Enter $1 ID or 'r' to return to panel : " ch
case "$ch" in
'r') admin_panel ;;
*) details_view_user $1 $ch ;;
esac
}


authenticate()
{
flag=0
while read id name pass
do
if [ "$id" == "$1" ]
then
	if [ "$pass" == "$2" ]
	then
		flag=1
		break
	fi
fi
done < $3.csv
if [ "$flag" -eq "1" ]
then
echo ""
read -p "Authentication was successful $name. Now Press 1 to continue / 2 to return from here : " ch
case "$ch" in
1) $3_panel $id $name ;;
2) main ;;
esac
else
echo ""
read -p "Authentication was not successful. Invalid ID/ PASSWORD. Now Press 1 to enter again / 2 to return from here : " ch
case "$ch" in
1) $3_authenticate ;;
2) main ;;
esac
fi
}


student_authenticate()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo -e "WELCOME TO STUDENT PANEL\n"
read -p "Enter your student id : " sId
read -p "Enter your password : " sPass
authenticate $sId $sPass student
}


teacher_authenticate()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo -e "WELCOME TO TEACHER PANEL\n" 
read -p "Enter your teacher id : " tId
read -p "Enter your password : " tPass
authenticate $tId $tPass teacher
}


admin_authenticate()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo -e "WELCOME TO ADMIN PANEL\n" 
read -p "Enter your password : " pass
if [ "$pass" == "Sheam000" ]
then
admin_panel
else
echo ""
read -p "Authentication was not successful. Invalid PASSWORD. Now Press 1 to enter again / 2 to return from here : " ch
	if [ "$ch" -eq "1" ]
	then
	admin_authenticate
	else
	main
	fi
fi
authenticate $tId $tPass teacher
}


view_enrolled_course_details()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
flag=0
while read s_id t_id t_name c_code att quiz mid final total grade
do
if [ "$1" == "$s_id" ]
then
	if [ "$3" == "$c_code" ]
	then
	flag=1
	echo -e "\n$3\nCourse Instructor : $t_name"
	if [ "$att" == "--" ]
	then
	echo -e "\nThe teacher haven't entered your marks yet"
	fi
	echo "Attendance : $att"
	echo "Quiz : $quiz"
	echo "Mid-Term : $mid"
	echo "Final : $final"
	echo -e "\nTotal Marks : $total"
	echo "Your Grade is : $grade"
	echo ""
	fi
fi
done < enroll.csv
if [ $flag -eq 0 ]
then
echo "You are not enrolled into this Course"
fi
read -p "Press any key to return" ch
if [ "$ch" != "" ]
then
view_enrolled_courses $1 $2
fi
}


view_enrolled_courses()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo "Enrolled courses for you $2"
flag=0
while read s_id t_id t_name c_code att quiz mid final total grade
do
if [ "$1" == "$s_id" ]
then
flag=1
echo "$c_code   -->>   $t_name"
fi
done < enroll.csv
if [ $flag -eq 0 ]
then
echo -e "\nYou are not enrolled into any Course"
read -p "Press any key to return : " ch
if [ "$ch" != "" ]
then
student_panel $1 $2
fi
fi
read -p "Type Course-Code to view details / 'r' to return : " x
if [ "$x" == "r" ]
then 
student_panel $1 $2
else
view_enrolled_course_details $1 $2 $x 
fi
}


message_to_authority()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
read -p "To type the message press 1 : " ch
if [ "$ch" == "1" ]
then
read -p "Type message without comma or line break : " text
echo "$1,$2,$text" >> messageAdmin.csv
else
message_to_authority $1 $2
fi
}


student_panel()
{
while true
do
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo -e "\n Welcome dear $2 ($1)\n"
echo "1. View enrolled courses"
echo "2. Message to authority"
echo "3. Return to main menu"
read -p "Enter your choice : " ch
case "$ch" in
1) view_enrolled_courses $1 $2 ;;
2) message_to_authority $1 $2 ;;
*) main ;;
esac
done
}


view_students_for_teacher()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
flag=0
echo "$3"
echo "ID		Name"
while read s_id t_id t_name c_code att quiz mid final total grade
do
if [ "$3" == "$c_code" ]
then
flag=1
echo -n "$s_id	"
while read id name pass
do
if [ "$s_id" == "$id" ]
then
echo "$name"
fi
done < student.csv
fi
done < enroll.csv
if [ $flag -eq 0 ]
then
echo -e "\nNo Students are currently enrolled in this course" 
fi
read -p "Press any button to return : " ch
if [ "$ch" != "" ]
then
course_details_for_teacher $1 $2 $3
fi
}


course_details_for_teacher()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
flag=0
while read cCode iId
do
if [ "$cCode" == "$3" ]
then
if [ "$iId" == "$1" ]
then
flag=1
fi
fi
done < course.csv
if [ $flag -eq 0 ]
then
echo -n -e "\nYou are not appointed into this course.Press any button to return : "
read ch
if [ "$ch" != "" ]
then
teacher_panel $1 $2
fi
fi
while true
do
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo "$3"
echo "1. View the students"
echo "2. Access Result Sheet"
echo "3. Return"
read -p "Enter your choice : " ch
case "$ch" in
1) view_students_for_teacher $1 $2 $3 ;;
2) view_result_sheet_for_teacher $1 $2 $3 ;;
3) teacher_panel $1 $2 ;;
*) course_details_for_teacher $1 $2 $3 ;;
esac
done
}


modify_result_for_teacher()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
flag=0
while read s_id t_id t_name c_code att quiz mid final total grade
do
if [ "$3" == "$c_code" ]
then
if [ "$4" == "$s_id" ]
then
flag=1
echo "$4's previous result-sheet:"
echo -e "\nAttendance      Quiz      Mid-Term     Final      Total      Grade"
echo "$att               $quiz        $mid          $final          $total        $grade"
break
fi
fi
done < enroll.csv
if [ $flag -eq 0 ]
then
read -p "$4 is not enrolled into your $3 course. Press anything to return : " ch
if [ "$ch" != "" ]
then
view_result_sheet_for_teacher $1 $2 $3
fi
else
echo -e "\n Enter new marks, if you don't want to change any field then enter previous mark "
read -p "Enter Attendance: " a
read -p "Enter Quiz marks : " q
read -p "Enter new Mid-term marks : " m
read -p "Enter new Final marks : " f
if [ $a -gt 15 ] || [ $q -gt 15 ] || [ $m -gt 30 ] || [ $f -gt 40 ]; then
  read -n 1 -p "Invalid entry, press any key to enter again: " ch
  if [ "$ch" != "" ]; then
    modify_result_for_teacher $1 $2 $3 $4
  fi
else
t=0
t=$((a+q))
t=$((t+m))
t=$((t+f))
case $t in
  [8-9][0-9]|100)
    g="A+"
    ;;
  [7][0-9])
    g="A"
    ;;
  [6][0-9])
    g="A-"
    ;;
  [5][0-9])
    g="B"
    ;;
  [4][0-9])
    g="C"
    ;;
  [0-3][0-9])
    g="F"
    ;;
esac
touch temp.csv
while read sId tId tName cCode Att Quiz Mid Final Total Grade
do
if [ "$3" == "$cCode" ] && [ "$4" == "$sId" ]
then
echo "$sId,$tId,$tName,$cCode,$a,$q,$m,$f,$t,$g" >> temp.csv
else
echo "$sId,$tId,$tName,$cCode,$Att,$Quiz,$Mid,$Final,$Total,$Grade" >> temp.csv
fi
done < enroll.csv
cat temp.csv > enroll.csv
echo "Updated !"
rm temp.csv
read -p "Press any button to return : " c
if [ "$c" != "" ]
then
view_result_sheet_for_teacher $1 $2 $3
fi
fi
fi
}


view_result_sheet_for_teacher()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo "Dear $2 Sir/ Mam, this is the result-sheet for your $3 course"
flag=0
echo -e "\nID             Attendance      Quiz      Mid-Term     Final      Total      Grade"
while read s_id t_id t_name c_code att quiz mid final total grade
do
if [ "$3" == "$c_code" ]
then
flag=1
echo "$s_id      $att               $quiz        $mid          $final          $total        $grade"
fi
done < enroll.csv
if [ $flag -eq 0 ]
then
read -p "Enter anything to return : " ch
if [ "$ch" != "" ]
then
course_details_for_teacher $1 $2 $3
fi
fi
read -p "Enter the student ID to modify/ 'r' to return : " ch
if [ "$ch" == "r" ]
then
course_details_for_teacher $1 $2 $3
else
modify_result_for_teacher $1 $2 $3 $ch
fi
}


teacher_panel()
{
while true
do
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo -e "\n Welcome $2 ($1) Sir/Mam\n"
i=0
echo -e "\nYour Courses "
while read courseId iId
do
if [ "$1" == "$iId" ]
then
i=$((i+1))
echo "$courseId"
fi
done < course.csv
if [ $i -eq 0 ]
then
echo -n -e "\nYou are not appointed to any courses\nPress anything to return : "
read c
if [ "$c" != "" ]
then
main
fi
else
read -p "Enter course code to work further otherwise press 'r' to return : " ch
case "$ch" in
'r') main ;;
*) course_details_for_teacher $1 $2 $ch ;;
esac
fi
done
}


create_a_course()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
while true
do
read -p "Course code : " courseCode
read -p "Course instructor id : " instuctorId
flag=0
flag1=0
while read cCode iId
do
if [ "$courseCode" == "$cCode" ]
then
flag=1
break
fi
done < course.csv
if [ $flag -eq 1 ]
then
echo "This course already exists"
else
while read id name pass
do
if [ "$id" == "$instuctorId" ]
then
flag1=1
fi
done < teacher.csv
if [ $flag1 -eq 0 ]
then
echo "Invalid instructor ID"
else
echo "$courseCode,$instuctorId" >> course.csv
echo "Course added successfully"
fi
fi
read -p "Press 1 to add course / 2 to return : " ch
if [ "$ch" == "1" ]
then
create_a_course
else
admin_panel
fi
done
}


enroll()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
read -p "Enter Student ID : " sId
read -p "Enter Course-Code: " cCode
flag=0
while read s_id t_id t_name c_code att quiz mid final total grade
do
if [ "$s_id" == "$sId" ]
then
if [ "$c_code" == "$cCode" ]
then
flag=1
fi
fi
done < enroll.csv
if [ $flag -eq 1 ]
then
echo "This student is already enrolled into that course"
read -p "Enter 1 to try again or press any other key to return to the panel : " ch
if [ "$ch" == "1" ]
then
enroll
else
admin_panel
fi
fi
flag=0
while read id name pass
do
if [ "$sId" == "$id" ]
then
flag=1
fi
done < student.csv
if [ $flag -eq 0 ]
then
echo "Sorry, Try to give the correct Student ID next time"
read -p "Enter 1 to try again or press any other key to return to the panel : " ch
if [ "$ch" == "1" ]
then
enroll
else
admin_panel
fi
else
					flag=0
					while read code id	
					do
					if [ "$cCode" == "$code" ]
					then
					flag=1
					tId=$id
					fi
					done < course.csv
					if [ $flag -eq 0 ]
					then
					echo "Sorry, Try to give the correct Course-Code next time"
					read -p "Enter 1 to try again or press any other key to return to the panel : " ch
					if [ "$ch" == "1" ]
					then
					enroll
					else
					admin_panel
					fi
					else
					while read id name pass
					do
					if [ "$tId" == "$id" ]
					then
					n=$name
					fi
					done < teacher.csv
					echo "$sId,$tId,$n,$cCode,--,--,--,--,--,--" >> enroll.csv
					echo "Added Successfully"
					read -p "Enter 1 to enroll again or press any other key to return to the panel : " ch
					if [ "$ch" == "1" ]
					then
					enroll
					else
					admin_panel
					fi
					fi	
fi
}


remove_message()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
touch temp.csv
while read id name msg
do
if [ "$1" != "$id" ]
then
echo "$id,$name,$msg" >> temp.csv
fi
done < messageAdmin.csv
cat temp.csv > messageAdmin.csv
rm temp.csv
echo "Deleted the conversation successfully"
read -p "Enter anything to return : " ch
if [ "$ch" != "" ]
then
messages
fi
}


view_message()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
i=0
while read id name text
do
if [ "$1" == "$id" ]
then
echo "$text"
i=1
fi
done < messageAdmin.csv
if [ $i -eq 0 ]
then
echo "Invalid ID"
read -p "Enter anything to return : " ch
if [ "$ch" != "" ]
then
messages
fi
else
read -p "Press 'd' to delete the conversation/ anything to return : " ch
if [ "$ch" == "d" ]
then
remove_message $1
else
messages
fi
fi
echo ""
}


remove_course()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
flag=0
while read cCode iId
do
if [ "$1" == "$cCode" ]
then
flag=1
fi
done < course.csv
if [ $flag -eq 1 ]
then
touch temp.csv
	while read cCode iId
	do
	if [ "$1" != "$cCode" ]
	then
	echo "$cCode,$iId" >> temp.csv
	fi
	done < course.csv
cat temp.csv > course.csv
rm temp.csv
touch temp.csv
	while read s_id t_id t_name c_code att quiz mid final total grade
	do
	if [ "$1" != "$c_code" ]
	then
	echo "$s_id,$t_id,$t_name,$c_code,$att,$quiz,$mid,$final,$total,$grade" >> temp.csv
	fi
	done < enroll.csv	
cat temp.csv > enroll.csv
rm temp.csv
echo "Deleted $1 course successfully"
else
echo "You have entered Invalid Course-Code"
fi
read -p "Enter anything to return : " ch
if [ "$ch" != "" ]
then
view_courses
fi
}


view_courses()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo "These are the courses available right now"
i=0
echo -e "\nCode		Instructor"
while read cCode iId
do
i=1
echo -n "$cCode		"
while read id name pass
do
if [ "$iId" == "$id" ]
then
echo "$name ($id)"
fi
done < teacher.csv
done < course.csv
if [ $i -eq 0 ]
then
echo -e "\nThere are no courses available"
fi
read -p "Enter Course-Code to remove the course/ Type 'r' to return : " ch
if [ "$ch" == "r" ]
then
admin_panel
else
remove_course $ch
fi
}


messages()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo -e "This is your inbox. These students have sent you their messages.\n"
echo "ID             Name"
i=0
while read id name text
do
echo "$id      $name"
i=$((i+1))
done < messageAdmin.csv
if [ $i -eq 0 ]
then
echo -e "\nThere are no messages"
fi
read -p "Type ID to see the message/'r' to return : " ch
if [ "$ch" == "r" ]
then
admin_panel
else
view_message $ch
fi
}


admin_panel()
{
clear
printf "%$(tput cols)s\n"|tr " " "*"
echo -e "WELCOME TO ADMIN PANEL\n"
echo "1. Create Teacher profile"
echo "2. Create Student profile"
echo "3. View Teachers list"
echo "4. View Students list" 
echo "5. Create a Course" 
echo "6. View Courses" 
echo "7. Enroll a Student into a course" 
echo "8. Messages" 
echo -n -e "\n Enter your choice(9 to return to main menu) : "
read choice
case "$choice" in
1) add_user teacher ;;
2) add_user student ;;
3) view_user teacher ;;
4) view_user student ;;
5) create_a_course ;;
6) view_courses ;;
7) enroll ;;
8) messages ;;
9) main;;
*) admin_panel ;;
esac
}


main()
{
while true
do
clear
printf "%$(tput cols)s\n"|tr " " "-"
echo -e "WELCOME TO OUR PROGRAM\n"
echo "1. Student Panel"
echo "2. Teacher Panel"
echo "3. Admin Panel"
echo "4. Exit"
echo -n -e "\n Enter your choice : "
read choice
case "$choice" in
1) student_authenticate ;;
2) teacher_authenticate ;;
3) admin_authenticate ;;
4) exit ;;
*) echo "Invalid Input" ;;
esac
done
}


main
