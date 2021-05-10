<!-- Returns number of films an director made per year -->
<?php

//Open a connection to dbase server
include 'open.php';

//Construct an array in which we'll store our data
$dataPoints = array();

//Prepare a statement to be executed later
if ($stmt = $conn->prepare("CALL ProductionsPerYear(?)")) {
    //Bind a variable to the missing data value denoted by ? above
    $stmt->bind_param("s", $Name);
        
    //Set the value of the bound variable
    $Name = $_POST['Name'];
    
    //Execute the statement on dbase
    if (!empty($Name)) {
   	    if ($stmt->execute()) {

      	    //Store result set generated by the prepared statement
      	    $result = $stmt->get_result();

	        if ($result->num_rows == 0) {
			    echo "No year information found for this director.<br>";
		    // otherwise, report results
		    } else {
      	        //Get each row of result set and push it into array
        	    foreach($result as $row) {
         	        array_push($dataPoints, array( "label"=> $row["year"],
                    "y"=> $row["COUNT(year)"]));
                }
            }
	    //Free the result set returned from the query, since we've stored data in array
        $result->free_result();
        } else {
		echo "Please make sure your input is valid.";
	}
    } else {
	    echo "Please input a director.";
    }
}

//Close the prepared statement
$stmt->close();

//Close the connection opened by open.php since we no longer need access to dbase
$conn->close();
?>
	<html>

	<head>
		<script type="text/javascript">
		window.onload = function() {
			var chart = new CanvasJS.Chart("chartContainer", {
				animationEnabled: true,
				theme: "dark1", // "light1", "light2", "dark1", "dark2"
				title: {
					text: "Films Per Year"
				},
				axisY: {
					title: "Films"
				},
				axisX: {
				        interval: 1,
					title: "Year"
				},
				data: [{
					type: "column",
					//json_encode function called below transforms numeric strings into numbers
					dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
				}]
			});
			chart.render();
		}
		</script>
	</head>

	<body>
		<div id="chartContainer" style="height: 300px; width: 100%;"></div>
		<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
	</body>

	</html>
