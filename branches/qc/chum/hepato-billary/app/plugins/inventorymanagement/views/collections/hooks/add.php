<?php
if(isset($default_acquisition_label)){
	$final_options['override']['Collection.acquisition_label'] = $default_acquisition_label;
}

if(!empty($this->data)){
	$final_options['override']['Collection.collection_site'] = "saint-luc hospital";
	$final_options['override']['Collection.bank_id'] = "1";
}

?>