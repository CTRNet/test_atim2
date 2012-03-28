<?php
class CsvController extends DatamartAppController {
	var $uses = array();

	/**
	 * Fetches data and returns it in a CSV
	 * Too many params so they are received via the /key:value/ syntax
	 * Either generates the CSV popup or the CSV file.
	 */
	function csv(){
		if(isset($this->passedArgs['popup'])){
			//generates CSV popup
			$this->Structures->set('csv_popup');
			$this->render('popup');
		}else{
			$plugin = $this->passedArgs['plugin'];
			$model_name = $this->passedArgs['model'];			//The model to use to fetch the data
			$model_pkey = $this->passedArgs['modelPkey'];		//The key to use to fetch the data
			$structure_alias = $this->passedArgs['structure'];	//The structure to render the data
			$data_pkey = isset($this->passedArgs['dataPkey']) ? $this->passedArgs['dataPkey'] : $model_pkey;	//The model to look for in the data array
			$data_model = isset($this->passedArgs['dataModel']) ? $this->passedArgs['dataModel'] : $model_name;	//The pkey to look for in the data array
			
			$this->ModelToSearch = AppModel::getInstance($plugin, $model_name, true);
			
			if(!isset($this->request->data[$data_model]) || !isset($this->request->data[$data_model][$data_pkey])){
				$this->redirect( '/Pages/err_internal?p[]=failed to find values', NULL, TRUE );
				exit;
			}
			
			$ids[] = 0;
			if(!is_array($this->request->data[$data_model][$data_pkey])){
				$this->request->data[$data_model][$data_pkey] = explode(",", $this->request->data[$data_model][$data_pkey]);
			}
			foreach($this->request->data[$data_model][$data_pkey] as $id){
				if($id != 0){
					$ids[] = $id;
				}
			}
			
			
			//see if we have an adhoc qry to use
			$adhoc_id = null;
			if(isset($this->request->data['Adhoc']['id'])){
				$adhoc_id = $this->request->data['Adhoc']['id'];
			}else if(isset($this->request->data['BatchSet']['id'])){
				$batchset_model = AppModel::getInstance("Datamart", "BatchSet", true);
				$batchset = $batchset_model->findById($this->request->data['BatchSet']['id']);
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
						$this->request->data = $this->ModelToSearch->query($query);
						$use_find = false;
					}else{
						require_once('customs/custom_adhoc_functions.php');
						$custom_adhoc_functions = new CustomAdhocFunctions();
						if(method_exists($custom_adhoc_functions, $adhoc['Adhoc']['function_for_results'])){
							$function = $adhoc['Adhoc']['function_for_results'];
							$this->request->data = $custom_adhoc_functions->$function($this, $ids);
							$use_find = false;
						}
					}
				}
				
				if($use_find){
					AppController::addWarningMsg(__('unable to use the batch set specified query'));
				}
			}
	
			if($use_find){
				$this->request->data = $this->ModelToSearch->find('all', array('conditions' => $model_name.".".$model_pkey." IN ('".implode("', '", $ids)."')"));
			}
			
			$this->set('csv_header', true);
			$this->Structures->set($structure_alias, 'result_structure');
			Configure::write('debug', 0);
			$this->layout = false;
		}
	}
}