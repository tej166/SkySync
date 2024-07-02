<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>SkySync Weather</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            background-color: #F8F9FA;
            font-family: 'Arial', sans-serif;
        }
        .navbar {
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .card {
            background: white;
            color: black;
            margin-top: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        .card-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: #6A11CB;
        }
        .card-text {
            font-size: 1.2rem;
        }
        .form-control {
            border-radius: 20px;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        .btn-primary {
            border-radius: 20px;
            background-color: #6A11CB;
            border: none;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .btn-primary:hover {
            background-color: #2575FC;
        }
        .form-container {
            padding: 20px 40px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .add-card-btn {
            background-color: #28a745;
            color: white;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            font-size: 24px;
            border: none;
            position: fixed;
            bottom: 20px;
            right: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #6A11CB;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="#">SkySync Weather</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Sign Out</a>
                </li>
            </ul>
        </div>
    </nav>
    <div class="container">
        <div class="row">
            <div class="col-md-6 form-container">
                <div class="card">
                    <h2>Search by Coordinates</h2>
                    <form id="coordinatesForm">
                        <div class="form-group">
<!--                            <label for="latitude">Latitude:</label>-->
                            <input type="text" class="form-control" id="latitude" name="latitude" placeholder="Enter latitude">
                        </div>
                        <div class="form-group">
<!--                            <label for="longitude">Longitude:</label>-->
                            <input type="text" class="form-control" id="longitude" name="longitude" placeholder="Enter longitude">
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Search</button>
                    </form>
                </div>
            </div>
            <div class="col-md-6 form-container">
                <div class="card">
                    <h2>Search by Place</h2>
                    <form id="placeForm">
                        <div class="form-group">
<!--                            <label for="place">Place:</label>-->
                            <input type="text" class="form-control" id="place" name="place" placeholder="Enter place">
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Search</button>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Yearly Average Temperature Calculation Form -->
        <div class="row">
            <div class="col-md-6 form-container">
                <div class="card">
                    <h2>Calculate Average Temperature for a Year</h2>
                    <form id="yearForm">
                        <div class="form-group">
<!--                            <label for="year">Year:</label>-->
                            <input type="number" class="form-control" id="year" name="year" placeholder="Enter year">
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Calculate</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Weather Result Section -->
        <div id="weatherResult" class="mt-4">
            <!-- Result will be dynamically updated here -->
        </div>
        
        <!-- Additional weather results section -->
        <div id="additionalWeatherResults" class="mt-4">
            <h2>Pinned Places</h2>
            <!-- Additional weather results will be appended here -->
        </div>
    </div>

    <!-- Button to Add Weather Results Card -->
    <button id="addCardBtn" class="add-card-btn">+</button>

    <!-- JavaScript for AJAX and UI Interactions -->
    <script>
        let weatherDataArray = [];

        $(document).ready(function() {
            $('#coordinatesForm').submit(function(event) {
                event.preventDefault();
                $.ajax({
                    type: 'POST',
                    url: 'weather',
                    data: $(this).serialize(),
                    success: function(response) {
                        let weatherData;
                        weatherData = JSON.parse(response);
                        weatherDataArray.push(weatherData);
                        $('#weatherResult').html('<div class="card"><div class="card-body">' + response + '</div></div>');
                    },
                    error: function() {
                        $('#weatherResult').html('<p>Invalid Input</p>');
                    }
                });
            });

            $('#placeForm').submit(function(event) {
                event.preventDefault();
                $.ajax({
                    type: 'POST',
                    url: 'weather',
                    data: $(this).serialize(),
                    success: function(response) {
                        weatherDataArray.push(response);
                        $('#weatherResult').html('<div class="card"><div class="card-body">' + response + '</div></div>');
                    },
                    error: function() {
                        $('#weatherResult').html('<p>Invalid Input</p>');
                    }
                });
            });

            $('#yearForm').submit(function(event) {
                event.preventDefault();
                $.ajax({
                    type: 'POST',
                    url: 'weather',
                    data: $(this).serialize(),
                    success: function(response) {
                        $('#weatherResult').html('<div class="card"><div class="card-body">' + response + '</div></div>');
                    },
                    error: function() {
                        $('#weatherResult').html('<p>Invalid Input</p>');
                    }
                });
            });

//            $('#addCardBtn').click(function() {
//                if (weatherDataArray.length > 0) {
//                    let latestWeatherData = weatherDataArray[weatherDataArray.length - 1];
//                    $('#additionalWeatherResults').append('<div class="card"><div class="card-body">' + latestWeatherData + '</div></div>');
//                }
//            });

        $('#addCardBtn').click(function() {
            if (weatherDataArray.length > 0) {
                let latestWeatherData = weatherDataArray[weatherDataArray.length - 1];
                // Fetch username from cookie
                let userName = getCookie('username'); // Replace 'username' with your cookie name
                let tempDiv = document.createElement('div');
                tempDiv.innerHTML = latestWeatherData;
                let place = extractValue(latestWeatherData, "Place");
                let latitudeStr = extractValue(latestWeatherData, "Latitude");
                let longitudeStr = extractValue(latestWeatherData, "Longitude");
                let temperatureStr = extractValue(latestWeatherData, "Temperature");
                let latitude = parseFloat(latitudeStr);
                let longitude = parseFloat(longitudeStr);
                let temperature = parseFloat(temperatureStr.replace("°C", ""));
                $.ajax({
                    type: 'POST',
                    url: 'addWeatherInfo', // Servlet URL for adding weather info
                    data: {
                        place: place,
                        latitude: latitude,
                        longitude: longitude,
                        temperature: temperature,
                        userName: userName // Include username in the data sent to servlet
                    },
                    success: function(response) {
                        // Optionally handle success response
                    },
                    error: function() {
                        console.error('Error adding weather info');
                    }
                });
                $('#additionalWeatherResults').append('<div class="card"><div class="card-body">' + latestWeatherData + '</div></div>');
            }
        });
        function extractValue(html, label) {
            let pattern = new RegExp("<p>" + label + ":\\s*([^<]+)</p>");
            let match = html.match(pattern);
            if (match) {
                return match[1].trim();
            }
            return "";
        }
        // Function to get cookie value by name
        function getCookie(name) {
            const cookieName = name + '=';
            const decodedCookie = decodeURIComponent(document.cookie);
            const cookieArray = decodedCookie.split(';');
            for (let i = 0; i < cookieArray.length; i++) {
                let cookie = cookieArray[i];
                while (cookie.charAt(0) === ' ') {
                    cookie = cookie.substring(1);
                }
                if (cookie.indexOf(cookieName) === 0) {
                    return cookie.substring(cookieName.length, cookie.length);
                }
            }
            return '';
        }

                });


            </script>
        </body>
</html>
