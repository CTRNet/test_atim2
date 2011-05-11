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
		$control_data = $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id), 'recursive' => 0));
		if(empty($control_data)){ 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		} 
		$this->set("control_data", $control_data);
		
		$this->data = $this->StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id), 'order' => array('display_order', 'value')));
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
	}
	
	function add($control_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->findById($control_id);
		if(empty($control_data)){
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		} 
		$this->set("control_data", $control_data);
		
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
		if(empty($this->data)){
			$this->data = array(array(
				'StructurePermissibleValuesCustom' => array('value' => "")));
		}else{
			//validate and save
			
			$errors_tracking = array();
			
			// A - Launch Business Rules Validation
			
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
			
			$row_counter = 0;
			foreach($this->data as &$data_unit){
				$row_counter++;
				
				// 1- Check 'value'
				
				$data_unit['StructurePermissibleValuesCustom'] = array_map("trim", $data_unit['StructurePermissibleValuesCustom']);
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['value'], $existing_values)){
					$errors_tracking['value'][sprintf(__('a specified %s already exists for that dropdown', true), __("value", true))][] = $row_counter;
				}
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['value'], $current_values)){
					$errors_tracking['value'][sprintf(__('you cannot declare the same %s more than once', true), __("value", true))][] = $row_counter;
				}
				if(strlen($data_unit['StructurePermissibleValuesCustom']['value']) > $max_length){
					$errors_tracking['value'][sprintf(__('%s cannot exceed %d characters', true), __("value", true), $max_length)][] = $row_counter;
				}
				
				// 2- Check 'en'
				
				if(!(is_null($data_unit['StructurePermissibleValuesCustom']['en']) || ($data_unit['StructurePermissibleValuesCustom']['en'] == ''))) {
					if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['en'], $existing_en)){
						$errors_tracking['en'][sprintf(__('a specified %s already exists for that dropdown', true), __("english translation", true))][] = $row_counter;
					}
					if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['en'], $current_en)){
						$errors_tracking['en'][sprintf(__('you cannot declare the same %s more than once', true), __("english translation", true))][] = $row_counter;
					}	
				}
				if(strlen($data_unit['StructurePermissibleValuesCustom']['en']) > $this->StructurePermissibleValuesCustom->_schema['en']['length']){
					$errors_tracking['en'][sprintf(__('%s cannot exceed %d characters', true), __("english translation", true), $this->StructurePermissibleValuesCustom->_schema['en']['length'])][] = $row_counter;
				}
				
				// 3- Check 'fr'
				
				if(!(is_null($data_unit['StructurePermissibleValuesCustom']['fr']) || ($data_unit['StructurePermissibleValuesCustom']['fr'] == ''))) {
					if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['fr'], $existing_fr)){
						$errors_tracking['fr'][sprintf(__('a specified %s already exists for that dropdown', true), __("french translation", true))][] = $row_counter;
					}
					if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['fr'], $current_fr)){
						$errors_tracking['fr'][sprintf(__('you cannot declare the same %s more than once', true), __("french translation", true))][] = $row_counter;
					}
				}
				if(strlen($data_unit['StructurePermissibleValuesCustom']['fr']) > $this->StructurePermissibleValuesCustom->_schema['fr']['length']){
					$errors_tracking['fr'][sprintf(__('%s cannot exceed %d characters', true), __("french translation", true), $this->StructurePermissibleValuesCustom->_schema['fr']['length'])][] = $row_counter;
				}
				
				$current_values[$data_unit['StructurePermissibleValuesCustom']['value']] = null;
				$current_en[$data_unit['StructurePermissibleValuesCustom']['en']] = null;
				$current_fr[$data_unit['StructurePermissibleValuesCustom']['fr']] = null;
			}
			unset($data_unit);

			// B - Launch Structure Fields Validation
			
			$row_counter = 0;
			foreach($this->data as $data_unit) {
				$row_counter++;
				$this->StructurePermissibleValuesCustom->id = null;
				$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_id;
				$this->StructurePermissibleValuesCustom->set($data_unit);
				if(!$this->StructurePermissibleValuesCustom->validates()){
					foreach($this->StructurePermissibleValuesCustom->validationErrors as $field => $msg) {
						$errors_tracking[$field][$msg][] = $row_counter;
					}
				}
			}

			// Launch Save Process
			
			if(empty($errors_tracking)){
				//save all
				$tmp_data = AppController::cloneArray($this->data);
				while($data_unit = array_pop($tmp_data)){
					$this->StructurePermissibleValuesCustom->id = null;
					$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_id;
					$this->StructurePermissibleValuesCustom->set($data_unit);
					if(!$this->StructurePermissibleValuesCustom->save($data_unit)) {
						 $this->redirect( '/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
					}
				}
				$this->atimFlash('your data has been updated', '/administrate/dropdowns/view/'.$control_id);
			
			} else {
				$this->StructurePermissibleValuesCustom->validationErrors = array();
				foreach($errors_tracking as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						 $this->StructurePermissibleValuesCustom->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s',true));
					}
				}
			}
		}
	}
	
	function edit($control_id, $value_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id)));
		if(empty($control_data)){
			 $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		} 
		$this->set("control_data", $control_data);
		
		$this->set( 'atim_menu_variables', array('StructurePermissibleValuesCustom.id'=>$value_id, 'StructurePermissibleValuesCustom.control_id'=>$control_id));
		
		$value_data = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id, 'StructurePermissibleValuesCustom.id' => $value_id)));
		if(empty($value_data)){
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		} 
		
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
		
		if(empty($this->data)) {
			$this->data = $value_data;
		} else {
			$this->StructurePermissibleValuesCustom->id = $value_id;
			$skip_save = false;
			
			// 1- Check 'en'
				
			if(!(is_null($this->data['StructurePermissibleValuesCustom']['en']) 
			|| ($this->data['StructurePermissibleValuesCustom']['en'] == '')
			|| ($this->data['StructurePermissibleValuesCustom']['en'] == $value_data['StructurePermissibleValuesCustom']['en']))) {
				$tmp = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.en' => $this->data['StructurePermissibleValuesCustom']['en'], 'StructurePermissibleValuesCustom.id != '.$value_id, 'StructurePermissibleValuesCustom.control_id' => $control_id))); 
				if(!empty($tmp)){
					$this->StructurePermissibleValuesCustom->validationErrors['en'] = sprintf(__('a specified %s already exists for that dropdown', true), __("english translation", true));
					$skip_save = true;
				}
				if(strlen($this->data['StructurePermissibleValuesCustom']['en']) > $this->StructurePermissibleValuesCustom->_schema['en']['length']){
					$this->StructurePermissibleValuesCustom->validationErrors['en'] = sprintf(__('%s cannot exceed %d characters', true), __("english translation", true), $this->StructurePermissibleValuesCustom->_schema['en']['length']);
					$skip_save = true;
				}
			}
						
			// 2- Check 'fr'

			if(!(is_null($this->data['StructurePermissibleValuesCustom']['fr']) 
			|| ($this->data['StructurePermissibleValuesCustom']['fr'] == '')
			|| ($this->data['StructurePermissibleValuesCustom']['fr'] == $value_data['StructurePermissibleValuesCustom']['fr']))) {
				$tmp = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.fr' => $this->data['StructurePermissibleValuesCustom']['fr'], 'StructurePermissibleValuesCustom.id != '.$value_id, 'StructurePermissibleValuesCustom.control_id' => $control_id)));
				if(!empty($tmp)){
					$this->StructurePermissibleValuesCustom->validationErrors['fr'] = sprintf(__('a specified %s already exists for that dropdown', true), __("french translation", true));
					$skip_save = true;
				}
				if(strlen($this->data['StructurePermissibleValuesCustom']['fr']) > $this->StructurePermissibleValuesCustom->_schema['fr']['length']){
					$this->StructurePermissibleValuesCustom->validationErrors['fr'] = sprintf(__('%s cannot exceed %d characters', true), __("french translation", true), $this->StructurePermissibleValuesCustom->_schema['fr']['length']);
					$skip_save = true;
				}
			}
			
			if(!$skip_save){
				if(!$this->StructurePermissibleValuesCustom->save($this->data)){
					$this->redirect( '/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
				}
				$this->atimFlash('your data has been updated', '/administrate/dropdowns/view/'.$control_id);
			}
		}
	}
	
	function configure($control_id){
		if(empty($this->data)){
			$control_data = $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.id' => $control_id)));
			if(empty($control_data)){ 
				$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
			} 
			$this->set("control_data", $control_data);
			$this->set( 'atim_menu_variables', array('StructurePermissibleValuesCustom.control_id'=>$control_id));
			
			$this->data = $this->StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id), 'recursive' => -1, 'order' => array('display_order', 'value')));
			if(empty($this->data)){
				$this->flash(__("you cannot configure an empty list", true), "javascript:history.back();", 5);
			}
			$this->set('alpha_order', $this->data[0]['StructurePermissibleValuesCustom']['display_order'] == 0);
			$this->Structures->set('administrate_dropdown_values');
		}else{
			$data = array();
			if(isset($this->data[0]['default_order'])){
				foreach($this->data as $unit){
					$data[] = array("id" => $unit['StructurePermissibleValuesCustom']['id'], "display_order" => 0, "use_as_input" => $unit['StructurePermissibleValuesCustom']['use_as_input']);
				}
			}else{
				$order = 1;
				foreach($this->data as $unit){
					$data[] = array("id" => $unit['option_id'], "display_order" => $order ++, "use_as_input" => $unit['StructurePermissibleValuesCustom']['use_as_input']);
				}
			}
			if($this->StructurePermissibleValuesCustom->saveAll($data)){
				$this->atimFlash('your data has been updated', '/administrate/dropdowns/view/'.$control_id);
			}
		}
	}
}