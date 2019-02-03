<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MEB-POC Dashboard</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <meta http-equiv="refresh" content="5" >
</head>
<?php
	$servername = "localhost";
	$username = "root";
	$password = "root";
	$dbname = "analytics_database";
	$port = "5000";
	$dbh = new PDO("mysql:host=$servername:$port;dbname=$dbname", $username, $password);
?>
<body style="background-color: powderblue">
	<div class="container">
		<div class="row">
			<div class="col-md-6">
				<h2>Analytics Database - Report</h2>
					<?php
					$row = $dbh->query('SELECT COUNT(*) FROM analytics_database.aggregateddata WHERE (TIMESTAMPDIFF(MINUTE, HoldEndDateTime, NOW()) <= 30)')->fetch();
					echo "<h4>" . $row['COUNT(*)'] . " messages stored, in the last 30 minutes</h4>";
					?>
			</div>			
		</div>
		<div class="row">
			<div class="col-md-12">
				<h4 style="font-weight: bold">Five history greater hold times</h4>
				<table class='table table-bordered' style="background-color: white">
				<tr style="background-color: lightgray">
				<th>Hold time</th><th>Hold type</th><th>Recipe name</th><th>Tool name</th>
				</tr>
				<?php
					foreach($dbh->query('SELECT CONCAT(
							TIMESTAMPDIFF( DAY, HoldStartDateTime, HoldEndDateTime) , \' days \',
							MOD( TIMESTAMPDIFF( HOUR, HoldStartDateTime, HoldEndDateTime), 24), \' hours \',
							MOD( TIMESTAMPDIFF( MINUTE, HoldStartDateTime, HoldEndDateTime), 60), \' minutes \',
							MOD( TIMESTAMPDIFF( SECOND, HoldStartDateTime, HoldEndDateTime), 60), \' seconds \'
						) as dif, HoldType, RecipeName, EquipName
						FROM analytics_database.aggregateddata 
						ORDER BY TIMESTAMPDIFF( MICROSECOND, HoldStartDateTime, HoldEndDateTime) 
						DESC
						LIMIT 5') as $row) {
						echo "<tr>";
						echo "<td>" . $row['dif'] . "</td>";
						echo "<td>" . $row['HoldType'] . "</td>";
						echo "<td>" . $row['RecipeName'] . "</td>";
						echo "<td>" . $row['EquipName'] . "</td>";
						echo "</tr>"; 
					}
				?>
				</tbody></table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6">
				<h4 style="font-weight: bold">Five category of tools that has been on hold more times</h4>
				<table class='table table-bordered' style="background-color: white">
				<tr style="background-color: lightgray">
				<th>Tool name</th><th>Number of holds</th>
				</tr>
				<?php
					foreach($dbh->query('SELECT EquipName,COUNT(*)
					FROM analytics_database.aggregateddata
					GROUP BY EquipName
					order by count(*) DESC
					LIMIT 5') as $row) {
						echo "<tr>";
						echo "<td>" . $row['EquipName'] . "</td>";
						echo "<td>" . $row['COUNT(*)'] . "</td>";
						echo "</tr>"; 
					}
				?>
				</tbody></table>
			</div>
			<div class="col-md-6">
				<h4 style="font-weight: bold">Five type of holds that has been on hold more times</h4>
				<table class='table table-bordered' style="background-color: white">
				<tr style="background-color: lightgray">
				<th>Type of hold</th><th>Number of holds</th>
				</tr>
				<?php
					foreach($dbh->query('SELECT HoldType,COUNT(*)
					FROM analytics_database.aggregateddata
					GROUP BY HoldType
					order by count(*) DESC
					LIMIT 5') as $row) {
						echo "<tr>";
						echo "<td>" . $row['HoldType'] . "</td>";
						echo "<td>" . $row['COUNT(*)'] . "</td>";
						echo "</tr>"; 
					}
				?>
				</tbody></table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6">
				<h4 style="font-weight: bold">Five category of recipes that has been on hold more times</h4>
				<table class='table table-bordered' style="background-color: white">
				<tr style="background-color: lightgray">
				<th>Recipe name</th><th>Number of holds</th>
				</tr>
				<?php
					foreach($dbh->query('SELECT RecipeName,COUNT(*)
					FROM analytics_database.aggregateddata
					GROUP BY RecipeName
					order by count(*) DESC
					LIMIT 5') as $row) {
						echo "<tr>";
						echo "<td>" . $row['RecipeName'] . "</td>";
						echo "<td>" . $row['COUNT(*)'] . "</td>";
						echo "</tr>"; 
					}
				?>
				</tbody></table>
			</div>
		</div>
	</div>
</body>
</html>