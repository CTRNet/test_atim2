<?php

function recordCollection(&$voas_to_collection_data) {
	$voas_to_collection_ids = array();
	foreach($voas_to_collection_data as $voa_nbr => $collection_data) {
		if(!isset($collection_data['participant_id'])) die('ERR 664374377434332');
		$collection_data['collection_property'] = 'participant collection';
		$collection_data['collection_voa_nbr'] = $voa_nbr;
		$collection_data['bank_id'] = '1';
		$collection_data['collection_datetime_accuracy'] = str_replace('c', 'h', $collection_data['collection_datetime_accuracy']);
		$voas_to_collection_ids[$voa_nbr] = customInsertRecord($collection_data, 'collections', false);
	}
	unset($voas_to_collection_data);
	return $voas_to_collection_ids;
}
