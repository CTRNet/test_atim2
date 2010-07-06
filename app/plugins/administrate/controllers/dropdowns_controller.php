<?php
class DropdownsController extends AdministrateAppController {
	var $uses = array(
		'StructurePermissibleValuesCustom',
		'StructurePermissibleValuesCustomControl'
		);
	
	function index(){
		$this->data = $this->StructurePermissibleValuesCustomControl->find('all');
		$this->Structures->set("administrate_dropdowns", 'administrate_dropdowns');
	}
	
	function view($control_id){
		$this->set("control_id", $control_id);
		$this->set("control_data", $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id))));
		$this->data = $this->StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id)));
		$this->Structures->set("administrate_dropdowns", 'administrate_dropdowns');
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
	}
	
	function add($control_id){
		$this->set("control_id", $control_id);
		$this->set("control_data", $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id))));
		$this->Structures->set("administrate_dropdowns", 'administrate_dropdowns');
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
		if(empty($this->data)){
			$this->data = array(array(
				'StructurePermissibleValuesCustom' => array('value' => "")));
		}else{
			//validate and save
			$current_values = array();
			foreach($this->data as &$data_unit){
				$data_unit['StructurePermissibleValuesCustom'] = array_map("trim", $data_unit['StructurePermissibleValuesCustom']);
				$tmp = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.value' => $data_unit['StructurePermissibleValuesCustom']['value'], 'StructurePermissibleValuesCustom.control_id' => $control_id)));
				if(!empty($tmp)){
					$this->StructurePermissibleValuesCustom->validationErrors['value'] = __('a specified value already exists for that dropdown', true);
					break;
				}
				if(isset($current_values[$data_unit['StructurePermissibleValuesCustom']['value']])){
					$this->StructurePermissibleValuesCustom->validationErrors['value'] = __('you cannot declare the same value more than once', true);
					break;
				}
				$current_values[$data_unit['StructurePermissibleValuesCustom']['value']] = "";
			}
			if(empty($this->StructurePermissibleValuesCustom->validationErrors)){
				foreach($this->data as $data_unit){
					if(strlen($data_unit['StructurePermissibleValuesCustom']['value']) > 0){
						unset($this->StructurePermissibleValuesCustom->id);
						$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_id;
						$this->StructurePermissibleValuesCustom->save($data_unit);
					}
				}
				$this->flash(__('your data has been updated', true), '/administrate/dropdowns/view/'.$control_id);
			}
		}
	}
}