<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="bootstrap.min.css" rel="stylesheet">
    <link href="admin.css" rel="stylesheet">
    <%!
        public String makeRequest(String url, String method) throws IOException {
            URL urlObj = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) urlObj.openConnection();
            connection.setRequestMethod(method);

            if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                BufferedReader inputReader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String inputLine;
                StringBuilder stringBuilder = new StringBuilder();
                while ((inputLine = inputReader.readLine()) != null) {
                    stringBuilder.append(inputLine);
                }
                inputReader.close();
                return stringBuilder.toString();
            }
            return "";
        }
    %>

    <%
        String date = "";
        if (request.getParameter("date") != null) {
            date = request.getParameter("date");
        }
        else {
            //There is no use so go to showAppointments
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/showAppointments.jsp");
        }

        if (request.getParameter("cancel") != null){
            String ID = request.getParameter("cancel");
            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/cancelAppointmentByID/"+ID,"DELETE");
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/showAppointmentsShowNames.jsp?date="+date);
        } else if (request.getParameter("complete") != null){
            String ID = request.getParameter("complete");
            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/completeVaccinationByID/"+ID,"PUT");
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/showAppointmentsShowNames.jsp?date="+date);
        } else if (request.getParameter("cancelAll") != null){
            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/cancelAllAppointmentsByDATE/"+date,"DELETE");
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/showAppointments.jsp");
        } else if (request.getParameter("completeAll") != null){
            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/completeAllVaccinationsByDATE/"+date,"PUT");
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/showAppointments.jsp");
        }

        String result = makeRequest("http://localhost:8080/Project_war_exploded/rest/services/getLoginAMKAInfo/","GET");
        String info_name="";
        String info_date="";
        if (result.equals("LOGOUT")){
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/login/login.jsp?logout=1");
        } else {
            info_date = result.substring(0,2)+"-"+result.substring(2,4)+"-"+result.substring(4,6);
            info_name = Arrays.asList(result.split(",")).get(2).replace('_', ' ');
        }

        String[] appointments = makeRequest("http://localhost:8080/Project_war_exploded/rest/services/getAppointmentsInDate/"+date,"GET").split(",,");
    %>
    <title>Show Appointments at <%=date%></title>
</head>
<body>
    <div class="row" style="background-color:#6E8898; min-height:10vh">
        <div class="col-md-4"></div>
        <div class="col-md-4 d-flex align-items-center justify-content-center">
            <h1>Εμβολιασμός COVID-19</h1>
        </div>
        <div class="col-md-2"></div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn btn-primary btn-lg" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/login/login.jsp?logout=1"'>Αποσύνδεση</button>
        </div>
    </div>

    <div class="row">
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <img src="admin_icon.png" class="img-fluid">
        </div>
        <div class="col-md-3 d-flex align-items-center justify-content-center">
            <table class="table">
                <tbody>
                  <tr>
                    <td>ΟΝΟΜΑ</td>
                    <td><%=info_name%></td>
                  </tr>
                  <tr>
                    <td>ΗΜ/ΝΙΑ ΓΕΝΝΗΣΗΣ</td>
                    <td><%=info_date%></td>
                  </tr>
                  <tr>
                    <td>ΤΥΠΟΣ</td>
                    <td>Διαχειριστής</td>
                  </tr>
                </tbody>
            </table>
        </div>
        <div class="col-md-1"></div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/showAppointments.jsp"'>Προβολή Ραντεβού</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/changeOptions.jsp"'>Αλλαγή Επιλογών</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/addVaccines.jsp"'>Προσθήκη Εμβολίων</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/showUsers.jsp"'>Προβολή μελών</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/registerAdmin.jsp"'>Εγγραφή Admin</button>
        </div>
    </div>
    <br><br><br>

    <div class="row">
        <div class="col-md-1"></div>
        <div class="col-md-9">
            <h2>Στις <b><%=date%></b> υπάρχουν τα εξής ραντεβού:</h2>
        </div>
    </div>
    <br>
    <div class="row">
       <div class="col-md-3"></div>
       <div class="col-md-6">
           <table class="table table-bordered" style='font-size:25px; text-align: center;'>
               <tr>
                <th>Ονοματεπώνυμο</th>
                <th>Ώρα</th>
                <th>Ολοκληρωμένο</th>
                <th>Ενέργεια</th>
              </tr>
                <tbody>
                <%
                    for (String appointment : appointments) {
                        if (appointment.length() == 0) {
                            continue;
                        }
                        List<String> appointment_details = Arrays.asList(appointment.split(","));
                %>
                  <tr>
                    <td><%=appointment_details.get(0).replace('_',' ')%></td>
                    <td><%=appointment_details.get(1)%></td>
                    <td><%=appointment_details.get(2)%></td>
                    <td>
                        <div class="btn-group">
                            <button type="button" class="btn btn-danger" onclick="window.location.href = 'http://localhost:8080/Project_war_exploded/admin/showAppointmentsShowNames.jsp?date=<%=date%>&cancel=<%=appointment_details.get(3)%>'">Διαγραφή</button>
                            <button type="button" class="btn btn-success" onclick="window.location.href = 'http://localhost:8080/Project_war_exploded/admin/showAppointmentsShowNames.jsp?date=<%=date%>&complete=<%=appointment_details.get(3)%>'" <%if (appointment_details.get(2).equals("NAI")) {%> disabled <%}%>>Ολοκλήρωση</button>
                        </div>
                    </td>
                  </tr>
                <%
                   }
                %>
                </tbody>
            </table>
       </div>
    </div>
    <br>
    <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <input type="submit" name="button" class="button big-button" onclick="window.location.href = 'http://localhost:8080/Project_war_exploded/admin/showAppointmentsShowNames.jsp?date=<%=date%>&cancelAll=1'" value="Διαγραφη ολων">
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <input type="submit" name="button" class="button big-button" onclick="window.location.href = 'http://localhost:8080/Project_war_exploded/admin/showAppointmentsShowNames.jsp?date=<%=date%>&completeAll=1'"  value="Ολοκληρωση ολων">
        </div>
    </div>

    <br><br><br>
</body>

<footer class="footer">
    <h3>Antonisr11</h3>
</footer>

</html>
