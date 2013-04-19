<?php
//Date: May 4, 2009
//Version: .7 Beta
//To Do: Change direct path names for file to correct path names
//Notes:

	//Creates export file
	//$filee = fopen("C:\\wamp\\www\\atim2\\app\\locale\\eng\\LC_MESSAGES\\default.po", "w+t");
	//$filef = fopen("C:\\wamp\\www\\atim2\\app\\locale\\fre\\LC_MESSAGES\\default.po", "w+t");
	//$filex = fopen("C:\\wamp\\www\\atim2\\app\\locale\\error\\ERROR_MESSAGES\\error.po", "w+t");
	$filee = fopen("../../app/Locale/eng/LC_MESSAGES/default.po", "w+t") or die("Failed to open english file");
	$filef = fopen("../../app/Locale/fre/LC_MESSAGES/default.po", "w+t") or die("Failed to open french file");
	//$filex = fopen("../app/locale/error/ERROR_MESSAGES/error.po", "w+t");
	
	//Establishes a connection to the MySQL server
	$connection = @mysql_connect("127.0.0.1:8889", "root", "root")
					or die("Could not connect to MySQL");
	if(!mysql_set_charset("latin1", $connection)){
		die("We failed");
	}				
	echo(mysql_client_encoding($connection)."\n");
	//Selects the languages database
	@mysql_select_db("atim_new")
					or die("Could not select database");
    
	//Executes query
	$query = "SELECT * FROM i18n";
	$result = mysql_query($query) or die("Query 1 failed");
	
	
	//Displays all information returned from query
	for ( $count = 0; $count <= mysql_numrows($result)-1; $count++){
		//Takes information returned by query and creates variable for each field
		$id = mysql_result($result, $count, "id");
		$en = mysql_result( $result, $count, "en");
		if(strlen($en) > 1014){
		    $error = "msgid\t\"$id\"\nen\t\"$en\"\n";
			$en = substr($en, 0, 1014);
		}
		$fr = mysql_result( $result, $count, "fr");
		if(strlen($fr) > 1014){
		    if(strlen($error) > 2 ){
				$error = "$error\\nmsgstr\t\"$fr\"\n";
			}else{
				$error = "msgid\t\"$id\"\nmsgstr=\"$fr\"\n";
			}
			$fr = substr($fr, 0, 1014);
		}
		$english = "msgid\t\"$id\"\nmsgstr\t\"$en\"\n";
		$french = "msgid\t\"$id\"\nmsgstr\t\"$fr\"\n";
		
		//Writes output to file
		fwrite($filee, utf8_encode($english));
		fwrite($filef, utf8_encode($french));
		echo($french."\n");
	}
	
	///Close file
	fclose($filee);
	fclose($filef);
	//fclose($filex);
	
	//Close connection
	mysql_close();
?>
