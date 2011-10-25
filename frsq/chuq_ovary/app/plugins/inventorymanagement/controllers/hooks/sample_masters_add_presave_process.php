<?php
 
 	if($submitted_data_validates && $this->data['SampleControl']['sample_type'] == 'tissue') {
		if(!isset($this->TissueCodeDefintion)) $this->TissueCodeDefintion = AppModel::getInstance("Inventorymanagement", "TissueCodeDefintion", true);
		$this->TissueCodeDefintion->setTissueDefintionsFromCode($this->data);
 	}

?>
