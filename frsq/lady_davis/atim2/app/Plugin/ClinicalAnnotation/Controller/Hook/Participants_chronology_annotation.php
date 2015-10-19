<?php
	
	if(isset($annotation['EventDetail']['response'])) {
		$chronolgy_data_annotation['chronology_details'] = isset($image_response_values[$annotation['EventDetail']['response']])? $image_response_values[$annotation['EventDetail']['response']] : $annotation['EventDetail']['response'];
	}
