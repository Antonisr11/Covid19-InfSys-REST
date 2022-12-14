<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@ page import="java.util.Arrays" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Settings</title>
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

        String min_years = request.getParameter("min-years");
        String max_vaccines = request.getParameter("max-vaccines");
        String days_for_next_vaccine = request.getParameter("days-for-next-vaccine");
        if (request.getParameter("button") != null) {
            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/changeSystemSettings/" + min_years + "/" + max_vaccines + "/" + days_for_next_vaccine,"PUT");
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/changeOptions.jsp?alert=Changes are saved successfully!");
        }
        else {
            String result = makeRequest("http://localhost:8080/Project_war_exploded/rest/services/getSystemSettings/","GET");

            min_years = result.split(",")[0];
            max_vaccines = result.split(",")[1];
            days_for_next_vaccine= result.split(",")[2];
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
        <button type="button" class="btn btn-primary btn-lg"
                onclick='window.location.href = "http://localhost:8080/Project_war_exploded/login/login.jsp?logout=1"'>
            ????????????????????
        </button>
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
        <button type="button" class="btn-lg upper-button"
                onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/showAppointments.jsp"'>
            ?????????????? ????????????????
        </button>
    </div>
    <div class="col-md-1 d-flex align-items-center justify-content-center">
        <button type="button" class="btn-lg upper-button" style="background-color:#6E8898; color: #D9B48F;"
                onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/changeOptions.jsp"'>
            ???????????? ????????????????
        </button>
    </div>
    <div class="col-md-1 d-flex align-items-center justify-content-center">
        <button type="button" class="btn-lg upper-button"
                onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/addVaccines.jsp"'>
            ???????????????? ????????????????
        </button>
    </div>
    <div class="col-md-1 d-flex align-items-center justify-content-center">
        <button type="button" class="btn-lg upper-button"
                onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/showUsers.jsp"'>
            ?????????????? ??????????
        </button>
    </div>
    <div class="col-md-1 d-flex align-items-center justify-content-center">
        <button type="button" class="btn-lg upper-button"
                onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/registerAdmin.jsp"'>
            ?????????????? Admin
        </button>
    </div>
</div>
<br><br><br>

<div class="row">
    <div class="col-md-4"></div>
    <div class="col-md-4 d-flex align-items-center justify-content-center">
        <form method="post">
            <div>
                <label for="min-years">???????????????? ???????? ??????????????</label>
                <input id="min-years" type="number" name="min-years" style="text-align: center;" min="0" value="<%=min_years%>"
                       required>
            </div>
            <div>
                <label for="max-vaccines">???????????????? ?????????????? ???????????????? ?????? ??????????</label>
                <input id="max-vaccines" type="number" name="max-vaccines" style="text-align: center;" min="0" value="<%=max_vaccines%>"
                       required>
            </div>
            <div>
                <label for="days-for-next-vaccine">?????????????????? ?????????? ?????? ???? ?????????????? ??????????????</label>
                <input id="days-for-next-vaccine" type="number" name="days-for-next-vaccine" style="text-align: center;"
                       min="0" value="<%=days_for_next_vaccine%>" required>
            </div>
            <div>
                <input type="submit" name="button" class="button big-button" value="?????????????? ????????????????">
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
