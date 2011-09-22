<?php
class CsvController extends DatamartAppController {
	var $uses = array();

	/**
	 * Fetches data and returns it in a CSV
	 * @param boolean $all_fields
	 * @param string $plugin
	 * @param string $model_name The model to use to fetch the data
	 * @param string $model_pkey The key to use to fetch the data
	 * @param string $structure_alias The structure to render the data
	 * @param string $data_model The model to look for in the data array
	 * @param string $data_pkey The pkey to look for in the data array
	 */
	function csv($all_fields, $plugin, $model_name, $model_pkey, $structure_alias, $data_model = null, $data_pkey = null){
		$this->ModelToSearch = AppModel::getInstance($plugin, $model_name, true);
		
		if($data_pkey == null){
			$data_pkey = $model_pkey;
			if($data_model == null){
				$data_model = $model_name;
			}
		}
		
		if(!isset($this->data[$data_model]) || !isset($this->data[$data_model][$data_pkey])){
			$this->redirect( '/pages/err_internal?p[]=failed to find values', NULL, TRUE );
			exit;
		}
		$ids[] = 0;
		if(!is_array($this->data[$data_model][$data_pkey])){
			$this->data[$data_model][$data_pkey] = explode(",", $this->data[$data_model][$data_pkey]);
		}
		foreach($this->data[$data_model][$data_pkey] as $id){
			if($id != 0){
				$ids[] = $id;
			}
		}
		
		
		//see if we have an adhoc qry to use
		$adhoc_id = null;
		if(isset($this->data['Adhoc']['id'])){
			$adhoc_id = $this->data['Adhoc']['id'];
		}else if(isset($this->data['BatchSet']['id'])){
			$batchset_model = AppModel::getInstance("Datamart", "BatchSet", true);
			$batchset = $batchset_model->findById($this->data['BatchSet']['id']);
			if($batchset && $batchset['Adhoc']['id']){
				$adhoc_id = $batchset['Adhoc']['id'];
			}
		}
		
		$use_find = true;
		if($adhoc_id){
			$adhoc_model = AppModel::getInstance("Datamart", "Adhoc", true);
			$adhoc = $adhoc_model->findById($adhoc_id);
			if($adhoc){
				if(strpos($adhoc['Adhoc']['sql_query_for_results'], "WHERE TRUE") !== false){
					$query = str_replace("WHERE TRUE", "WHERE ".$model_name.".".$model_pkey." IN ('".implode("', '", $ids)."')", $adhoc['Adhoc']['sql_query_for_results']);
					list( , $query) = $this->Structures->parse_sql_conditions( $query, array() );
					$this->data = $this->ModelToSearch->query($query);
					$use_find = false;
				}else{
					require_once('customs/custom_adhoc_functions.php');
					$custom_adhoc_functions = new CustomAdhocFunctions();
					if(method_exists($custom_adhoc_functions, $adhoc['Adhoc']['function_for_results'])){
						$function = $adhoc['Adhoc']['function_for_results'];
						$this->data = $custom_adhoc_functions->$function($this, $ids);
						$use_find = false;
					}
				}
			}
			
			if($use_find){
				AppController::addWarningMsg(__('unable to use the batch set specified query', true));
			}
		}

		if($use_find){
			$this->data = $this->ModelToSearch->find('all', array('conditions' => $model_name.".".$model_pkey." IN ('".implode("', '", $ids)."')"));
		}
		
		$this->set('csv_header', true);
		$this->set('all_fields', $all_fields);
		$this->Structures->set($structure_alias, 'result_structure');
		Configure::write('debug', 0);
		$this->layout = false;
	}
}