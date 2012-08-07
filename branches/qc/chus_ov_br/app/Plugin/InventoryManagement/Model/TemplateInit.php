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
		$models_names = array('SpecimenDetail', 'DerivativeDetail','SampleMaster', 'SampleDetail','AliquotMaster','AliquotDetail');
		foreach($models_names as $model_name){
			if(array_key_exists($model_name, $this->data['TemplateInit'])) {
				$model = AppModel::getInstance('InventoryManagement', $model_name);
				$model->set(array($model_name => $this->data['TemplateInit'][$model_name]));
				$result = $model->validates() ? $result : false;
				$this->validationErrors = array_merge($model->validationErrors, $this->validationErrors);
				$this->data['TemplateInit'][$model_name] = $model->data[$model_name];
			}
		}

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