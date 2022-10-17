package my.restful.web.services;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.util.concurrent.TimeUnit;

@Path("/services")
public class WebServices {

    static private String login_user_AMKA = null;
    static private final DBconnector dBconnector = new DBconnector();

    @GET
    @Path("/getLoginAMKAInfo")
    @Produces(MediaType.TEXT_PLAIN)
    public String getLoginAMKAInfo() throws SQLException {
        User connectedUser = dBconnector.GET_USER(login_user_AMKA);
        if (connectedUser==null){
            System.out.println("User is not login so sending order to logout!");
            return "LOGOUT";
        }
        else {
            return login_user_AMKA+","+connectedUser.getEmail()+","+connectedUser.getName();
        }
    }

    @POST
    @Path("/login/{AMKA}/{PASS}")
    @Produces(MediaType.TEXT_PLAIN)
    public String login(@PathParam("AMKA") String AMKA, @PathParam("PASS") String PASS) throws Exception {
        User connectedUser = dBconnector.GET_USER(AMKA);
        if (connectedUser.getPassword().equals(PASS)) {
            login_user_AMKA = AMKA;
            if (connectedUser.isAdmin()){
                System.out.println("A admin user has just login!");
                return "ADMIN";
            }
            else {
                System.out.println("A simple user has just login with AMKA: "+login_user_AMKA);
                return "SIMPLE";
            }
        } else{
            return "WRONG";
        }
    }

    @POST
    @Path("/clientRegister/{AMKA}/{NAME}/{PASS}/{EMAIL}")
    @Produces(MediaType.TEXT_PLAIN)
    public String clientRegister(@PathParam("AMKA") String AMKA, @PathParam("PASS") String PASS, @PathParam("NAME") String NAME, @PathParam("EMAIL") String EMAIL) throws SQLException {
        User connectedUser = dBconnector.GET_USER(AMKA);
        if (!(AMKA.chars().allMatch(Character::isDigit) && AMKA.length()==11)){
            return "AMKA FORMAT";
        }
        else if (connectedUser != null) {
            return "AMKA EXISTS";
        }
        else{
            dBconnector.INSERT_USER(AMKA,NAME,EMAIL,PASS,Boolean.FALSE);
            return "OK";
        }
    }

    @PUT
    @Path("/changeClient/{NAME}/{PASS}/{EMAIL}")
    @Produces("text/plain")
    public String changeClient(@PathParam("NAME") String NAME, @PathParam("PASS") String PASS, @PathParam("EMAIL") String EMAIL) throws SQLException {
        dBconnector.UPDATE_USER(login_user_AMKA,NAME,PASS,EMAIL);
        return "OK";
    }

    @GET
    @Path("/logout")
    @Produces("text/plain")
    public String logout() {
        login_user_AMKA=null;
        return "OK";
    }

    @GET
    @Path("/takeAppointmentsOfOneUser/")
    @Produces("text/plain")
    public String takeAppointmentsOfUser() throws SQLException {
        return dBconnector.GET_USER_APPOINTMENTS(login_user_AMKA);
    }

    @GET
    @Path("/getAvailableAppointments/")
    @Produces("text/plain")
    public String getAvailableAppointments() throws SQLException {
        return dBconnector.GET_ALL_AVAILABLE_APPOINTMENTS();
    }

    @GET
    @Path("/isAppointmentOK/{DATE}")
    @Produces("text/plain")
    public String isAppointmentOK(@PathParam("DATE") String DATE) throws SQLException {

        String[] options = dBconnector.GET_OPTIONS().split(",");

        int minimun_age = Integer.parseInt(options[0]);
        long maximum_appointments = Integer.parseInt(options[1]);
        long minimum_days = Integer.parseInt(options[2]);
        String[] appointments = dBconnector.GET_USER_APPOINTMENTS(login_user_AMKA).split(",,");

        if (appointments.length >= maximum_appointments){
            // User has reached maximum vaccinations
            return "NO";
        } else if (java.sql.Date.valueOf(DATE).getTime() - java.sql.Date.valueOf(new SimpleDateFormat("yyyy-MM-dd").format(new Date())).getTime()<0){
            // Appointment is older than today
            return "NO";
        } else if (Integer.parseInt(login_user_AMKA.substring(4,6))<Integer.parseInt(new SimpleDateFormat("yy").format(new Date())) &&  Integer.parseInt(login_user_AMKA.substring(4,6))> Integer.parseInt(new SimpleDateFormat("yy").format(new Date())) - minimun_age) {
            // User is too young for vaccination
            return "NO";
        }

        for (String appointment : dBconnector.GET_USER_APPOINTMENTS(login_user_AMKA).split(",,")){
            long day_difference = Math.abs(TimeUnit.DAYS.convert(java.sql.Date.valueOf(DATE).getTime() - java.sql.Date.valueOf(appointment.substring(0,10)).getTime(), TimeUnit.MILLISECONDS));
            if (day_difference<minimum_days){
                return "NO";
            }
        }
        return "YES";
    }

    @POST
    @Path("/insertAppointment/{date}")
    @Produces("text/plain")
    public String insertAppointment(@PathParam("date") String string_date) throws SQLException{
        // In order to generate time for appointment we use a random number generator that goes from 10:00-21:59
        Random randomNum = new Random();
        String minutes = String.valueOf(randomNum.nextInt(60));
        if (minutes.length()==1){
            minutes="0"+minutes;
        }
        dBconnector.INSERT_APPOINTMENT(login_user_AMKA, string_date+" "+ (randomNum.nextInt(12) + 10) +":"+minutes+":00");
        return "OK";
    }

    @DELETE
    @Path("/clientDeleteAppointments/")
    @Produces("text/plain")
    public String clientDeleteAppointments() throws SQLException {
        dBconnector.DELETE_USERS_APPOINTMENTS(login_user_AMKA);
        return "OK";
    }

    // --- ADMIN --- //

    @GET
    @Path("/getAppointmentsView")
    @Produces("text/plain")
    public String getAppointmentsView() throws SQLException {
        return dBconnector.GET_VIEW_OF_ALL_APPOINTMENTS();
    }

    @GET
    @Path("/getAppointmentsInDate/{date}")
    @Produces("text/plain")
    public String getAppointmentsInDate(@PathParam("date") String date) throws SQLException {
        return dBconnector.GET_ALL_APPOINTMENTS_IN_DATE(date);
    }

    @GET
    @Path("/getSystemSettings")
    @Produces("text/plain")
    public String getSystemSettings() throws SQLException {
        return dBconnector.GET_OPTIONS();
    }

    @GET
    @Path("/getAllUsers")
    @Produces("text/plain")
    public String getAllUsers() throws SQLException {
        return dBconnector.GET_ALL_USERS();
    }

    @PUT
    @Path("/changeSystemSettings/{min_years}/{max_vaccines}/{days_for_next_vaccine}")
    @Produces("text/plain")
    public String changeSystemSettings(@PathParam("min_years") String YEARS, @PathParam("max_vaccines") String VACCINES, @PathParam("days_for_next_vaccine") String DAYS) throws SQLException {
        //Change settings in database
        dBconnector.CHANGE_OPTIONS(Integer.parseInt(YEARS),Integer.parseInt(VACCINES),Integer.parseInt(DAYS));
        return "OK";
    }

    @POST
    @Path("/addVaccines/{date}/{vaccines}")
    @Produces("text/plain")
    public String addVaccines(@PathParam("date") String DATE, @PathParam("vaccines") String VACCINES) throws SQLException {
        dBconnector.INSERT_AVAILABLE_VACCINES(DATE,Integer.parseInt(VACCINES));
        return "OK";
    }

    @POST
    @Path("/adminRegister/{NAME}/{PASS}/{EMAIL}/{AMKA}")
    @Produces(MediaType.TEXT_PLAIN)
    public String adminRegister(@PathParam("AMKA") String AMKA, @PathParam("PASS") String PASS, @PathParam("NAME") String NAME, @PathParam("EMAIL") String EMAIL) throws SQLException {
        if (!(AMKA.chars().allMatch(Character::isDigit) && AMKA.length()==11)){
            return "AMKA FORMAT";
        }

        User user = dBconnector.GET_USER(AMKA);
        if (user!=null){
            return "AMKA EXISTS";
        }
        dBconnector.INSERT_USER(AMKA,NAME,EMAIL,PASS,Boolean.TRUE);
        return "OK";
    }

    @PUT
    @Path("/completeVaccinationByID/{ID}")
    @Produces("text/plain")
    public String completeVaccinationByID(@PathParam("ID") String ID) throws SQLException {
        dBconnector.COMPLETE_APPOINTMENT_BY_ID(ID);
        return "OK";
    }

    @PUT
    @Path("/completeAllVaccinationsByDATE/{DATE}")
    @Produces("text/plain")
    public String completeAllVaccinationsByDATE(@PathParam("DATE") String DATE) throws SQLException {
        dBconnector.COMPLETE_APPOINTMENT_BY_DATE(DATE);
        return "OK";
    }

    @DELETE
    @Path("/cancelAppointmentByID/{ID}")
    @Produces("text/plain")
    public String cancelAppointmentByID(@PathParam("ID") String ID) throws SQLException {
        dBconnector.DELETE_APPOINTMENT_BY_ID(ID);
        return "OK";
    }

    @DELETE
    @Path("/cancelAllAppointmentsByDATE/{DATE}")
    @Produces("text/plain")
    public String cancelAllAppointmentsByDATE(@PathParam("DATE") String DATE) throws SQLException {
        dBconnector.DELETE_APPOINTMENT_BY_DATE(DATE);
        return "OK";
    }
}