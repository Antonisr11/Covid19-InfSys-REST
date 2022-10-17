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
    <title>Register Admin</title>
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
            String NAME = request.getParameter("name").replace(' ','_');
            String PASS = request.getParameter("pass");
            String EMAIL = request.getParameter("email");
            String AMKA = request.getParameter("AMKA");

            try {
                PASS = MD5_hash(PASS);
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            }

            response.setStatus(response.SC_MOVED_TEMPORARILY);
            switch (makeRequest("http://localhost:8080/Project_war_exploded/rest/services/adminRegister/" + NAME + "/" + PASS + "/" + EMAIL + "/" + AMKA,"POST")) {
                case "AMKA FORMAT":
                    response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/registerAdmin.jsp?alert=Wrong AMKA format (must be 11 numbers)");
                    break;
                case "AMKA EXISTS":
                    response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/registerAdmin.jsp?alert=There is account with this AMKA.");
                    break;
                case "OK":
                    response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/registerAdmin.jsp?alert=Admin registered successfully!");
                    break;
                default:
                    response.setHeader("Location", "http://localhost:8080/Project_war_exploded/admin/registerAdmin.jsp?alert=Something went wrong with request.");
                    break;
            }
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
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/addVaccines.jsp"'>Προσθήκη Εμβολίων</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/showUsers.jsp"'>Προβολή μελών</button>
        </div>
        <div class="col-md-1 d-flex align-items-center justify-content-center">
            <button type="button" class="btn-lg upper-button" style="background-color:#6E8898; color: #D9B48F;" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/admin/registerAdmin.jsp"'>Εγγραφή Admin</button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4 d-flex align-items-center justify-content-center">
            <h2 style="color:#2E5266;"><b>ΕΓΓΡΑΦΗ ADMIN</b></h2>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4 d-flex align-items-center justify-content-center">
            <h6 style="color:#2E5266;">Χρήση μόνο λατινικών χαρακτήρων</h6>
        </div>
    </div>

    <div class="row">
       <div class="col-md-4"></div>
       <div class="col-md-4 d-flex align-items-center justify-content-center">
           <form method="post">
                <div>
                    <label for="name">Ονοματεπωνυμο</label>
                    <input id="name" type="text" name="name" required>
                </div>
                <div>
                    <label for="pass">Κωδικος</label>
                    <input id="pass" type="password" name="pass" required>
                </div>
                <div>
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email" required>
                </div>
                <div>
                    <label for="AMKA">ΑΜΚΑ</label>
                    <input id="AMKA" type="number" name="AMKA" min="1000000000" max="31129999999" required>
                </div>
                <div>
                    <input type="submit" name="button" class="button big-button" value="Εγγραφη">
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
