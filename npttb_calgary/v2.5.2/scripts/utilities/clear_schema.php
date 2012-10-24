<?php
/**
 * Script to wipe out all tables of a schema. The schema name is prompted to avoid hazardous re-executions.
 * FM L'Heureux
 * 2010-01-15
 */

echo ("Enter the name of the schema to clear: ");
$schema = trim(fgets(STDIN));
if(strtolower($schema) == "information_schema" || strtolower($schema) == "mysql"){
	die("Denied: Will not delete this schema.\n");
}

$connection = @mysql_connect("127.0.0.1:8889", "root", "root") or die("Could not connect to MySQL");
@mysql_select_db($schema) or die("Could not select database");

$query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='".$schema."'";
$result = mysql_query($query) or die("Query failed");

$tables = array();
echo("Retrieving tables: ");
while($row = mysql_fetch_row($result)){
	$tables[] = $row[0];
}

echo(sizeof($tables)." table(s) retrieved\n");
if(sizeof($tables) > 0){
	print("Dropping tables\n");
	foreach($tables as $table){
		mysql_query("DROP TABLE ".$table) or die("Drop Query failed");
	}
	echo("All tables were dropped.\n");
}else{
	echo("Nothing to be dropped\n");
}