<?php
$pkey = "Patient Biobank Number
(required)";

$fields = array(
	"bank_id" => "@3",
	"collection_datetime" => "Date of Specimen Collection Date",
	"collection_datetime_accuracy" => "Date of Specimen Collection Accuracy"
);




$tables['collections'] = new Model(5, $pkey, array(), true, NULL, 'participants', $fields);
$tables['collections']->custom_data = array("date_fields" => array(
	$fields["date_of_birth"], 
	$fields["date_of_death"], 
	$fields["qc_tf_suspected_date_of_death"], 
	$fields["qc_tf_last_contact"]));
$tables['participants']->post_read_function = 'postRead';

//TODO: Post queries and job done

?>

