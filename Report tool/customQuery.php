<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MEB-POC Dashboard - custom query</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
</head>
<body style="background-color: powderblue">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h2>Analytics Database - Report</h2>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <?php
                function FetchRow_CustomAssociate($statement, $metadata_arr) {
                    if(!($row0 = $statement->fetch(PDO::FETCH_NUM))) {
                        return false;
                    }//[null, $metadata_arr];
                    $row = [];

                    if($metadata_arr === null || $metadata_arr === []) {
                        $metadata_arr_assoc = [];
                        $metadata_arr_indexed = [];
                        for ($j=0; true; $j++) {
                            $tmp = $statement->getColumnMeta($j);
                            $table = $tmp['table'];
                            $field = $tmp['name'];
                            if ($table == null) break; //) === null) {$metadata_arr[$j.'=null'] = 'null';};//break;
                            $metadata_arr_assoc[$table . '.' . $field] = ["index" => $j, "table" => $table, "field" => $field];
                            $metadata_arr_indexed[$j] = $field;
                        }
                        $metadata_arr = ['associative'=>$metadata_arr_assoc, 'indexed'=>$metadata_arr_indexed];
                    } else {
                        $metadata_arr_assoc = $metadata_arr['associative']; $metadata_arr_indexed = $metadata_arr['indexed'];
                    }

                    foreach($row0 as $index => $v) {
                        $TableAndColumn = $metadata_arr_indexed[$index];
                        $row[$TableAndColumn] = $v;
                    }

                    return [$row, $metadata_arr];
                }

                if (isset($_POST['queryStr'])) 
                    $sql =$_POST['queryStr'];

                $servername = "localhost";
                $username = "root";
                $password = "root";
                $dbname = "analytics_database";
                $port = "5000";
                $dbh = new PDO("mysql:host=$servername:$port;dbname=$dbname", $username, $password);

                $statement = $dbh->query($sql);
                $row = [];
                $metadata_arr = null;
                $row_str = "";
                $tablestr = "";


                for($i=0; true; $i++){
                    $row = FetchRow_CustomAssociate($statement, $metadata_arr);
                    if($row == false) break;
                    List($row, $metadata_arr) = $row;
                    if($i===0){
                        $row_str.= "<tr style='background-color: lightgray'><th class=\"\"></th>";//angolo top-left
                        foreach ($row as $columnName => $val) { 
                            $row_str.="<th style=\"width: 200px;\">$columnName</th>"; 
                        }
                        $row_str.="</tr>";
                    }
                    $row_str.="<tr><th>" . $i . "</th>";
                    foreach ($row as $columnName => $val) { 
                        $row_str.="<td>$val</td>"; 
                    }
                    $row_str.="</tr>";
                }
                $tablestr = "<table class='table table-bordered' style=\"background-color: white\"><tbody>$row_str</tbody></table>";

                echo "<h4>" . "Results for query <b>\"$sql\"". "</b></h4>";
                echo $tablestr;
                ?>
            </div>
        </div>
    </div>
</body>
</html>
