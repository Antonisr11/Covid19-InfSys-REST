package my.restful.web.services;

import java.sql.*;

public class DBconnector{

    private Connection connector = null;

    public DBconnector() {
            try{
                String driverName = "com.mysql.jdbc.Driver";
                Class.forName(driverName);

                String url = "jdbc:mysql://localhost:3306/vaccine";

                String username = "root";
                String password = "root";
                connector = DriverManager.getConnection(url, username, password);
            }
            catch (Exception e){
                e.printStackTrace();
            }
    }

    public void INSERT_USER(String AMKA, String name, String email, String password, Boolean isAdmin) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("INSERT INTO vaccine.users (AMKA, Name, Email, Password, isAdmin) VALUES (?,?,?,?,?)");
        ps.setString(1, AMKA);
        ps.setString(2, name);
        ps.setString(3, email);
        ps.setString(4, password);
        ps.setString(5, isAdmin ? "1":"0");
        ps.executeUpdate();
        ps.close();
    }

    public User GET_USER(String AMKA) throws SQLException {
        if (AMKA==null){
            return null;
        }
        PreparedStatement ps = connector.prepareStatement("SELECT * FROM vaccine.users WHERE AMKA = ?");
        ps.setString(1, AMKA);
        ResultSet rs = ps.executeQuery();
        if (rs.next()){
            return new User(rs.getString("AMKA"),rs.getString("Name"),rs.getString("Password"),rs.getString("Email"), rs.getString("isAdmin").equals("0") ? Boolean.FALSE:Boolean.TRUE);
        }
        return null;
    }

    public void UPDATE_USER(String AMKA, String name, String pass, String email) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("UPDATE vaccine.users SET vaccine.users.Name = ?, vaccine.users.Email = ?, vaccine.users.Password = ? WHERE (vaccine.users.AMKA = ?)");
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, pass);
        ps.setString(4, AMKA);
        ps.executeUpdate();
        ps.close();
    }

    public String GET_ALL_USERS() throws SQLException {
        ResultSet rs = connector.prepareStatement("SELECT * FROM vaccine.users ORDER BY isAdmin DESC").executeQuery();
        StringBuilder result = new StringBuilder();
        while (rs.next()){
            result.append(rs.getString("Name")).append(",").append(rs.getString("AMKA")).append(",").append(rs.getString("Email")).append(",").append(rs.getString("isAdmin")).append(",,");
        }
        return result.toString();
    }

    public String GET_USER_APPOINTMENTS(String AMKA) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("SELECT * FROM vaccine.appointments WHERE AMKA = ? ORDER BY vaccine.appointments.Date");
        ps.setString(1, AMKA);
        ResultSet rs = ps.executeQuery();
        StringBuilder result = new StringBuilder();
        while (rs.next()){
            result.append(rs.getString("Date"), 0, 10).append(",").append(rs.getString("Date"), 11, 16).append(",").append(rs.getString("isDone").equals("0")?"OXI":"NAI").append(",,");
        }
        return result.toString();
    }

    public void DELETE_USERS_APPOINTMENTS(String AMKA) throws SQLException {
        for (String appointment : GET_USER_APPOINTMENTS(AMKA).split(",,")){
            if (appointment.substring(17).equals("OXI")){
                INSERT_AVAILABLE_VACCINES(appointment.substring(0,10),1);
            }
        }

        PreparedStatement ps = connector.prepareStatement("DELETE FROM vaccine.appointments WHERE (vaccine.appointments.AMKA = ? AND vaccine.appointments.isDone = ?)");
        ps.setString(1, AMKA);
        ps.setString(2, "0");
        ps.executeUpdate();
        ps.close();
    }

    public void DELETE_APPOINTMENT_BY_ID(String ID) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("UPDATE vaccine.availablevaccines SET vaccine.availablevaccines.count = vaccine.availablevaccines.count+1 WHERE vaccine.availablevaccines.date = ( SELECT substring(vaccine.appointments.Date,1,10) as date FROM vaccine.appointments WHERE vaccine.appointments.ID = ?)");
        ps.setInt(1, Integer.parseInt(ID));
        ps.executeUpdate();
        ps.close();


        ps = connector.prepareStatement("DELETE FROM vaccine.appointments WHERE vaccine.appointments.ID = ?");
        ps.setInt(1, Integer.parseInt(ID));
        ps.executeUpdate();
        ps.close();
    }

    public void DELETE_APPOINTMENT_BY_DATE(String DATE) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("SELECT COUNT(*) AS count FROM vaccine.appointments WHERE substring(vaccine.appointments.Date,1,10) = ?");
        ps.setDate(1, java.sql.Date.valueOf(DATE));
        ResultSet rs = ps.executeQuery();
        int count=0;
        if (rs.next()){
            count = Integer.parseInt(rs.getString("count"));
        }
        INSERT_AVAILABLE_VACCINES(DATE,count);

        ps = connector.prepareStatement("DELETE FROM vaccine.appointments WHERE substring(vaccine.appointments.Date,1,10) = ?");
        ps.setDate(1, java.sql.Date.valueOf(DATE));
        ps.executeUpdate();
        ps.close();
    }

    public void COMPLETE_APPOINTMENT_BY_ID(String ID) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("UPDATE vaccine.appointments SET vaccine.appointments.isDone = '1' WHERE vaccine.appointments.ID = ?");
        ps.setString(1, ID);
        ps.executeUpdate();
        ps.close();
    }

    public void COMPLETE_APPOINTMENT_BY_DATE(String DATE) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("UPDATE vaccine.appointments SET vaccine.appointments.isDone = '1' WHERE substring(vaccine.appointments.Date,1,10) = ?");
        ps.setDate(1, java.sql.Date.valueOf(DATE));
        ps.executeUpdate();
        ps.close();
    }

    public String GET_OPTIONS() throws SQLException {
        ResultSet rs = connector.prepareStatement("SELECT * FROM vaccine.settings").executeQuery();
        String result = null;
        while (rs.next()){
            result=rs.getString("minimum_age")+","+rs.getString("max_doses")+","+rs.getString("minimum_days_between_vaccinations");
        }

        if (result==null){
            //There are no options, so loading defaults
            CHANGE_OPTIONS(18,3,28);
            return "18,3,28";
        }
        return result;
    }

    public void CHANGE_OPTIONS(int minimum_age, int max_doses, int minimum_days_between_vaccinations) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("INSERT INTO vaccine.settings (ID, minimum_age, max_doses, minimum_days_between_vaccinations) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE minimum_age = ?, max_doses = ?, minimum_days_between_vaccinations = ?");
        ps.setInt(1, 0);
        ps.setInt(2, minimum_age);
        ps.setInt(3, max_doses);
        ps.setInt(4, minimum_days_between_vaccinations);
        ps.setInt(5, minimum_age);
        ps.setInt(6, max_doses);
        ps.setInt(7, minimum_days_between_vaccinations);
        ps.executeUpdate();
        ps.close();
    }


    public void INSERT_AVAILABLE_VACCINES(String string_date, int count) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("INSERT INTO vaccine.availablevaccines (vaccine.availablevaccines.date, vaccine.availablevaccines.count) VALUES (?, ?) ON DUPLICATE KEY UPDATE vaccine.availablevaccines.count=vaccine.availablevaccines.count+?");
        ps.setDate(1, java.sql.Date.valueOf(string_date));
        ps.setInt(2, count);
        ps.setInt(3, count);
        ps.executeUpdate();
        ps.close();
    }

    public void INSERT_APPOINTMENT(String AMKA, String date) throws SQLException{
        //We have to generate ID
        PreparedStatement ps = connector.prepareStatement("SELECT MAX(vaccine.appointments.ID) AS MAX_ID FROM vaccine.appointments;");
        ResultSet rs = ps.executeQuery();
        int ID=-1;
        if (rs.next()){
            ID = rs.getInt("MAX_ID");
        }
        ID++;
        //ID generated, go for insert
        //Before insert we have to reduce available vaccines
        ps = connector.prepareStatement("UPDATE vaccine.availablevaccines SET vaccine.availablevaccines.count=vaccine.availablevaccines.count-1 WHERE vaccine.availablevaccines.date=?");
        ps.setString(1, date.substring(0,10));
        ps.executeUpdate();
        ps.close();

        //Now it is time for insert
        ps = connector.prepareStatement("INSERT INTO appointments (ID, AMKA, Date, isDone) VALUES (?,?,?,?)");
        ps.setInt(1, ID);
        ps.setString(2, AMKA);
        ps.setString(3, date);
        ps.setString(4, "0");
        ps.executeUpdate();
        ps.close();
    }

    public String GET_ALL_AVAILABLE_APPOINTMENTS() throws SQLException {
        ResultSet rs = connector.prepareStatement("SELECT * FROM vaccine.availablevaccines ORDER BY vaccine.availablevaccines.date").executeQuery();
        StringBuilder result = new StringBuilder();
        while (rs.next()){
            result.append(rs.getString("date")).append(",").append(rs.getString("count")).append(",,");
        }
        return result.toString();
    }

    public String GET_VIEW_OF_ALL_APPOINTMENTS() throws SQLException {
        ResultSet rs = connector.prepareStatement("WITH A1 AS (SELECT COUNT(AMKA) AS closed_appointments, substring(vaccine.appointments.Date,1,10) AS date_of_closed  FROM vaccine.appointments  GROUP BY substring(vaccine.appointments.Date,1,10) )  SELECT COALESCE(date ,date_of_closed) AS Date, COALESCE(count, '0') AS Remaining, COALESCE(closed_appointments, '0') as Closed FROM (  SELECT * FROM vaccine.availablevaccines  LEFT JOIN A1 ON A1.date_of_closed = vaccine.availablevaccines.date  UNION  SELECT * FROM vaccine.availablevaccines  RIGHT JOIN A1 ON A1.date_of_closed = vaccine.availablevaccines.date  GROUP BY date ) AS T ORDER BY date ASC").executeQuery();
        StringBuilder result = new StringBuilder();
        while (rs.next()){
            result.append(rs.getString("Date")).append(",").append(rs.getString("Remaining")).append(",").append(rs.getString("Closed")).append(",,");
        }
        return result.toString();
    }

    public String GET_ALL_APPOINTMENTS_IN_DATE(String date) throws SQLException {
        PreparedStatement ps = connector.prepareStatement("SELECT Name, substring(Date,12,5) AS Time, isDone, vaccine.users.AMKA AS AMKA, ID FROM vaccine.appointments JOIN vaccine.users ON vaccine.appointments.AMKA=vaccine.users.AMKA WHERE substring(Date,1,10)=? ORDER BY Time ASC");
        ps.setString(1, date);
        ResultSet rs = ps.executeQuery();
        StringBuilder result = new StringBuilder();
        while (rs.next()){
            result.append(rs.getString("Name")).append(",").append(rs.getString("Time")).append(",").append(rs.getString("isDone").equals("0")?"OXI":"NAI").append(",").append(rs.getString("ID")).append(",,");
        }
        return result.toString();
    }
}
