<?php
 
 	if($submitted_data_validates && $this->data['SampleMaster']['sample_type'] == 'tissue') {
		if(!isset($this->TissueCodeDefintion)) $this->TissueCodeDefintion = AppModel::atimNew("Inventorymanagement", "TissueCodeDefintion", true);
		$this->TissueCodeDefintion->setTissueDefintionsFromCode($this->data);
 	}

?>
