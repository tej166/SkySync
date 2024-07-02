package com.servlets;

import org.json.JSONObject;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;


@WebServlet(name = "WeatherServlet", urlPatterns = {"/weather"})
public class Home extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String API_KEY = "c47b75707278e2a12815a0df17eff8ff";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
        
        String username = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    username = cookie.getValue();
                    break;
                }
            }
        }
        
        String latitude = request.getParameter("latitude");
        String longitude = request.getParameter("longitude");
        String place = request.getParameter("place");
        String year = request.getParameter("year");

        String apiUrl = "";

        // Check if year is provided and call the appropriate API endpoint
        if (year != null && !year.isEmpty()) {
            apiUrl = "https://history.openweathermap.org/data/2.5/aggregated/year?lat=" + latitude + "&lon=" + longitude + "&appid=" + API_KEY + "&year=" + year;
        } else if (latitude != null && longitude != null && !latitude.isEmpty() && !longitude.isEmpty()) {
            apiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=" + latitude + "&lon=" + longitude + "&appid=" + API_KEY + "&units=metric";
            
        } else if (place != null && !place.isEmpty()) {
            String encodedPlace = URLEncoder.encode(place, "UTF-8");
            apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + encodedPlace + "&appid=" + API_KEY + "&units=metric";
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("Invalid input");
            return;
        }

        try {
            PrintWriter out = response.getWriter();
            URL url = new URL(apiUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            int status = connection.getResponseCode();

            if (status != HttpURLConnection.HTTP_OK) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("Error: Failed to fetch data from API. HTTP status code: " + status);
                return;
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder responseContent = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                responseContent.append(line);
            }
            reader.close();

            JSONObject jsonObject = new JSONObject(responseContent.toString());

            if (year != null && !year.isEmpty()) {
                // Process yearly aggregated data response
                double averageTemperature = jsonObject.getJSONObject("temp").getDouble("mean");

                // Respond with the average temperature for the year
                response.setContentType("text/html");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().print("<html><body>");
                response.getWriter().print("<h2>Average Temperature for " + year + ":</h2>");
                response.getWriter().print("<p>Average Temperature: " + averageTemperature + "°C</p>");
                response.getWriter().print("</body></html>");
            } else {
                // Process current weather data response
                double currentTemperature = jsonObject.getJSONObject("main").getDouble("temp");
                String cityName = jsonObject.getString("name");
                double cityLatitude = jsonObject.getJSONObject("coord").getDouble("lat");
                double cityLongitude = jsonObject.getJSONObject("coord").getDouble("lon");

                // Respond with current weather information
                response.setContentType("text/html");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().print("<html><body>");
                response.getWriter().print("<h2>Current Weather Information:</h2>");
                response.getWriter().print("<p>Temperature: " + currentTemperature + "°C</p>");
                response.getWriter().print("<p>Place: " + cityName + "</p>");
                response.getWriter().print("<p>Latitude: " + cityLatitude + "</p>");
                response.getWriter().print("<p>Longitude: " + cityLongitude + "</p>");
                response.getWriter().print("</body></html>");
            }
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("Error fetching weather data: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("Unexpected error: " + e.getMessage());
        }
    }
}
