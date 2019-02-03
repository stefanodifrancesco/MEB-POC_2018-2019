<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>example-aggregate-functions-and-grouping-count-with-group-by- php mysql examples | w3resource</title>
    <meta name="description" content="example-aggregate-functions-and-grouping-count-with-group-by- php mysql examples | w3resource">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
</head>
<meta http-equiv="refresh" content="5" >
<body style="background-color: powderblue">
<?php
function FetchRow_CustomAssociate($statement, $metadata_arr){
    if(!($row0 = $statement->fetch(PDO::FETCH_NUM))){return false;}//[null, $metadata_arr];
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
            $metadata_arr_indexed[$j] = $table . '.' . $field;
        }
        $metadata_arr = ['associative'=>$metadata_arr_assoc, 'indexed'=>$metadata_arr_indexed];
    }else {$metadata_arr_assoc = $metadata_arr['associative']; $metadata_arr_indexed = $metadata_arr['indexed'];}

    foreach($row0 as $index => $v){
        $TableAndColumn = $metadata_arr_indexed[$index];
        $row[$TableAndColumn] = $v;}

    return [$row, $metadata_arr];}
//var_dump($_POST);
if(isset($_POST['queryStr'])) $sql = $_POST['queryStr']; else {
    echo
        '<form action="/customQuery.php" method="post">'.
            'Query:<br>'.
            '<input style="width:calc(100vw - 16px)" type="text" name="queryStr" value="SELECT COUNT(*) FROM analytics_database.aggregateddata WHERE (TIMESTAMPDIFF(MINUTE, HoldEndDateTime, NOW()) <= 30)">'.
            '<br><br>'.
            '<input type="submit" value="Submit">'.
        '</form>';
    return;}

$servername = "localhost";
$username = "root";
$password = "root";
$dbname = "analytics_database";
$port = "5000";
$pdo = new PDO("mysql:host=$servername:$port;dbname=$dbname", $username, $password);

$statement = $pdo->query($sql);
$row = [];
$metadata_arr = null;
$row_str = "";
$tablestr = "";


for($i=0; true; $i++){
    $row = FetchRow_CustomAssociate($statement, $metadata_arr);
    if($row == false) break;
    List($row, $metadata_arr) = $row;
    if($i===0){
        $row_str.= "<tr><th class=\"\"></th>";//angolo top-left
        foreach ($row as $columnName => $val) { $row_str.="<th>$columnName</th>"; }
        $row_str.="</tr>";
    }
    $row_str.="<tr><th>$i)</th>";
    foreach ($row as $columnName => $val) { $row_str.="<td>$val</td>"; }
    $row_str.="</tr>";
}
$tablestr = "<table><tbody>$row_str</tbody></table>";

echo "Result for query \"$sql\"";
echo $tablestr;
?>
</body>
</html>
