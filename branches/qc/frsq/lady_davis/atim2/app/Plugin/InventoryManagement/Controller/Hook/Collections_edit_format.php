<?php 

	$this->set('specific_specimen_type_precision_list', $this->Collection->getSpecimenTypePrecision(true, $collection_data['Collection']['qc_lady_specimen_type']));
