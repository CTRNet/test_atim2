<?php
/**
 * @author FM L'Heureux
 * @date 2009-12-02
 * @description: Reads a database and compares base tables with revs tables. Gives the difference between those and gives the list
 * of tables without revs.
 */

$mysqli = mysqli_init();
if (!$mysqli) {
    die('mysqli_init failed');
}

$database_schema = "atim_new";

if (!$mysqli->real_connect('localhost', 'root', 'root', $database_schema)) {
    die('Connect Error (' . mysqli_connect_errno() . ') '
            . mysqli_connect_error());
}


$result = $mysqli->query("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA='$database_schema' ORDER BY TABLE_NAME") or die($mysqli->error);
$tables = array();
while ($row = $result->fetch_assoc()) {
	foreach($row as $key => $value){
		$tables[$value] = "";
	}
}
$result->free();
echo("<h1>Corrections to do</h1>\n");
$correction = false;
foreach($tables as $tname => $foo){
	if(isset($tables[$tname."_revs"])){
		$result = $mysqli->query("DESCRIBE ".$tname) or die($mysqli->error);
		$primary_table = array();
		while ($row = $result->fetch_assoc()) {
			$primary_table[$row['Field']]['Type'] = $row['Type'];
			$primary_table[$row['Field']]['Null'] = $row['Null'];
			$primary_table[$row['Field']]['Key'] = $row['Key'];
			$primary_table[$row['Field']]['Default'] = $row['Default'];
			$primary_table[$row['Field']]['Extra'] = $row['Extra'];
		}
		$primary_table['version_id']['Type'] = "int(11)";
		$primary_table['version_id']['Null'] = "NO";
		$primary_table['version_id']['Key'] = "";
		$primary_table['version_id']['Default'] = "";
		$primary_table['version_id']['Extra'] = "auto_increment";
		$primary_table['version_created']['Type'] = "datetime";
		$primary_table['version_created']['Null'] = "NO";
		$primary_table['version_created']['Key'] = "";
		$primary_table['version_created']['Default'] = "";
		$primary_table['version_created']['Extra'] = "";
		$result->free();

		$result = $mysqli->query("DESCRIBE ".$tname."_revs") or die($mysqli->error);
		while ($row = $result->fetch_assoc()) {
			if(!isset($primary_table[$row['Field']])){
				echo("- ".$tname."_revs.".$row['Field']."<br/>");
				$correction = true;
			}elseif ($primary_table[$row['Field']]['Type'] != $row['Type']
				|| $primary_table[$row['Field']]['Null'] != $row['Null']
//				|| $primary_table[$row['Field']]['Key'] != $row['Key']
				|| $primary_table[$row['Field']]['Default'] != $row['Default']
//				|| $primary_table[$row['Field']]['Extra'] != $row['Extra']
				){
					$correction = true;
					echo("c ".$tname.".".$row['Field']."<br/>\n");
				}
				unset($primary_table[$row['Field']]);
		}
		foreach($primary_table as $field => $foo){
			$correction = true;
			echo("+ ".$tname."_revs.".$field."<br/>\n");
		}
		$result->free();
		unset($tables[$tname]);
		unset($tables[$tname."_revs"]);
	}
}
if(!$correction){
	echo("None.\n");
}

echo("<h1>Tables without revs</h1>\n");
if(sizeof($tables) > 0){
	echo("<ol>\n");
	foreach($tables as $tname => $foo){
		echo("<li>".$tname."</li>\n");
	}
	echo("</ol>\n");
}else{
	echo("None.\n");
}

?>
<h1>Strings requiring translation</h1>
<ul>
<?php 
$query = "SELECT language_heading AS lang FROM structure_formats
			LEFT JOIN i18n ON i18n.id=language_heading
			WHERE language_heading != '' AND i18n.id IS NULL
		UNION
			SELECT language_label AS lang FROM structure_formats
			LEFT JOIN i18n ON i18n.id=language_label
			WHERE language_label != '' AND i18n.id IS NULL
		UNION
			SELECT language_tag AS lang FROM structure_formats
			LEFT JOIN i18n ON i18n.id=language_tag
			WHERE language_tag != '' AND i18n.id IS NULL
		UNION
			SELECT language_help AS lang FROM structure_formats
			LEFT JOIN i18n ON i18n.id=language_help
			WHERE language_help != '' AND i18n.id IS NULL
		UNION
			SELECT language_label AS lang FROM structure_formats
			LEFT JOIN i18n ON i18n.id=language_label
			WHERE language_label != '' AND i18n.id IS NULL	

		UNION
			SELECT language_label AS lang FROM structure_fields
			LEFT JOIN i18n ON i18n.id=language_label
			WHERE language_label != '' AND i18n.id IS NULL
		UNION
			SELECT language_tag AS lang FROM structure_fields
			LEFT JOIN i18n ON i18n.id=language_tag
			WHERE language_tag != '' AND i18n.id IS NULL
			
		UNION
			SELECT language_alias AS lang FROM structure_permissible_values
			LEFT JOIN i18n ON i18n.id=language_alias
			WHERE language_alias != '' AND i18n.id IS NULL

		UNION
			SELECT language_message AS lang FROM structure_validations
			LEFT JOIN i18n ON i18n.id=language_message
			WHERE language_message != '' AND i18n.id IS NULL";

$result = $mysqli->query($query) or die($mysqli->error);
$tables = array();
while ($row = $result->fetch_assoc()) {
	foreach($row as $key => $value){
		echo("<ol>".$value."</ol>\n");
	}
}
$result->free();

?>
</ul>