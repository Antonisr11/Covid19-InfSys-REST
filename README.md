## Covid19-InfSys-REST

This is an Information System based on REST (SOA) for both citizens willing to be vaccinated and for vaccinators.

## How to install

### MySQL

1. Download and install MySQL (https://dev.mysql.com/downloads/mysql)
2. Open "MySQL Workbench 8.0 CE" and click on instance MySQL80

![image](https://user-images.githubusercontent.com/76475823/196142622-d9678f81-0c17-4cd5-a776-418139a825ad.png)

3. Click "Data Import/Restore"

![image](https://user-images.githubusercontent.com/76475823/196142829-050e9594-a143-4a62-8c70-56456992b1b1.png)

4. Click "Import From Self-Contained File"

![image](https://user-images.githubusercontent.com/76475823/196143097-d36972a2-ed54-40c3-9144-37ea837cc1c7.png)

5. Select "my_db.sql" file from this repository and click "Start Import"

### IntelliJ Ultimate & Apache Tomcat

1. Download and install IntelliJ Ultimate (https://www.jetbrains.com/lp/intellij-frameworks)
2. From the welcome screen click "Open" and select folder "Project" from this repository
3. InteliJ will show 2 messeges

![image](https://user-images.githubusercontent.com/76475823/196144087-62b80b9b-b225-49b2-b395-e449285c0781.png)

Click Configure in "Frameworks detected" window, and then click OK. Then click Load in "Maven build script found" window.

4. Download Apache Tomcat and unzip it (https://tomcat.apache.org/download-90.cgi)
5. Then import it in IntelliJ by clicking Settings -> Build, Execution, Deployment -> Application Servers -> + -> Tomcat Server

![image](https://user-images.githubusercontent.com/76475823/196145202-6e2544c4-476e-4ae5-834f-639110916672.png)

6. In "Tomcat Home" field, select the folder you unzipped from step 4, and click OK and Apply.
7. Click "Add Configuration" -> + -> Tomcat Server -> Local

![image](https://user-images.githubusercontent.com/76475823/196145986-acdb073a-21a3-4330-a103-c0253ec0163d.png)

8. If a red lamb appears, click on it and then select "Project:war exploded"
9. Click File -> Project Structure -> Project Settings -> Project, and setup an SDK (I have tested Oracle OpenJDK 17.0.2)
10. Restart IDE 
11. Download mysql-connector (https://dev.mysql.com/downloads/connector/j/5.1.html)
12. Back in IntelliJ, run Project and it should appear a file "lib" in location Project/target/Project-1.0-SNAPSHOT/WEB-INF/lib. Paste here "mysql-connector-java-8.0.28.jar" from the previous step
13. Open "http://localhost:8080/Project_war_exploded/login/login.jsp" from any browser

## General

This information system requires login from the user to continue (user can create an account if they haven't already). 

User must provide full name, password, email, and ΑΜΚΑ (ΑΜΚΑ is a unique number for each person).

![image](https://user-images.githubusercontent.com/76475823/196152558-095e6bc0-1bcf-43ed-baf5-5010f60ccd38.png)

### Simple User

If the user is not an admin they are able to:

1. See their appointments

![image](https://user-images.githubusercontent.com/76475823/196152432-8508efea-fdc6-4747-b0d5-fa6e9a8bebc6.png)

2. Change their personal info

Change ΑΜΚΑ is prohibited so this field is disabled.

![image](https://user-images.githubusercontent.com/76475823/196153379-a64518f4-fa14-43de-ac9c-253fe2290a1c.png)

3. Cancel all their appointments

![image](https://user-images.githubusercontent.com/76475823/196153749-d451e071-122b-4af3-931f-11a4cb7bfca1.png)

4. Book an appointment 

![image](https://user-images.githubusercontent.com/76475823/196173057-57553267-66c9-41ef-aa02-44030526f2d0.png)

### Admin User

If the user is an admin they are able to:

1. See all appointments

![image](https://user-images.githubusercontent.com/76475823/196175175-4a498191-aec1-4e1b-8eba-7d02f72969c6.png)

User can see what appointments are booked for a certain date. Then they can delete them or mark them as completed (all or each one individually) 

![image](https://user-images.githubusercontent.com/76475823/196175501-a886f4ce-a648-4243-9cd7-59e266a2a987.png)

2. Change options on the system

Admin users can set the lowerest age limit to book appointments, the maximum number of vaccines per person, and the minimum number of days that have to pass between two appointments.

![image](https://user-images.githubusercontent.com/76475823/196177205-e6ba7ea5-dcd3-49f4-9afc-25b23d0dcd55.png)

3. Add available vaccines on certain date

![image](https://user-images.githubusercontent.com/76475823/196177415-fb30101c-bb00-40be-9b50-d23bcef38174.png)

4. Show all users' info

![image](https://user-images.githubusercontent.com/76475823/196177471-5e969bf4-f3f6-4d2e-b2d0-1c6b58275382.png)

5. Register another admin user

![image](https://user-images.githubusercontent.com/76475823/196177567-9052e3f1-ff18-4259-a57a-a516ad38cd29.png)
