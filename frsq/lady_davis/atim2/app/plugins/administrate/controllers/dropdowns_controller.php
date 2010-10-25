<?php
class DropdownsController extends AdministrateAppController {
	var $uses = array(
		'StructurePermissibleValuesCustom',
		'StructurePermissibleValuesCustomControl'
		);
		
	var $paginate = array('StructurePermissibleValuesCustomControl'=>array('limit' => pagination_amount,'order'=>'StructurePermissibleValuesCustomControl.name ASC')); 		
	
	function index(){
		$this->data = $this->paginate($this->StructurePermissibleValuesCustomControl, array('StructurePermissibleValuesCustomControl.flag_active' => '1'));
		$this->Structures->set("administrate_dropdowns", 'administrate_dropdowns');
	}
	
	function view($control_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id)));
		if(empty($control_data)) { $this->redirect( '/pages/err_admin_no_data', NULL, TRUE ); } 
		$this->set("control_data", $control_data);
		
		$this->data = $this->StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id)));
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
	}
	
	function add($control_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id)));
		if(empty($control_data)) { $this->redirect( '/pages/err_admin_no_data', NULL, TRUE ); } 
		$this->set("control_data", $control_data);
		
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
				while($data_unit = array_pop($this->data)){
					if(strlen($data_unit['StructurePermissibleValuesCustom']['value']) > 0){
						$this->StructurePermissibleValuesCustom->id = null;
						$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_id;
						if(!$this->StructurePermissibleValuesCustom->save($data_unit)) { $this->redirect( '/pages/err_admin_record_err', NULL, TRUE ); }
					}
				}
				$this->atimFlash('your data has been updated', '/administrate/dropdowns/view/'.$control_id);
			}
		}
	}
	
	function edit($control_id, $value_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id)));
		if(empty($control_data)) { $this->redirect( '/pages/err_admin_no_data', NULL, TRUE ); } 
		$this->set("control_data", $control_data);
		
		$this->set( 'atim_menu_variables', array('StructurePermissibleValuesCustom.id'=>$value_id, 'StructurePermissibleValuesCustom.control_id'=>$control_id));
		
		$value_data = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id, 'StructurePermissibleValuesCustom.id' => $value_id)));
		if(empty($value_data)) { $this->redirect( '/pages/err_admin_no_data', NULL, TRUE ); } 
		
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
		
		if(empty($this->data)) {
			$this->data = $value_data;
		} else {
			$this->StructurePermissibleValuesCustom->id = $value_id;
			if(!$this->StructurePermissibleValuesCustom->save($this->data)) { $this->redirect( '/pages/err_admin_record_err', NULL, TRUE ); }
			$this->atimFlash('your data has been updated', '/administrate/dropdowns/view/'.$control_id);
		}
	}
}