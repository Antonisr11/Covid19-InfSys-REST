<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@ page import="java.util.Arrays" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Appointment</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <link href="simple.css" rel="stylesheet">

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
        if (request.getParameter("appointmentDate") != null){
            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/insertAppointment/"+request.getParameter("appointmentDate"),"POST");
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/simple/showAppointments.jsp");
        }

        String result= makeRequest("http://localhost:8080/Project_war_exploded/rest/services/getLoginAMKAInfo/","GET");

        String info_name="";
        String info_date="";
        if (result.equals("LOGOUT")){
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/login/login.jsp?logout=1");
        } else {
            info_date = result.substring(0,2)+"-"+result.substring(2,4)+"-"+result.substring(4,6);
            info_name = Arrays.asList(result.split(",")).get(2).replace('_', ' ');
        }

        String[] appointments = makeRequest("http://localhost:8080/Project_war_exploded/rest/services/getAvailableAppointments", "GET").split(",,");
    %>
</head>
<body>
    <div class="row" style="background-color:#6E8898; min-height:10vh">
        <div class="col-md-4"></div>
        <div class="col-md-4 d-flex align-items-center justify-content-center">
            <h1>?????????????????????? COVID-19</h1>
        </div>
        <div class="col-md-2"></div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn btn-primary btn-lg" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/login/login.jsp?logout=1"'>????????????????????</button>
        </div>
    </div>

    <div class="row">
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <img src="simple_icon.png" class="img-fluid">
        </div>
        <div class="col-md-3 d-flex align-items-center justify-content-center">
            <table class="table">
                <tbody>
                  <tr>
                    <td>??????????</td>
                    <td><%=info_name%></td>
                  </tr>
                  <tr>
                    <td>????/?????? ????????????????</td>
                    <td><%=info_date%></td>
                  </tr>
                  <tr>
                    <td>??????????</td>
                    <td>?????????? ??????????????</td>
                  </tr>
                </tbody>
            </table>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/showAppointments.jsp"'>?????????????? ????????????????</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/changeAccountInfo.jsp"'>???????????? ??????????????????</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/cancelAppointment.jsp"'>?????????????? ????????????????</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/bookAppointment.jsp"' style="background-color:#6E8898; color: #D9B48F;">?????????????? ????????????????</button>
        </div>
    </div>
    <br><br>

    <div class="row">
        <div class="col-md-1"></div>
        <div class="col-md-9">
            <h2>?????????? ?????????????????? ???? ???????? ????????????????:</h2>
        </div>
    </div>
    <br>
    <div class="row">
       <div class="col-md-3">
       </div>
       <div class="col-md-6">
           <table class="table table-bordered" style='font-size:25px; text-align: center;'>
               <tr>
                   <th>????????????????????</th>
                   <th>??????????????</th>
                   <th>??????????????</th>
               </tr>
               <tbody>
               <%
                   for (String appointment : appointments) {
                       if (appointment.length() == 0 || Integer.parseInt(appointment.substring(11)) < 1 || makeRequest("http://localhost:8080/Project_war_exploded/rest/services/isAppointmentOK/"+appointment.substring(0, 10),"GET").equals("NO") ) {
                           // We must NOT show user an appointment if:
                           // 1. Appointment has no available seats
                           // 2. Appointment's date is older than today
                           // 3. Appointment is +/- days_for_next_vaccine from any closed appointment
                           continue;
                       }
               %>
               <tr>
                   <td><%=appointment.substring(0, 10)%></td>
                   <td><%=appointment.substring(11)%></td>
                   <td><button type="button" class="btn btn-primary" onclick="window.location = 'http://localhost:8080/Project_war_exploded/simple/bookAppointment.jsp?appointmentDate=<%=appointment.substring(0, 10)%>';">??????????????</button></td>
               </tr>
               <%
                   }
               %>
               </tbody>
           </table>
       </div>
    </div>
    <br><br><br><br><br><br>
</body>

<footer class="footer">
    <input type="submit" name="button" class="button big-button" onClick="window.location.reload();" value="???????????????? ??????????????">
    <h3>Antonisr11</h3>
</footer>

</html>
