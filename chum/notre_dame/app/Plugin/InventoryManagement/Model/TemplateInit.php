<?php
class TemplateInit extends InventoryManagementAppModel {
	var $useTable = false;
	
	function validates($options = array()) {
		$this->_schema = array();
		$result = parent::validates($options);
		
		//Note that a model validate array is empty if it's not created at the controller array
		//eg.: SpecimenDetail is created via the "uses" array, so the validation rules are defined.
		//Otherwise, on has to add it before setting the structures (which in turn sets the validation).
		//eg.: AppController::getInstance()->AliquotMaster = AppModel::getInstance('InventoryManagement', 'AliquotMaster'); would make AliquotMaster ready to recieve validation rules
		$specimen_detail_model = AppModel::getInstance('InventoryManagement', 'SpecimenDetail');
		$specimen_detail_model->set($this->data['TemplateInit']);
		$result = $specimen_detail_model->validates() ? $result : false;
		$this->validationErrors = array_merge($specimen_detail_model->validationErrors, $this->validationErrors);
		$this->data['TemplateInit'] = $specimen_detail_model->data;
		
		
		//adjust accuracy
		$this->data['TemplateInit'] = Set::flatten($this->data['TemplateInit']);
		foreach($this->data['TemplateInit'] as $key => &$value){
			if(isset($this->data['TemplateInit'][$key.'_accuracy'])){
				switch($this->data['TemplateInit'][$key.'_accuracy']){
					case 'i':
						$value = substr($value, 0, 13);
						break;
					case 'h':
						$value = substr($value, 0, 10);
						break;
					case 'd':
						$value = substr($value, 0, 7);
						break;
					case 'm':
						$value = substr($value, 0, 4);
						break;
					case 'y':
						$value = '±'.substr($value, 0, 4);
						break;
					default:
						break;
				}
				
				//no more use for that field
				unset($this->data['TemplateInit'][$key.'_accuracy']);
			}
		}
		unset($value);
		
		$output = array();
		foreach ($this->data['TemplateInit'] as $key => $value) {
			$output = Set::insert($output, $key, $value);
		}
		$this->data['TemplateInit'] = $output;
		
		return $result;
	}
}