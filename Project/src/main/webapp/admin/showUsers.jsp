<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Show all users</title>
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

        String[] users = makeRequest("http://localhost:8080/Project_war_exploded/rest/services/getAllUsers", "GET").split(",,");
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
            <img src="admin_icon.png" class="img-fluid">
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
                    <td>????????????????????????</td>
                  </tr>
                </tbody>
            </table>
        </div>
        <div class="col-md-1"></div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/showAppointments.jsp"'>?????????????? ????????????????</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/changeOptions.jsp"'>???????????? ????????????????</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/addVaccines.jsp"'>???????????????? ????????????????</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" style="background-color:#6E8898; color: #D9B48F;" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/showUsers.jsp"'>?????????????? ??????????</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/registerAdmin.jsp"'>?????????????? Admin</button>
        </div>
    </div>
    <br><br><br><br>

    <div class="row">
       <div class="col-md-3"></div>
       <div class="col-md-6">
           <table class="table table-bordered" style='font-size:25px; text-align: center;'>
               <tr>
                <th>??????????????????????????</th>
                <th>????????</th>
                <th>E-mail</th>
                <th>??????????</th>
              </tr>
                <tbody>
                <%
                    for (String user : users) {
                        if (user.length() == 0) {
                            continue;
                        }
                        List<String> user_details = Arrays.asList(user.split(","));
                %>
                  <tr>
                    <td><%=user_details.get(0).replace('_',' ')%></td>
                    <td><%=user_details.get(1)%></td>
                    <td>
                        <a href = "mailto:<%=user_details.get(2)%>"><%=user_details.get(2)%></a>
                    </td>
                    <td><%=user_details.get(3).equals("0")?"?????????? ??????????????":"????????????????????????"%></td>
                  </tr>
                <%
                    }
                %>
                </tbody>
            </table>
       </div>
    </div>
    <br>

    <br><br><br>
</body>

<footer class="footer">
    <h3>Antonisr11</h3>
</footer>

</html>
