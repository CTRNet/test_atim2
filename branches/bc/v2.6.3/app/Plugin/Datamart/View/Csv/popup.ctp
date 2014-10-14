<?php
$override = array(
	'Config.config_language' => $_SESSION['Config']['language'],
	'Config.define_csv_separator'	=> csv_separator,
	'Config.define_csv_encoding'	=> csv_encoding
);
$this->Structures->build($atim_structure, array(
	'type' => 'add', 
	'links' => array('top' => 'Datamart/Csv/csv/'), 
	'override' => $override,
	'settings' => array('actions' => false))
);