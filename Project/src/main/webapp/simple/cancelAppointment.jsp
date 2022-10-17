<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cancel Appointments</title>
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

        if (request.getParameter("button") != null){
            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/clientDeleteAppointments","DELETE");
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/simple/showAppointments.jsp");
        }

        String result=makeRequest("http://localhost:8080/Project_war_exploded/rest/services/getLoginAMKAInfo/","GET");
        String info_name="";
        String info_date="";
        if (result.equals("LOGOUT")){
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/login/login.jsp?logout=1");
        } else {
            info_date = result.substring(0,2)+"-"+result.substring(2,4)+"-"+result.substring(4,6);
            info_name = Arrays.asList(result.split(",")).get(2).replace('_', ' ');
        }

        List<String> appointments = Arrays.asList(makeRequest("http://localhost:8080/Project_war_exploded/rest/services/takeAppointmentsOfOneUser", "GET").split(",,"));
    %>
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
            <img src="simple_icon.png" class="img-fluid">
        </div>
        <div class="col-md-3  d-flex align-items-center justify-content-center">
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
                    <td>Απλός Χρήστης</td>
                  </tr>
                </tbody>
            </table>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/showAppointments.jsp"'>Προβολή Ραντεβού</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/changeAccountInfo.jsp"'>Αλλαγή Στοιχείων</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/cancelAppointment.jsp"' style="background-color:#6E8898; color: #D9B48F;">Ακύρωση Ραντεβού</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/bookAppointment.jsp"'>Κράτηση Ραντεβού</button>
        </div>
    </div>
    <br><br>

    <div class="row">
        <div class="col-md-1"></div>
        <div class="col-md-9">
            <h2>Πρόκειται να ακυρώσετε τα εξής ραντεβού:</h2>
        </div>
    </div>
    <br>
    <div class="row">
       <div class="col-md-3"></div>
       <div class="col-md-6">
           <table class="table table-bordered" style='font-size:25px;'>
               <tr>
                <th>Δόση</th>
                <th>Ημερομηνία Ραντεβού</th>
                <th>Ώρα</th>
                <th>Ολοκληρωμένο</th>
              </tr>
                <tbody>
                <%
                    boolean isThereAppointment = Boolean.FALSE;
                    for (int i = 0; i< appointments.size(); i++){
                        if (appointments.get(i).length()==0  || appointments.get(i).substring(17).equals("NAI")){
                            continue;
                        }
                        isThereAppointment = Boolean.TRUE;
                %>
                <tr>
                    <td><%=(i+1)%>η</td>
                    <td><%=appointments.get(i).substring(0,10)%></td>
                    <td><%=appointments.get(i).substring(11,16)%></td>
                    <td><%=appointments.get(i).substring(17)%></td>
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
        <div class="col-md-4 d-flex align-items-center justify-content-center">
            <form method="post">
                <input type="submit" name="button" class="button big-button" value="Διαγραφη" <% if (!isThereAppointment){ %> disabled <% } %>>
            </form>
        </div>
    </div>

    <br><br><br>
</body>

<footer class="footer">
    <h3>Antonisr11</h3>
</footer>

</html>
