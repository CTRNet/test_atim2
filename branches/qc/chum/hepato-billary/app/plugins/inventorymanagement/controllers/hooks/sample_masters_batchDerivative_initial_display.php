<?php

foreach($this->data as &$new_data_set) {
	$new_data_set['children'][0]['DerivativeDetail']['creation_site'] = "ICM";
	$new_data_set['children'][0]['DerivativeDetail']['creation_by'] = 'louise rousseau';
}
