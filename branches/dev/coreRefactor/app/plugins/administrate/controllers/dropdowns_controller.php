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
		$control_data = $this->StructurePermissibleValuesCustomControl->findById($control_id);
		if(empty($control_data)){
			$this->redirect( '/pages/err_admin_no_data', NULL, TRUE ); 
		} 
		$this->set("control_data", $control_data);
		
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
		if(empty($this->data)){
			$this->data = array(array(
				'StructurePermissibleValuesCustom' => array('value' => "")));
		}else{
			//validate and save
			$current_values = array();
			$current_en = array();
			$current_fr = array();
			$max_length = min($this->StructurePermissibleValuesCustom->_schema['value']['length'], $control_data["StructurePermissibleValuesCustomControl"]["values_max_length"]);
			$break = false;
			$tmp = $this->StructurePermissibleValuesCustom->find('all', array('conditions' => array('control_id' => $control_id), 'recursive' => -1));
			$existing_values = array();
			$existing_en = array();
			$existing_fr = array();
			foreach($tmp as $unit){
				$existing_values[$unit['StructurePermissibleValuesCustom']['value']] = null;
				$existing_en[$unit['StructurePermissibleValuesCustom']['en']] = null;
				$existing_fr[$unit['StructurePermissibleValuesCustom']['fr']] = null;
			}
			foreach($this->data as &$data_unit){
				$data_unit['StructurePermissibleValuesCustom'] = array_map("trim", $data_unit['StructurePermissibleValuesCustom']);
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['value'], $existing_values)){
					$this->StructurePermissibleValuesCustom->validationErrors['value'] = sprintf(__('a specified %s already exists for that dropdown', true), __("value", true));
				}
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['en'], $existing_en)){
					$this->StructurePermissibleValuesCustom->validationErrors['en'] = sprintf(__('a specified %s already exists for that dropdown', true), __("english translation", true));
				}
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['fr'], $existing_fr)){
					$this->StructurePermissibleValuesCustom->validationErrors['fr'] = sprintf(__('a specified %s already exists for that dropdown', true), __("french translation", true));
				}
				
				
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['value'], $current_values)){
					$this->StructurePermissibleValuesCustom->validationErrors['value'] = sprintf(__('you cannot declare the same %s more than once', true), __("value", true));
				}
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['en'], $current_en)){
					$this->StructurePermissibleValuesCustom->validationErrors['en'] = sprintf(__('you cannot declare the same %s more than once', true), __("english translation", true));
				}
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['fr'], $current_fr)){
					$this->StructurePermissibleValuesCustom->validationErrors['fr'] = sprintf(__('you cannot declare the same %s more than once', true), __("french translation", true));
				}

				
				if(strlen($data_unit['StructurePermissibleValuesCustom']['value']) > $max_length){
					$this->StructurePermissibleValuesCustom->validationErrors['value'] = sprintf(__('%s cannot exceed %d characters', true), __("value", true), $max_length);
				}
				if(strlen($data_unit['StructurePermissibleValuesCustom']['en']) > $this->StructurePermissibleValuesCustom->_schema['en']['length']){
					$this->StructurePermissibleValuesCustom->validationErrors['en'] = sprintf(__('%s cannot exceed %d characters', true), __("english translation", true), $this->StructurePermissibleValuesCustom->_schema['en']['length']);
				}
				if(strlen($data_unit['StructurePermissibleValuesCustom']['fr']) > $this->StructurePermissibleValuesCustom->_schema['fr']['length']){
					$this->StructurePermissibleValuesCustom->validationErrors['fr'] = sprintf(__('%s cannot exceed %d characters', true), __("french translation", true), $this->StructurePermissibleValuesCustom->_schema['fr']['length']);
				}
				
				if(isset($this->StructurePermissibleValuesCustom->validationErrors)){
					break;
				}
				
				$current_values[$data_unit['StructurePermissibleValuesCustom']['value']] = null;
				$current_en[$data_unit['StructurePermissibleValuesCustom']['en']] = null;
				$current_fr[$data_unit['StructurePermissibleValuesCustom']['fr']] = null;
			}
			unset($data_unit);

			$save = true;
			if(empty($this->StructurePermissibleValuesCustom->validationErrors)){
				//validate all
				$tmp_data = AppController::cloneArray($this->data);
				while($data_unit = array_pop($tmp_data)){
					$this->StructurePermissibleValuesCustom->id = null;
					$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_id;
					$this->StructurePermissibleValuesCustom->set($data_unit);
					if(!$this->StructurePermissibleValuesCustom->validates()){
						$save = false;
						break;
					}
				}

				if($save){
					//save all
					$tmp_data = AppController::cloneArray($this->data);
					while($data_unit = array_pop($tmp_data)){
						$this->StructurePermissibleValuesCustom->id = null;
						$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_id;
						$this->StructurePermissibleValuesCustom->set($data_unit);
						if(!$this->StructurePermissibleValuesCustom->save($data_unit)) {
							 $this->redirect( '/pages/err_admin_record_err', NULL, TRUE ); 
						}
					}
					$this->atimFlash('your data has been updated', '/administrate/dropdowns/view/'.$control_id);
				}
			}
		}
	}
	
	function edit($control_id, $value_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id)));
		if(empty($control_data)){
			 $this->redirect( '/pages/err_admin_no_data', NULL, TRUE ); 
		} 
		$this->set("control_data", $control_data);
		
		$this->set( 'atim_menu_variables', array('StructurePermissibleValuesCustom.id'=>$value_id, 'StructurePermissibleValuesCustom.control_id'=>$control_id));
		
		$value_data = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id, 'StructurePermissibleValuesCustom.id' => $value_id)));
		if(empty($value_data)){
			$this->redirect( '/pages/err_admin_no_data', NULL, TRUE ); 
		} 
		
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
		
		if(empty($this->data)) {
			$this->data = $value_data;
		} else {
			$this->StructurePermissibleValuesCustom->id = $value_id;
			$skip_save = false;
			$tmp = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.en' => $this->data['StructurePermissibleValuesCustom']['en'], 'StructurePermissibleValuesCustom.id != '.$value_id))); 
			if(!empty($tmp)){
				$this->StructurePermissibleValuesCustom->validationErrors['en'] = sprintf(__('a specified %s already exists for that dropdown', true), __("english translation", true));
				$skip_save = true;
			}
			$tmp = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.fr' => $this->data['StructurePermissibleValuesCustom']['fr'], 'StructurePermissibleValuesCustom.id != '.$value_id)));
			if(!empty($tmp)){
				$this->StructurePermissibleValuesCustom->validationErrors['fr'] = sprintf(__('a specified %s already exists for that dropdown', true), __("french translation", true));
				$skip_save = true;
			}
			if(strlen($this->data['StructurePermissibleValuesCustom']['en']) > $this->StructurePermissibleValuesCustom->_schema['en']['length']){
				$this->StructurePermissibleValuesCustom->validationErrors['en'] = sprintf(__('%s cannot exceed %d characters', true), __("english translation", true), $this->StructurePermissibleValuesCustom->_schema['en']['length']);
				$skip_save = true;
			}
			if(strlen($this->data['StructurePermissibleValuesCustom']['fr']) > $this->StructurePermissibleValuesCustom->_schema['fr']['length']){
				$this->StructurePermissibleValuesCustom->validationErrors['fr'] = sprintf(__('%s cannot exceed %d characters', true), __("french translation", true), $this->StructurePermissibleValuesCustom->_schema['fr']['length']);
				$skip_save = true;
			}
			
			
			if(!$skip_save){
				if(!$this->StructurePermissibleValuesCustom->save($this->data)){
					$this->redirect( '/pages/err_admin_record_err', NULL, TRUE ); 
				}
				$this->atimFlash('your data has been updated', '/administrate/dropdowns/view/'.$control_id);
			}
		}
	}
}