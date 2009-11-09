<?php

	$connection = @mysql_connect("localhost", "root", "1qaz1qaz") or die("MySQL connection could not be established");
	//Selects database
	@mysql_select_db("atim2") or die("ATiM database could not be found");
	
	//Drop extra columns from user table
	mysql_query("ALTER TABLE `users`
	ADD COLUMN `name` VARCHAR(255) NOT NULL default '' AFTER `username`,
	DROP COLUMN `department`,
	DROP COLUMN `job_title`,
	DROP COLUMN `institution`,
	DROP COLUMN `laboratory`,
	DROP COLUMN `help_visible`,
	DROP COLUMN `street`,
	DROP COLUMN `city`,
	DROP COLUMN `region`,
	DROP COLUMN `country`,
	DROP COLUMN `mail_code`,
	DROP COLUMN `phone_work`,
	DROP COLUMN `phone_home`,
	DROP COLUMN `lang`,
	DROP COLUMN `pagination`,
	DROP COLUMN `last_visit`,
	DROP COLUMN `active`;");
	
	//Combine first name and last name
	$result = mysql_query("SELECT id, first_name, last_name FROM `users`;");
	
	for($a = 0; $a < mysql_numrows($result); $a++){
		$userid = mysql_result($result, $a, "id");
		$fname = mysql_result($result, $a, "first_name");
		$lname = mysql_result($result, $a, "last_name");
		
		$name = $fname.' '.$lname;
		
		mysql_query("UPDATE `users` SET `name` = '$name' WHERE `id` = $userid;");
	}

	mysql_query("ALTER TABLE `users` DROP COLUMN `first_name`, DROP COLUMN `last_name`;");
?>