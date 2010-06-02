<?php
/**
 * Script to correct the encoding issue of eventum 858
 * FM L'Heureux
 * 2010-04-15
 */
$host = "localhost:8889";
$user = "root";
$pwd = "root";
$ignore_tables = array("acos", "aros", "acos_aros", "i18n", "key_increments",
	"structure_fields", "structure_formats", "structures", "structure_permissible_values", "structure_validations",
	"structure_value_domains", "structure_value_domains_permissible_values",
	"view_aliquots", "view_collections", "view_samples");

echo ("Enter the name of the schema to fix: ");
$schema = trim(fgets(STDIN));
if(strtolower($schema) == "information_schema" || strtolower($schema) == "mysql"){
	die("Denied: Will not fix this schema.\n");
}
$mysqli = mysqli_init();
$mysqli_iso = mysqli_init();
$mysqli_utf = mysqli_init();
if (!$mysqli_iso || !$mysqli_utf) {
    die('mysqli_init failed');
}

if (!$mysqli->real_connect($host, $user, $pwd, $schema)) {
    die('Connect Error (' . mysqli_connect_errno() . ') '
            . mysqli_connect_error());
}

if (!$mysqli_iso->real_connect($host, $user, $pwd, $schema)) {
    die('Connect Error (' . mysqli_connect_errno() . ') '
            . mysqli_connect_error());
}
if($mysqli_iso->get_charset()->charset == "utf8"){
	die("Your default charset is already utf8. You may not need to run this script. Otherwise comment line 26 and set the proper charset on line 27");
	$mysqli_iso->set_charset("utf8") or die("failed to set charset 1");
}
if (!$mysqli_utf->real_connect($host, $user, $pwd, $schema)) {
    die('Connect Error (' . mysqli_connect_errno() . ') '
            . mysqli_connect_error());
}
$mysqli_utf->set_charset("utf8") or die("failed to set charset 2");
$mysqli_utf->autocommit(false);

$query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='".$schema."'";
$result = $mysqli->query($query) or die("Query failed");

$tables = array();
echo("Retrieving tables: ");
while($row = $result->fetch_row()){
	$tables[] = $row[0];
}
$result->close();

$tables = array_diff($tables, $ignore_tables);
echo("retreived ".sizeof($tables)."\n");
foreach($tables as $table){
	$result = $mysqli->query("DESC ".$table);
	$fields = array();
	while($row = $result->fetch_assoc()){
		if(strpos($row['Type'], "char") !== false || strpos($row['Type'], "text") !== false){
			$fields[] = $row['Field'];
		}
	}
	$result->close();
	if(sizeof($fields) > 0){
		$query_iso = "SELECT `".implode("`, `", $fields)."`, id FROM ".$table;
		$result_iso = $mysqli_iso->query($query_iso) or die($mysqli_iso->error."  query iso failed $query_iso\n");
		$update_query = "UPDATE ".$table." SET `".implode("`=?, `", $fields)."`=? WHERE id=?";
		$stmt = $mysqli_utf->prepare($update_query);
		echo($update_query."\n");
		//this is dumb, but it's mysqli fault!
		while($row_iso = $result_iso->fetch_row()){
			if(sizeof($fields) == 1){
				$stmt->bind_param("ss", $row_iso[0], $row_iso[1]);
			}else if(sizeof($fields) == 2){
				$stmt->bind_param("sss", $row_iso[0], $row_iso[1], $row_iso[2]);
			}else if(sizeof($fields) == 3){
				$stmt->bind_param("ssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3]);
			}else if(sizeof($fields) == 4){
				$stmt->bind_param("sssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4]);
			}else if(sizeof($fields) == 5){
				$stmt->bind_param("ssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5]);
			}else if(sizeof($fields) == 6){
				$stmt->bind_param("sssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6]);
			}else if(sizeof($fields) == 7){
				$stmt->bind_param("ssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7]);
			}else if(sizeof($fields) == 8){
				$stmt->bind_param("sssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8]);
			}else if(sizeof($fields) == 9){
				$stmt->bind_param("ssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9]);
			}else if(sizeof($fields) == 10){
				$stmt->bind_param("sssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9], $row_iso[10]);
			}else if(sizeof($fields) == 11){
				$stmt->bind_param("ssssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9], $row_iso[10], $row_iso[11]);
			}else if(sizeof($fields) == 12){
				$stmt->bind_param("sssssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9], $row_iso[10], $row_iso[11], $row_iso[12]);
			}else if(sizeof($fields) == 13){
				$stmt->bind_param("ssssssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9], $row_iso[10], $row_iso[11], $row_iso[12], $row_iso[13]);
			}else if(sizeof($fields) == 16){
				$stmt->bind_param("sssssssssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9], $row_iso[10], $row_iso[11], $row_iso[12], $row_iso[13], $row_iso[14], $row_iso[15], $row_iso[16]);
			}else if(sizeof($fields) == 18){
				$stmt->bind_param("sssssssssssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9], $row_iso[10], $row_iso[11], $row_iso[12], $row_iso[13], $row_iso[14], $row_iso[15], $row_iso[16], $row_iso[17], $row_iso[18]);
			}else if(sizeof($fields) == 33){
				$stmt->bind_param("ssssssssssssssssssssssssssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9], $row_iso[10], $row_iso[11], $row_iso[12], $row_iso[13], $row_iso[14], $row_iso[15], $row_iso[16], $row_iso[17], $row_iso[18], $row_iso[19], $row_iso[20], $row_iso[21], $row_iso[22], $row_iso[23], $row_iso[24], $row_iso[25], $row_iso[26], $row_iso[27], $row_iso[28], $row_iso[29], $row_iso[30], $row_iso[31], $row_iso[32], $row_iso[33]);
			}else if(sizeof($fields) == 41){
				$stmt->bind_param("ssssssssssssssssssssssssssssssssssssssssss", $row_iso[0], $row_iso[1], $row_iso[2], $row_iso[3], $row_iso[4], $row_iso[5], $row_iso[6], $row_iso[7], $row_iso[8], $row_iso[9], $row_iso[10], $row_iso[11], $row_iso[12], $row_iso[13], $row_iso[14], $row_iso[15], $row_iso[16], $row_iso[17], $row_iso[18], $row_iso[19], $row_iso[20], $row_iso[21], $row_iso[22], $row_iso[23], $row_iso[24], $row_iso[25], $row_iso[26], $row_iso[27], $row_iso[28], $row_iso[29], $row_iso[30], $row_iso[31], $row_iso[32], $row_iso[33], $row_iso[34], $row_iso[35], $row_iso[36], $row_iso[37], $row_iso[38], $row_iso[39], $row_iso[40], $row_iso[41]);
			}else{
				die("Too many params! [".sizeof($fields)."]\n");
			}
			$stmt->execute() or die("stmt exec failed on table ".$table);
		}
		$stmt->close();
		$result_iso->close();
	}
}
$mysqli_utf->commit();
$mysqli_iso->close();
$mysqli_utf->close();