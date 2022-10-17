<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.math.BigInteger" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change your Information</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <link href="simple.css" rel="stylesheet">
    <%!
        public String makeRequest(String url, String method) throws IOException {
            URL urlObj = new URL(url.replace(' ', '_'));
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

        public String MD5_hash(String password) throws NoSuchAlgorithmException {
            //Setup MD5 cipher
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] MD5digest = md.digest(password.getBytes(StandardCharsets.UTF_8));
            //Convert Digest to HEX
            BigInteger bi = new BigInteger(1, MD5digest);
            return String.format("%0" + (MD5digest.length << 1) + "X", bi);
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
            String NAME = request.getParameter("name");
            String PASS = request.getParameter("pass");
            String EMAIL = request.getParameter("email");

            try {
                PASS = MD5_hash(PASS);
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            }

            makeRequest("http://localhost:8080/Project_war_exploded/rest/services/changeClient/" + NAME + "/" + PASS + "/" + EMAIL, "PUT");

            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/simple/showAppointments.jsp");

        }

        String result = makeRequest("http://localhost:8080/Project_war_exploded/rest/services/getLoginAMKAInfo/","GET");

        String info_AMKA="";
        String info_name="";
        String info_email="";
        String info_date="";
        if (result.equals("LOGOUT")){
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "http://localhost:8080/Project_war_exploded/login/login.jsp?logout=1");
        } else {
            info_date = result.substring(0,2)+"-"+result.substring(2,4)+"-"+result.substring(4,6);
            info_AMKA = Arrays.asList(result.split(",")).get(0);
            info_email = Arrays.asList(result.split(",")).get(1);
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
            <img src="simple_icon.png" class="img-fluid">
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
                    <td>Απλός Χρήστης</td>
                  </tr>
                </tbody>
            </table>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/showAppointments.jsp"'>Προβολή Ραντεβού</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/changeAccountInfo.jsp"' style="background-color:#6E8898; color: #D9B48F;">Αλλαγή Στοιχείων</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/cancelAppointment.jsp"'>Ακύρωση Ραντεβού</button>
        </div>
        <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/simple/bookAppointment.jsp"'>Κράτηση Ραντεβού</button>
        </div>
    </div>
    <br><br><br>

    <div class="row">
       <div class="col-md-4"></div>
       <div class="col-md-4 d-flex align-items-center justify-content-center">
           <form method="post">
                <div>
                    <label for="name">Ονοματεπωνυμο</label>
                    <input id="name" type="text" name="name" value="<%=info_name%>" required>
                </div>
                <div>
                    <label for="pass">Κωδικος</label>
                    <input id="pass" type="password" name="pass" required>
                </div>
                <div>
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email" value="<%=info_email%>" required>
                </div>
                <div>
                    <label for="AMKA">ΑΜΚΑ</label>
                    <input id="AMKA" type="number" name="AMKA" value="<%=info_AMKA%>" disabled>
                </div>
                <div>
                    <input type="submit" name="button" class="button big-button" value="Αλλαγη Στοιχειων">
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
