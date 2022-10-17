<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.math.BigInteger" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <link href="login.css" rel="stylesheet">

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
            String AMKA = request.getParameter("AMKA");

            try {
                PASS = MD5_hash(PASS);
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
            }

            String result = makeRequest("http://localhost:8080/Project_war_exploded/rest/services/clientRegister/" + AMKA + "/" + NAME + "/" + PASS + "/" + EMAIL,"POST");

            response.setStatus(response.SC_MOVED_TEMPORARILY);
            switch (result) {
                case "AMKA FORMAT":
                    response.setHeader("Location", "http://localhost:8080/Project_war_exploded/login/register.jsp?alert=Wrong AMKA format (must be 11 numbers)");
                    break;
                case "AMKA EXISTS":
                    response.setHeader("Location", "http://localhost:8080/Project_war_exploded/login/login.jsp?alert=There is account with this AMKA. Try login!");
                    break;
                case "OK":
                    response.setHeader("Location", "http://localhost:8080/Project_war_exploded/login/login.jsp?alert=You can now login!");
                    break;
                default:
                    response.setHeader("Location", "http://localhost:8080/Project_war_exploded/login/register.jsp?alert=Something went wrong with request.");
                    break;
                    }
            }
    %>

</head>
<body>
    <div class="row" style="background-color:#6E8898; min-height:10vh">
        <div class="col-md-4"></div>
        <div class="col-md-4 d-flex align-items-center justify-content-center">
            <h1>Εμβολιασμός COVID-19</h1>
        </div>
    </div>

    <div class="row">
        <div class="col-md-1"></div>
        <div class="col-md-3 d-flex align-items-center justify-content-center">
            <table class="table">
                <tbody>
                  <tr>
                    <td>ΟΝΟΜΑ</td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>ΗΜ/ΝΙΑ ΓΕΝΝΗΣΗΣ</td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>ΤΥΠΟΣ</td>
                    <td></td>
                  </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4 d-flex align-items-center justify-content-center">
            <h2 style="color:#2E5266;"><b>ΕΓΓΡΑΦΗ</b></h2>
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
    <div class="row">
        <div class="col-md-4"></div>
       <div class="col-md-4 d-flex align-items-center justify-content-center">
           <button type="button" class="btn btn-default btn-lg" onclick='window.location.href = "http://localhost:8080/Project_war_exploded/login/login.jsp"'>Είσαι ήδη εγγεγραμμένος;</button>
       </div>
    </div>
    <br><br><br>
</body>

<footer class="footer">
    <h3>Antonisr11</h3>
</footer>

</html>