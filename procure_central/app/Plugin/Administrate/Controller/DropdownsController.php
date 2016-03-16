<?php
class DropdownsController extends AdministrateAppController {
	var $uses = array(
		'StructurePermissibleValuesCustom',
		'StructurePermissibleValuesCustomControl'
		);
		
	var $paginate = array('StructurePermissibleValuesCustomControl'=>array('order'=>'StructurePermissibleValuesCustomControl.category ASC, StructurePermissibleValuesCustomControl.name ASC')); 		
	
	function index() {
		// Nothing to do	  	
	  	
	  	// CUSTOM CODE: FORMAT DISPLAY DATA
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
	}
	
	function subIndex($filter = 'all') {
		if(!in_array($filter, array('all', 'empty', 'not_empty'))) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$counter_sort_option = false;
		if(isset($this->passedArgs['sort']) && $this->passedArgs['sort'] == 'Generated.custom_permissible_values_counter') {
			$counter_sort_option = $this->passedArgs['direction'];
		}
		$conditions = array('StructurePermissibleValuesCustomControl.flag_active' => '1');
		if($filter == 'empty') $conditions['StructurePermissibleValuesCustomControl.values_counter'] = '0';
		else if($filter == 'not_empty') $conditions[] = 'StructurePermissibleValuesCustomControl.values_counter != 0';
		$this->request->data = $this->paginate($this->StructurePermissibleValuesCustomControl, $conditions);	
		$this->Structures->set("administrate_dropdowns", 'administrate_dropdowns');
	}
	
	function view($control_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->getOrRedirect($control_id);
		$this->set("control_data", $control_data);
		
		$this->request->data = $this->StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id), 'order' => array('display_order', 'value')));
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
	}
	
	function add($control_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->getOrRedirect($control_id);
		$this->set("control_data", $control_data);
		
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
		if(empty($this->request->data)){
			$this->request->data = array(array(
				'StructurePermissibleValuesCustom' => array('value' => "")));
		}else{
			//validate and save
			
			$errors_tracking = array();
			
			// A - Launch Business Rules Validation
			
			$current_values = array();
			$current_en = array();
			$current_fr = array();
			$this->StructurePermissibleValuesCustom->schema();
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
			foreach($this->request->data as &$data_unit){
				$row_counter++;
				
				// 1- Check 'value'
				
				$data_unit['StructurePermissibleValuesCustom'] = array_map("trim", $data_unit['StructurePermissibleValuesCustom']);
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['value'], $existing_values)){
					$errors_tracking['value'][__('a specified %s already exists for that dropdown', __("value"))][] = $row_counter;
				}
				if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['value'], $current_values)){
					$errors_tracking['value'][__('you cannot declare the same %s more than once', __("value"))][] = $row_counter;
				}
				if(strlen($data_unit['StructurePermissibleValuesCustom']['value']) > $max_length){
					$errors_tracking['value'][__('%s cannot exceed %d characters', __("value"), $max_length)][] = $row_counter;
				}
				
				// 2- Check 'en'
				
				if(!(is_null($data_unit['StructurePermissibleValuesCustom']['en']) || ($data_unit['StructurePermissibleValuesCustom']['en'] == ''))) {
					if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['en'], $existing_en)){
						$errors_tracking['en'][__('a specified %s already exists for that dropdown', __("english translation"))][] = $row_counter;
					}
					if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['en'], $current_en)){
						$errors_tracking['en'][__('you cannot declare the same %s more than once', __("english translation"))][] = $row_counter;
					}	
				}
				if(strlen($data_unit['StructurePermissibleValuesCustom']['en']) > $this->StructurePermissibleValuesCustom->_schema['en']['length']){
					$errors_tracking['en'][__('%s cannot exceed %d characters', __("english translation"), $this->StructurePermissibleValuesCustom->_schema['en']['length'])][] = $row_counter;
				}
				
				// 3- Check 'fr'
				
				if(!(is_null($data_unit['StructurePermissibleValuesCustom']['fr']) || ($data_unit['StructurePermissibleValuesCustom']['fr'] == ''))) {
					if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['fr'], $existing_fr)){
						$errors_tracking['fr'][__('a specified %s already exists for that dropdown', __("french translation"))][] = $row_counter;
					}
					if(array_key_exists($data_unit['StructurePermissibleValuesCustom']['fr'], $current_fr)){
						$errors_tracking['fr'][__('you cannot declare the same %s more than once', __("french translation"))][] = $row_counter;
					}
				}
				if(strlen($data_unit['StructurePermissibleValuesCustom']['fr']) > $this->StructurePermissibleValuesCustom->_schema['fr']['length']){
					$errors_tracking['fr'][__('%s cannot exceed %d characters', __("french translation"), $this->StructurePermissibleValuesCustom->_schema['fr']['length'])][] = $row_counter;
				}
				
				$current_values[$data_unit['StructurePermissibleValuesCustom']['value']] = null;
				$current_en[$data_unit['StructurePermissibleValuesCustom']['en']] = null;
				$current_fr[$data_unit['StructurePermissibleValuesCustom']['fr']] = null;
			}
			unset($data_unit);

			// B - Launch Structure Fields Validation
			
			$row_counter = 0;
			foreach($this->request->data as $data_unit) {
				$row_counter++;
				$this->StructurePermissibleValuesCustom->id = null;
				$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_id;
				$this->StructurePermissibleValuesCustom->set($data_unit);
				if(!$this->StructurePermissibleValuesCustom->validates()){
					foreach($this->StructurePermissibleValuesCustom->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg)$errors_tracking[$field][$msg][] = $row_counter;
					}
				}
			}

			// Launch Save Process
			if(empty($errors_tracking)){
				//save all
				$tmp_data = AppController::cloneArray($this->request->data);
				$this->StructurePermissibleValuesCustom->addWritableField('control_id');
				$this->StructurePermissibleValuesCustom->writable_fields_mode = 'addgrid';
				while($data_unit = array_pop($tmp_data)){
					$this->StructurePermissibleValuesCustom->id = null;
					$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_id;
					$this->StructurePermissibleValuesCustom->set($data_unit);
					if(!$this->StructurePermissibleValuesCustom->save($data_unit)) {
						 $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
					}
				}
				$this->atimFlash(__('your data has been updated'), '/Administrate/Dropdowns/view/'.$control_id);
			
			} else {
				$this->StructurePermissibleValuesCustomControl->validationErrors = array();
				foreach($errors_tracking as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						 $this->StructurePermissibleValuesCustomControl->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
					}
				}
			}
		}
	}
	
	function edit($control_id, $value_id){
		$control_data = $this->StructurePermissibleValuesCustomControl->getOrRedirect($control_id);
		$this->set("control_data", $control_data);
		
		$this->set( 'atim_menu_variables', array('StructurePermissibleValuesCustom.id'=>$value_id, 'StructurePermissibleValuesCustom.control_id'=>$control_id));
		
		$value_data = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id, 'StructurePermissibleValuesCustom.id' => $value_id)));
		if(empty($value_data)){
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		} 
		
		$this->Structures->set("administrate_dropdown_values", 'administrate_dropdown_values');
		
		if(empty($this->request->data)) {
			$this->request->data = $value_data;
		} else {
			$this->StructurePermissibleValuesCustom->id = $value_id;
			$skip_save = false;
			
			// 1- Check 'en'
				
			if(!(is_null($this->request->data['StructurePermissibleValuesCustom']['en']) 
			|| ($this->request->data['StructurePermissibleValuesCustom']['en'] == '')
			|| ($this->request->data['StructurePermissibleValuesCustom']['en'] == $value_data['StructurePermissibleValuesCustom']['en']))) {
				$tmp = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.en' => $this->request->data['StructurePermissibleValuesCustom']['en'], 'StructurePermissibleValuesCustom.id != '.$value_id, 'StructurePermissibleValuesCustom.control_id' => $control_id))); 
				if(!empty($tmp)){
					$this->StructurePermissibleValuesCustom->validationErrors['en'][] = __('a specified %s already exists for that dropdown', __("english translation"));
					$skip_save = true;
				}
				if(strlen($this->request->data['StructurePermissibleValuesCustom']['en']) > $this->StructurePermissibleValuesCustom->_schema['en']['length']){
					$this->StructurePermissibleValuesCustom->validationErrors['en'][] = __('%s cannot exceed %d characters', __("english translation"), $this->StructurePermissibleValuesCustom->_schema['en']['length']);
					$skip_save = true;
				}
			}
						
			// 2- Check 'fr'

			if(!(is_null($this->request->data['StructurePermissibleValuesCustom']['fr']) 
			|| ($this->request->data['StructurePermissibleValuesCustom']['fr'] == '')
			|| ($this->request->data['StructurePermissibleValuesCustom']['fr'] == $value_data['StructurePermissibleValuesCustom']['fr']))) {
				$tmp = $this->StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustom.fr' => $this->request->data['StructurePermissibleValuesCustom']['fr'], 'StructurePermissibleValuesCustom.id != '.$value_id, 'StructurePermissibleValuesCustom.control_id' => $control_id)));
				if(!empty($tmp)){
					$this->StructurePermissibleValuesCustom->validationErrors['fr'][] = __('a specified %s already exists for that dropdown', __("french translation"));
					$skip_save = true;
				}
				if(strlen($this->request->data['StructurePermissibleValuesCustom']['fr']) > $this->StructurePermissibleValuesCustom->_schema['fr']['length']){
					$this->StructurePermissibleValuesCustom->validationErrors['fr'][] = __('%s cannot exceed %d characters', __("french translation"), $this->StructurePermissibleValuesCustom->_schema['fr']['length']);
					$skip_save = true;
				}
			}
			
			if(!$skip_save){
				if(!$this->StructurePermissibleValuesCustom->save($this->request->data)){
					$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
				}
				$this->atimFlash(__('your data has been updated'), '/Administrate/Dropdowns/view/'.$control_id);
			}
		}
	}
	
	function configure($control_id){
		$this->Structures->set('administrate_dropdown_values');
		if(empty($this->request->data)){
			$control_data = $this->StructurePermissibleValuesCustomControl->getOrRedirect($control_id);
			$this->set("control_data", $control_data);
			$this->set( 'atim_menu_variables', array('StructurePermissibleValuesCustom.control_id'=>$control_id));
			
			$this->request->data = $this->StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id), 'recursive' => -1, 'order' => array('display_order', 'value')));
			if(empty($this->request->data)){
				$this->flash(__("you cannot configure an empty list"), "javascript:history.back();", 5);
			}
			$this->set('alpha_order', $this->request->data[0]['StructurePermissibleValuesCustom']['display_order'] == 0);
		}else{
			$data = array();
			if(isset($this->request->data[0]['default_order'])){
				foreach($this->request->data as $unit){
					$data[] = array("id" => $unit['StructurePermissibleValuesCustom']['id'], "display_order" => 0, "use_as_input" => $unit['StructurePermissibleValuesCustom']['use_as_input']);
				}
			}else{
				$order = 1;
				foreach($this->request->data as $unit){
					$data[] = array("id" => $unit['StructurePermissibleValuesCustom']['id'], "display_order" => $order ++, "use_as_input" => $unit['StructurePermissibleValuesCustom']['use_as_input']);
				}
			}
			
			$ids = $this->StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_id), 'recursive' => -1, 'fields' => 'id'));
			$ids = AppController::defineArrayKey($ids, 'StructurePermissibleValuesCustom', 'id', true);
			if(count($ids) != count($data)){
				//hack detected
				$this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );
			}
			foreach($data as &$data_unit){
				if(!isset($ids[$data_unit['id']])){
					//hack detected
					$this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );
				}
			}
			
			$this->StructurePermissibleValuesCustom->addWritableField('display_order');
			$this->StructurePermissibleValuesCustom->writable_fields_mode = 'editgrid';
			$this->StructurePermissibleValuesCustom->getDataSource()->begin();
			foreach($data as &$data_unit){
				$this->StructurePermissibleValuesCustom->data = null;
				$this->StructurePermissibleValuesCustom->id = $data_unit['id'];
				$this->StructurePermissibleValuesCustom->save($data_unit);
			}
			$this->StructurePermissibleValuesCustom->getDataSource()->commit();
			$this->atimFlash(__('your data has been updated'), '/Administrate/Dropdowns/view/'.$control_id);
		}
	}
}