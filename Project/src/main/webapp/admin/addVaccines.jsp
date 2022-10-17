<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@ page import="java.util.Arrays" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Available Vaccines</title>
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

        if (request.getParameter("alert") != null){
            %>
            <script>
                alert('<%=request.getParameter("alert")%>');
            </script>
            <%
        }

        if (request.getParameter("button") != null) {
            String date = request.getParameter("date");
            String vaccines = request.getParameter("vaccines");

            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/addVaccines/" + date + "/" + vaccines,"POST");
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/addVaccines.jsp?alert=Changes are saved successfully!");
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
            <button type="button" class="btn-lg upper-button" style="background-color:#6E8898; color: #D9B48F;" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/addVaccines.jsp"'>Προσθήκη Εμβολίων</button>
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
       <div class="col-md-4"></div>
       <div class="col-md-4 d-flex align-items-center justify-content-center">
           <form method="post">
                <div>
                    <label for="date">Ημερομηνια</label>
                    <input id="date" type="date" name="date" style="text-align: center;" min="2022-01-01" required>
                </div>
                <div>
                    <label for="vaccines">Αριθμος εμβολιων</label>
                    <input id="vaccines" type="number" name="vaccines" style="text-align: center;" min="1" required>
                </div>
                <div>
                    <input type="submit" name="button" class="button big-button" value="Προσθηκη εμβολιων">
                </div>
           </form>
       </div>
    </div>
    <br><br><br>
</body>

<footer class="footer">
    <h3>Antonisr11</h3>
</footer>

</html>
