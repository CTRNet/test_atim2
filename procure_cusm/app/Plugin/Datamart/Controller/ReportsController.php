<?php
class ReportsController extends DatamartAppController {
	var $uses = array(
		"Datamart.Report",
		"Datamart.DatamartStructure",
		"Datamart.BrowsingResult",
		"Datamart.BatchSet",
		"Structure");

	var $paginate = array('Report' => array('order' => 'Report.name ASC'));
	
	// -------------------------------------------------------------------------------------------------------------------
	// SELECT ELEMENTS vs BATCHSET OR NODE DISTRIBUTION (trunk report)
	// -------------------------------------------------------------------------------------------------------------------
	
	function compareToBatchSetOrNode($type_of_object_to_compare, $batch_set_or_node_id_to_compare, $csv_creation = false, $previous_current_node_id = null) {	
		
		// Get data of object to compare 
		$compared_object_datamart_structure_id = null;
		$compared_object_element_ids = array();
		$selected_object_title = null;
		switch($type_of_object_to_compare) {
			case 'batchset':
				// Get batch set data and check permissions on selected batch set
				$selected_batchset = $this->BatchSet->getOrRedirect($batch_set_or_node_id_to_compare);
				if(!$this->BatchSet->isUserAuthorizedToRw($selected_batchset, true)) return;
				if(!AppController::checkLinkPermission($selected_batchset['DatamartStructure']['index_link'])){
					$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
					return;
				}
				$compared_object_datamart_structure_id = $selected_batchset['DatamartStructure']['id'];
				foreach($selected_batchset['BatchId'] as $tmp) $compared_object_element_ids[] = $tmp['lookup_id'];
				$selected_object_title = 'batchset';
				break;
			case 'node':
				$selected_databrowser_node = $this->BrowsingResult->findById($batch_set_or_node_id_to_compare);
				$compared_object_datamart_structure_id = $selected_databrowser_node['DatamartStructure']['id'];
				$compared_object_element_ids = explode(',', $selected_databrowser_node['BrowsingResult']['id_csv']);
				$selected_object_title = 'databrowser node';
				break;
			default:
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Get selected elements of either previous batchset or report or databrowser node
		$selected_elements_datamart_structure_data = null;
		$previously_displayed_object_title = null;
		$tmp_node_of_selected_elements = null;
		if($previous_current_node_id) {
			// User just launched process to compare 2 nodes
			if(!empty($this->request->data)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			// Launched process from databrowser node on selected elements
			$tmp_node_of_selected_elements = $this->BrowsingResult->findById($previous_current_node_id);
			$selected_elements_datamart_structure_data = array('DatamartStructure' => $tmp_node_of_selected_elements['DatamartStructure']);
			$previously_displayed_object_title = 'databrowser node';
		} else if(empty($this->request->data)) {
			// Sort on displayed data based on selected field
			if(!array_key_exists('sort', $this->passedArgs))$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$selected_elements_datamart_structure_data = $this->DatamartStructure->findById($_SESSION['compareToBatchSetOrNode']['datamart_structure_id']);
			$previously_displayed_object_title = $_SESSION['compareToBatchSetOrNode']['previously_displayed_object_title'];
		} else if(array_key_exists('Config', $this->request->data) && $csv_creation) {
			// Export data in csv
			$config = array_merge($this->request->data['Config'], (array_key_exists(0, $this->request->data)? $this->request->data[0] : array()));
			unset($this->request->data[0]);
			unset($this->request->data['Config']);
			$this->configureCsv($config);
			$selected_elements_datamart_structure_data = $this->DatamartStructure->findById($_SESSION['compareToBatchSetOrNode']['datamart_structure_id']);
			$previously_displayed_object_title = $_SESSION['compareToBatchSetOrNode']['previously_displayed_object_title'];
		} else if(array_key_exists('Report', $this->request->data)) {
			// Launched process from report on selected elements
			$selected_elements_datamart_structure_data = $this->DatamartStructure->findById($this->request->data['Report']['datamart_structure_id']);
			$previously_displayed_object_title = 'report';
		} else if(array_key_exists('node', $this->request->data)) {
			// Launched process from databrowser node on selected elements
			$tmp_node_of_selected_elements = $this->BrowsingResult->findById($this->request->data['node']['id']);
			$selected_elements_datamart_structure_data = array('DatamartStructure' => $tmp_node_of_selected_elements['DatamartStructure']);
			$previously_displayed_object_title = 'databrowser node';
		} else if(array_key_exists('BatchSet', $this->request->data)) {
			// Launched process from previous batchset on selected elements
			$tmp_batchset_of_selected_elements = $this->BatchSet->getOrRedirect($this->request->data['BatchSet']['id']);
			if(!$this->BatchSet->isUserAuthorizedToRw($tmp_batchset_of_selected_elements, true)) return;
			$selected_elements_datamart_structure_data = array('DatamartStructure' => $tmp_batchset_of_selected_elements['DatamartStructure']);
			$previously_displayed_object_title = 'batchset';
		}
		
		// Get shared datamart structure
		if(!$selected_elements_datamart_structure_data || ($selected_elements_datamart_structure_data['DatamartStructure']['id'] != $compared_object_datamart_structure_id)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$datamart_structure = $selected_elements_datamart_structure_data['DatamartStructure']; // Same Datamart Structure
		$this->set('$datamart_structure_id', $datamart_structure['id']);
	
		// Get selected elements ids
		$model = null;
		$lookup_key_name = null;
		$model_instance = null;
		$control_foreign_key = null;
		$studied_element_ids_to_export = null;
		if($datamart_structure['control_master_model']){
			if(isset($this->request->data[$datamart_structure['model']])){
				$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
				$model = $datamart_structure['model'];
				$lookup_key_name = $model_instance->primaryKey;
			}else{
				$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['control_master_model'], true);
				$model = $datamart_structure['control_master_model'];
				$lookup_key_name = $model_instance->primaryKey;
			}
			$control_foreign_key = $model_instance->getControlForeign();
		}else{
			$model = $datamart_structure['model'];
			$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
			$lookup_key_name = $model_instance->primaryKey;
		}
		if($csv_creation) {
			// Export data to csv
			$studied_element_ids_to_export = $this->request->data[ $model ][ $lookup_key_name ];
			$this->request->data[ $model ][ $lookup_key_name ] = explode(",", $_SESSION['compareToBatchSetOrNode']['selected_elements_ids']);
			// Nothing to do, selected elements are already submitted by form and recorded into $this->request->data[ $model ][ $lookup_key_name ]
		} else if($tmp_node_of_selected_elements && ($previous_current_node_id || $this->request->data[ $model ][ $lookup_key_name ] == 'all')) {
			// Launched from node with elements > display limit or launched to compare 2 nodes: get all ids of node			
			$this->request->data[ $model ][ $lookup_key_name ] = explode(",", $tmp_node_of_selected_elements['BrowsingResult']['id_csv']);
		} else if(empty($this->request->data)) {
			// Sort data
			$this->request->data[ $model ][ $lookup_key_name ] = explode(",", $_SESSION['compareToBatchSetOrNode']['selected_elements_ids']);
		}
		$selected_elements_ids = array_filter($this->request->data[ $model ][ $lookup_key_name ]);
		
		//Get diff results
		$all_studied_elements = $model_instance->find('all', array('conditions' => array("$model.$lookup_key_name" => array_merge($compared_object_element_ids, $selected_elements_ids))));
		$elements_ids_just_in_selected_object = array_diff($compared_object_element_ids, $selected_elements_ids);
		$elements_ids_just_in_previously_disp_object = array_diff($selected_elements_ids, $compared_object_element_ids);
		$sorted_all_studied_elements = array('1'=>array(), '2'=>array(), '3'=>array());
		$control_master_ids =array();
		foreach($all_studied_elements as $new_studied_element) {	
			if($csv_creation && !in_array($new_studied_element[$model][$lookup_key_name], $studied_element_ids_to_export)) continue;
			if($control_foreign_key){
				$control_master_id = $new_studied_element[$model][$control_foreign_key];
				$control_master_ids[$control_master_id] = $control_master_id;
			}
			if(in_array($new_studied_element[$model][$lookup_key_name], $elements_ids_just_in_selected_object)) {
				$new_studied_element['Generated']['batchset_and_node_elements_distribution_description'] = str_replace('%s_2', $selected_object_title, __('data of selected %s_2 only (2)'));
				$sorted_all_studied_elements[3][] = $new_studied_element;
			} else if(in_array($new_studied_element[$model][$lookup_key_name], $elements_ids_just_in_previously_disp_object)) {
				$new_studied_element['Generated']['batchset_and_node_elements_distribution_description'] = str_replace('%s_1', $previously_displayed_object_title, __("data of previously displayed %s_1 only (1)"));
				$sorted_all_studied_elements[2][] = $new_studied_element;
			} else {
				$new_studied_element['Generated']['batchset_and_node_elements_distribution_description'] = str_replace(array('%s_1', '%s_2'), array($previously_displayed_object_title, $selected_object_title), __('data both in previously displayed %s_1 and selected %s_2 (1 & 2)'));
				$sorted_all_studied_elements[1][] = $new_studied_element;
			}
		}
		$diff_results_data = array_merge($sorted_all_studied_elements[1],$sorted_all_studied_elements[2],$sorted_all_studied_elements[3]);
		$this->set('diff_results_data', AppModel::sortWithUrl($diff_results_data, $this->passedArgs));
	
		//Manage structure for display
		$structure_alias = null;
		if($control_master_ids && (sizeof($control_master_ids) == 1)) {
			$control_master_id = array_shift($control_master_ids);
			AppModel::getInstance("Datamart", "Browser", true);
			$alternate_info = Browser::getAlternateStructureInfo($datamart_structure['plugin'], $model_instance->getControlName(), $control_master_id);
			$structure_alias = $alternate_info['form_alias'];
		} else {
			$this->Structure = AppModel::getInstance("", "Structure", true);
			$atim_structure_data = $this->Structure->find('first', array('conditions' => array('Structure.id' => $datamart_structure['structure_id']), 'recursive' => '-1'));
			$structure_alias = $atim_structure_data['structure']['Structure']['alias'];
		}
		$this->set('atim_structure_for_results', $this->Structures->get('form', 'batchset_and_node_elements_distribution,'.$structure_alias));
		$this->set('datamart_structure_id', $datamart_structure['id']);
		$this->set('type_of_object_to_compare', $type_of_object_to_compare);
		$this->set('batch_set_or_node_id_to_compare', $batch_set_or_node_id_to_compare);
		$this->set('csv_creation', $csv_creation);
		$this->set('header_1', str_replace('%s_1', $previously_displayed_object_title, __('data of previously displayed %s_1 (1)')));
		$this->set('header_2', str_replace('%s_2', $selected_object_title, __('data of selected %s_2 (2)')));

		if($csv_creation) {
			// CSV cretion
			Configure::write('debug', 0);
			$this->layout = false;
		} else {
			// Results display
			// - Manage drop down action
			$this->set('datamart_structure_model_name', $model);
			$this->set('datamart_structure_key_name', $lookup_key_name);
			if($datamart_structure['index_link']) $this->set('datamart_structure_links', $datamart_structure['index_link']);
			$datamart_structure_actions = $this->DatamartStructure->getDropdownOptions(
					$datamart_structure['plugin'],
					$datamart_structure['model'],
					$model_instance->primaryKey,
					null,
					$datamart_structure['model'],
					$model_instance->primaryKey);
			foreach($datamart_structure_actions as $key => $new_action) {
				if($new_action['value'] && strpos($new_action['value'], 'Datamart/Csv/csv')) unset($datamart_structure_actions[$key]);
			}
			$sort_args = array_key_exists('sort', $this->passedArgs)? 'sort:'.$this->passedArgs['sort'].'/direction:'.$this->passedArgs['direction'] : '';
			$csv_action = "javascript:setCsvPopup('Datamart/Reports/compareToBatchSetOrNode/$type_of_object_to_compare/$batch_set_or_node_id_to_compare/1/$sort_args');";
			$datamart_structure_actions[] = array(
					'label' => __('export as CSV file (comma-separated values)'),
					'value' => sprintf($csv_action, 0)
			);
			$datamart_structure_actions[] = array(
					'label'	=> __("initiate browsing"),
					'value'	=> "Datamart/Browser/batchToDatabrowser/".$datamart_structure['model']."/report/"
			);
			$this->set('datamart_structure_actions', $datamart_structure_actions);
			// - Add session data
			$_SESSION['compareToBatchSetOrNode'] = array(
					'datamart_structure_id' => $datamart_structure['id'],
					'previously_displayed_object_title' => $previously_displayed_object_title,
					'selected_elements_ids' => implode(",", $selected_elements_ids)
			);
		}
	}
	 
	// -------------------------------------------------------------------------------------------------------------------
	// CUSTOM REPORTS DISPLAY AND MANAGEMENT
	// -------------------------------------------------------------------------------------------------------------------
	
	function index(){
		$_SESSION['report'] = array(); // clear SEARCH criteria
		
		$this->request->data = $this->paginate($this->Report, array('Report.flag_active' => '1', 'Report.limit_access_from_datamart_structrue_function' => '0'));
		
		// Translate data
		foreach($this->request->data as $key => $data) {
			$this->request->data[$key]['Report']['name'] = __($this->request->data[$key]['Report']['name']);
			$this->request->data[$key]['Report']['description'] = __($this->request->data[$key]['Report']['description']);
		}
		
		$this->Structures->set("reports");
	}
	
	function manageReport($report_id, $csv_creation = false) {
		// Get report data
		$report = $this->Report->find('first',array('conditions' => array('Report.id' => $report_id, 'Report.flag_active' => '1')));		
		if(empty($report) 
		|| empty($report['Report']['function'])
		|| empty($report['Report']['form_alias_for_results'])
		|| empty($report['Report']['form_type_for_results'])
		|| ($report['Report']['form_type_for_results'] != 'index' && !empty($report['Report']['associated_datamart_structure_id']))) {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Set menu variables
		$this->set( 'atim_menu_variables', array('Report.id' => $report_id));
		$this->set('atim_menu', $this->Menus->get('/Datamart/Reports/manageReport/%%Report.id%%/'));
		
		if($report['Report']['limit_access_from_datamart_structrue_function'] && empty($this->request->data) && (!$csv_creation) && !array_key_exists('sort', $this->passedArgs)) {
			$this->flash(__('the selected report can only be launched from a batchset or a databrowser node'), "/Datamart/Reports/index", 5);
			
		} else if(empty($this->request->data) && (!empty($report['Report']['form_alias_for_search'])) && (!$csv_creation) && !array_key_exists('sort', $this->passedArgs)) {
			
			// ** SEARCH FROM DISPLAY **
			
			$this->Structures->set($report['Report']['form_alias_for_search'], 'search_form_structure');	
			$_SESSION['report'][$report_id]['search_criteria'] = array(); // clear SEARCH criteria		
			$_SESSION['report'][$report_id]['sort_criteria'] = array(); // clear SEARCH criteria	
		
		} else {
			
			// ** RESULTS/ACTIONS MANAGEMENT **
			
			$linked_datamart_structure = null;
			$LinkedModel = null;
			if($report['Report']['form_type_for_results'] == 'index' && $report['Report']['associated_datamart_structure_id']) {
				// Load linked structure and model if required
				$linked_datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array("DatamartStructure.id" => $report['Report']['associated_datamart_structure_id'])));
				if(empty($linked_datamart_structure)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$LinkedModel = AppModel::getInstance($linked_datamart_structure['DatamartStructure']['plugin'], $linked_datamart_structure['DatamartStructure']['model'], true);
				$this->set('linked_datamart_structure_id', $report['Report']['associated_datamart_structure_id']);
			}
			
			// Set criteria to build report/csv
			$criteria_to_build_report = null;
			$criteria_to_sort_report = array();
			if($csv_creation) {		
				if(array_key_exists('Config', $this->request->data)) {
					$config = array_merge($this->request->data['Config'], (array_key_exists(0, $this->request->data)? $this->request->data[0] : array()));
					unset($this->request->data[0]);
					unset($this->request->data['Config']);
					$this->configureCsv($config);
				}
				// Get criteria from session data for csv 
				$criteria_to_build_report = $_SESSION['report'][$report_id]['search_criteria'];
				$criteria_to_sort_report = isset($_SESSION['report'][$report_id]['sort_criteria'])? $_SESSION['report'][$report_id]['sort_criteria'] : array();
				if($LinkedModel && isset($this->request->data[$linked_datamart_structure['DatamartStructure']['model']][$LinkedModel->primaryKey])) {
					// Take care about selected items (the number of records did not reach the limit of items that could be displayed)
					$ids = array_filter($this->request->data[$linked_datamart_structure['DatamartStructure']['model']][$LinkedModel->primaryKey]);
					if(!empty($ids)) {
						$criteria_to_build_report['SelectedItemsForCsv'][$linked_datamart_structure['DatamartStructure']['model']][$LinkedModel->primaryKey] = $ids;
					}
				}
			} else if(array_key_exists('sort', $this->passedArgs)) {
				// Data sort: Get criteria from session data
				$criteria_to_build_report = $_SESSION['report'][$report_id]['search_criteria'];
				$criteria_to_sort_report = array('sort' => $this->passedArgs['sort'], 'direction' => $this->passedArgs['direction']);
				$_SESSION['report'][$report_id]['sort_criteria'] = $criteria_to_sort_report;
			} else {
				// Get criteria from search form
				$criteria_to_build_report = empty($this->request->data)? array() : $this->request->data;
				// Manage data from csv file			
				foreach($criteria_to_build_report as $model => $fields_parameters) {
					if(!($model == 'exact_search' && !is_array($fields_parameters))) {
						foreach($fields_parameters as $field => $parameters) {
							if(preg_match('/^(.+)_with_file_upload$/', $field, $matches)) {
								$matched_field_name = $matches[1];
								if(!isset($criteria_to_build_report[$model][$matched_field_name])) $criteria_to_build_report[$model][$matched_field_name] = array();
								if(strlen($parameters['tmp_name'])) {
									if(!preg_match('/((\.txt)|(\.csv))$/', $parameters['name'])) {
										$this->redirect('/Pages/err_submitted_file_extension', null, true);
									} else {
										$handle = fopen($parameters['tmp_name'], "r");
										if($handle) {
											while (($csv_data = fgetcsv($handle, 1000, csv_separator, '"')) !== FALSE) {
												$criteria_to_build_report[$model][$matched_field_name][] = $csv_data[0];
											}
											fclose($handle);
										} else {
											$this->redirect('/Pages/err_opening_submitted_file', null, true);
										}
									}
								}
								unset($criteria_to_build_report[$model][$field]);
							}
						}
					}
				}	
				
				// Manage data when launched from databrowser node having a nbr of elements > databrowser_and_report_results_display_limit
				if(array_key_exists('node', $criteria_to_build_report)) {
					$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $criteria_to_build_report['node']['id'])));
					$datamart_structure = $browsing_result['DatamartStructure'];
					if(empty($browsing_result) || empty($datamart_structure)) {
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					// Get model and key name
					$model = null;
					$lookup_key_name = null;
					if($datamart_structure['control_master_model']){
						if(isset($criteria_to_build_report[$datamart_structure['model']])){
							$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
							$model = $datamart_structure['model'];
							$lookup_key_name = $model_instance->primaryKey;
						}else{
							$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['control_master_model'], true);
							$model = $datamart_structure['control_master_model'];
							$lookup_key_name = $model_instance->primaryKey;
						}	
					}else{
						$model = $datamart_structure['model'];
						$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
						$lookup_key_name = $model_instance->primaryKey;
					}
					if($criteria_to_build_report[ $model ][ $lookup_key_name ] == 'all') $criteria_to_build_report[ $model ][ $lookup_key_name ] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
				}
				// Load search criteria in session
				$_SESSION['report'][$report_id]['search_criteria'] = $criteria_to_build_report;
			}
		
			// Get and manage results
			$data_returned_by_fct = call_user_func_array(array($this , $report['Report']['function']), array($criteria_to_build_report));
			if(empty($data_returned_by_fct) 
			|| (!array_key_exists('header', $data_returned_by_fct))
			|| (!array_key_exists('data', $data_returned_by_fct)) 
			|| (!array_key_exists('columns_names', $data_returned_by_fct)) 
			|| (!array_key_exists('error_msg', $data_returned_by_fct))) {
				// Wrong array keys returned by custom function
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			} else if(!empty($data_returned_by_fct['error_msg'])) {
				// Error detected by custom function -> Display custom error message with empty form
				$this->request->data = array();
				$this->Structures->set('empty', 'result_form_structure');
				$this->set('result_form_type', 'index');
				$this->set('display_new_search', (empty($report['Report']['form_alias_for_search']) || $report['Report']['limit_access_from_datamart_structrue_function'])? false:true);
				$this->set('csv_creation', false);
				$this->Report->validationErrors[][] = $data_returned_by_fct['error_msg'];
			
			} else if(sizeof($data_returned_by_fct['data']) > Configure::read('databrowser_and_report_results_display_limit') && !$csv_creation) {
				// Too many results
				$this->request->data = array();
				$this->Structures->set('empty', 'result_form_structure');
				$this->set('result_form_type', 'index');
				$this->set('display_new_search', (empty($report['Report']['form_alias_for_search']) || $report['Report']['limit_access_from_datamart_structrue_function'])? false:true);
				$this->set('csv_creation', false);			
				$this->Report->validationErrors[][] = __('the report contains too many results - please redefine search criteria').' ['.sizeof($data_returned_by_fct['data']).' '.__('lines').']';
				
			} else {
				// Set data for display/csv		
				$this->request->data = AppModel::sortWithUrl($data_returned_by_fct['data'], $criteria_to_sort_report);
				$this->Structures->set($report['Report']['form_alias_for_results'], 'result_form_structure');
				$this->set('result_form_type', $report['Report']['form_type_for_results']);
				$this->set('result_header', $data_returned_by_fct['header']);
				$this->set('result_columns_names', $data_returned_by_fct['columns_names']);
				$this->set('display_new_search', (empty($report['Report']['form_alias_for_search']) || $report['Report']['limit_access_from_datamart_structrue_function'])? false:true);
				$this->set('csv_creation', $csv_creation);
				
				if($csv_creation) {
					Configure::write('debug', 0);
					$this->layout = false;
					
				} else if($linked_datamart_structure) {	
					//Code to be able to launch actions from report linked to structure and model
					$this->set('linked_datamart_structure_model_name', $linked_datamart_structure['DatamartStructure']['model']);
					$this->set('linked_datamart_structure_key_name', $LinkedModel->primaryKey);
					if($linked_datamart_structure['DatamartStructure']['index_link']) 	$this->set('linked_datamart_structure_links', $linked_datamart_structure['DatamartStructure']['index_link']);
					$linked_datamart_structure_actions = $this->DatamartStructure->getDropdownOptions(
						$linked_datamart_structure['DatamartStructure']['plugin'],
						$linked_datamart_structure['DatamartStructure']['model'], 
						$LinkedModel->primaryKey, 
						null, 
						null, 
						null, 
						null,
						false);
					$csv_action = "javascript:setCsvPopup('Datamart/Reports/manageReport/$report_id/1/');";
					$linked_datamart_structure_actions[] = array(
							'value' => '0',
							'label' => __('export as CSV file (comma-separated values)'),
							'value' => sprintf($csv_action, 0)
					);
					$linked_datamart_structure_actions[] = array(
						'label'	=> __("initiate browsing"),
						'value'	=> "Datamart/Browser/batchToDatabrowser/".$linked_datamart_structure['DatamartStructure']['model']."/report/"
					);
					$this->set('linked_datamart_structure_actions', $linked_datamart_structure_actions);
				}
			}
		}
	}

	// -------------------------------------------------------------------------------------------------------------------
	// FUNCTIONS ADDED TO THE CONTROLLER AS CUSTOM REPORT EXAMPLES
	// -------------------------------------------------------------------------------------------------------------------
	
	function bankActiviySummary($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		$header = array(
			'title' => __('from').' '.(empty($parameters[0]['report_date_range_start']['year'])?'?':$start_date_for_display).' '.__('to').' '.(empty($parameters[0]['report_date_range_end']['year'])?'?':$end_date_for_display), 
			'description' => 'n/a');

		// 2- Search data
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');

		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		// Get new participant
		if(!isset($this->Participant)) {
			$this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		}
		$conditions = $search_on_date_range? array("Participant.created >= '$start_date_for_sql'", "Participant.created <= '$end_date_for_sql'") : array();
		$data['0']['new_participants_nbr'] = $this->Participant->find('count', (array('conditions' => $conditions)));		

		// Get new consents obtained
		if(!isset($this->ConsentMaster)) {
			$this->ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
		}
		$conditions = $search_on_date_range? array("ConsentMaster.consent_signed_date >= '$start_date_for_sql'", "ConsentMaster.consent_signed_date <= '$end_date_for_sql'") : array();
		$all_consent = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));
		$conditions['ConsentMaster.consent_status'] = 'obtained';
		$all_obtained_consent = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));
		$data['0']['obtained_consents_nbr'] = "$all_obtained_consent/$all_consent";
		
		// Get new collections
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$new_collections_nbr = $this->Report->tryCatchQuery(
			"SELECT COUNT(*) FROM (
				SELECT DISTINCT col.participant_id 
				FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				WHERE col.participant_id IS NOT NULL 
				AND col.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res;");
		$data['0']['new_collections_nbr'] = $new_collections_nbr[0][0]['COUNT(*)'];
		
		$array_to_return = array(
			'header' => $header, 
			'data' => $data, 
			'columns_names' => null,
			'error_msg' => null);
		
		return $array_to_return;
	}
	
	function sampleAndDerivativeCreationSummary($parameters) {
		if(!AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
			
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_datetime_range_start']['year'], $parameters[0]['report_datetime_range_start']['month'], $parameters[0]['report_datetime_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_datetime_range_end']['year'], $parameters[0]['report_datetime_range_end']['month'], $parameters[0]['report_datetime_range_end']['day']);
		
		$header = array(
			'title' => __('from').' '.(empty($parameters[0]['report_datetime_range_start']['year'])?'?':$start_date_for_display).' '.__('to').' '.(empty($parameters[0]['report_datetime_range_end']['year'])?'?':$end_date_for_display), 
			'description' => 'n/a');
		
		$bank_ids = array();
		if(isset($parameters[0]['bank_id'])) {
			foreach($parameters[0]['bank_id'] as $bank_id) if(!empty($bank_id)) $bank_ids[] = $bank_id;
			if(!empty($bank_ids)) {
				$Bank = AppModel::getInstance("Administrate", "Bank", true);
				$bank_list = $Bank->find('all', array('conditions' => array('id' => $bank_ids)));
				$bank_names = array();
				foreach($bank_list as $new_bank) $bank_names[] = $new_bank['Bank']['name'];
				$header['description'] = __('bank'). ': '.implode(',',$bank_names);
			}	
		}

		// 2- Search data
		
		$bank_conditions = empty($bank_ids)? 'TRUE' : 'col.bank_id IN ('. implode(',',$bank_ids).')';
			
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_end'], 'end');
		
		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		$res_final = array();
		$tmp_res_final = array();
		
		// Work on specimen
		
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$res_samples = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), sc.sample_type
			FROM sample_masters AS sm
			INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
			INNER JOIN collections AS col ON col.id = sm.collection_id
			WHERE col.participant_id IS NOT NULL
			AND col.participant_id != '0'
			AND sc.sample_category = 'specimen'
			AND ($conditions)
			AND ($bank_conditions)
			AND sm.deleted != '1'
			GROUP BY sample_type;"
		);		
		$res_participants = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), res.sample_type FROM (
				SELECT DISTINCT col.participant_id, sc.sample_type
				FROM sample_masters AS sm
				INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
				INNER JOIN collections AS col ON col.id = sm.collection_id
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND sc.sample_category = 'specimen'
				AND ($conditions)
				AND ($bank_conditions)
				AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;"
		);		
		
		foreach($res_samples as $data) {
			$tmp_res_final['specimen-'.$data['sc']['sample_type']] = array(
				'SampleControl' => array('sample_category' => 'specimen', 'sample_type'=> $data['sc']['sample_type']),
				'0' => array('created_samples_nbr' => $data[0]['COUNT(*)'], 'matching_participant_number' => null));
		}
		foreach($res_participants as $data) {
			$tmp_res_final['specimen-'.$data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
		}
		
		// Work on derivative
		
		$conditions = $search_on_date_range? "der.creation_datetime >= '$start_date_for_sql' AND der.creation_datetime <= '$end_date_for_sql'" : 'TRUE';
		$res_samples = $this->Report->tryCatchQuery(
				"SELECT COUNT(*), sc.sample_type
				FROM sample_masters AS sm
				INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
				INNER JOIN collections AS col ON col.id = sm.collection_id
				INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND sc.sample_category = 'derivative'
				AND ($conditions)
				AND ($bank_conditions)
				AND sm.deleted != '1'
				GROUP BY sample_type;"
		);
		$res_participants = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), res.sample_type FROM (
					SELECT DISTINCT col.participant_id, sc.sample_type
					FROM sample_masters AS sm
					INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
					INNER JOIN collections AS col ON col.id = sm.collection_id
					INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id
					WHERE col.participant_id IS NOT NULL
					AND col.participant_id != '0'
					AND sc.sample_category = 'derivative'
					AND ($conditions)
					AND ($bank_conditions)
					AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;"
		);
	
		foreach($res_samples as $data) {
			$tmp_res_final['derivative-'.$data['sc']['sample_type']] = array(
					'SampleControl' => array('sample_category' => 'derivative', 'sample_type'=> $data['sc']['sample_type']),
					'0' => array('created_samples_nbr' => $data[0]['COUNT(*)'], 'matching_participant_number' => null));
		}
		foreach($res_participants as $data) {
			$tmp_res_final['derivative-'.$data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
		}		
		
		// Format data for report
		foreach($tmp_res_final as $new_sample_type_data) {
			$res_final[] = $new_sample_type_data;
		}	
			
		$array_to_return = array(
			'header' => $header, 
			'data' => $res_final, 
			'columns_names' => null,
			'error_msg' => null);
		
		return $array_to_return;		
	}
	
	function bankActiviySummaryPerPeriod($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		if(empty($parameters[0]['report_date_range_period'])) {
			return array('error_msg' => 'no period has been defined', 'header' => null, 'data' => null, 'columns_names' => null);		
		}
		$month_period = ($parameters[0]['report_date_range_period'] == 'month')? true:false;
		
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		$header = array(
			'title' => __('from').' '.(empty($parameters[0]['report_date_range_start']['year'])?'?':$start_date_for_display).' '.__('to').' '.(empty($parameters[0]['report_date_range_end']['year'])?'?':$end_date_for_display), 
			'description' => 'n/a');

		// 2- Search data
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');

		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		$arr_format_month_to_string = AppController::getCalInfo(false);
		
		$tmp_res = array();
		$date_key_list = array();
		
		// Get new participant
		$conditions = $search_on_date_range? "Participant.created >= '$start_date_for_sql' AND Participant.created <= '$end_date_for_sql'" : 'TRUE';
		$participant_res = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), YEAR(Participant.created) AS created_year".($month_period? ", MONTH(Participant.created) AS created_month": "").
			" FROM participants AS Participant 
			WHERE ($conditions) AND Participant.deleted != 1 
			GROUP BY created_year".($month_period? ", created_month": "").";");
		foreach($participant_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown');
			if(!empty($new_data['0']['created_year'])) {
				if($month_period) {
					$date_key = $new_data['0']['created_year']."-".((strlen($new_data['0']['created_month']) == 1)?"0":"").$new_data['0']['created_month'];
					$date_value = $arr_format_month_to_string[$new_data['0']['created_month']].' '.$new_data['0']['created_year'];
				} else {
					$date_key = $new_data['0']['created_year'];
					$date_value = $new_data['0']['created_year'];
				}
			}
			
			$date_key_list[$date_key] = $date_value;
			$tmp_res['0']['new_participants_nbr'][$date_value] = $new_data['0']['COUNT(*)'];
		}

		// Get new consents obtained
		$conditions = $search_on_date_range? "ConsentMaster.consent_signed_date >= '$start_date_for_sql' AND ConsentMaster.consent_signed_date <= '$end_date_for_sql'" : 'TRUE';
		$consent_res = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), YEAR(ConsentMaster.consent_signed_date) AS signed_year".($month_period? ", MONTH(ConsentMaster.consent_signed_date) AS signed_month": "").
			" FROM consent_masters AS ConsentMaster
			WHERE ($conditions) AND ConsentMaster.deleted != 1 
			GROUP BY signed_year".($month_period? ", signed_month": "").";");
		foreach($consent_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown');
			if(!empty($new_data['0']['signed_year'])) {
				if($month_period) {
					$date_key = $new_data['0']['signed_year']."-".((strlen($new_data['0']['signed_month']) == 1)?"0":"").$new_data['0']['signed_month'];
					$date_value = $arr_format_month_to_string[$new_data['0']['signed_month']].' '.$new_data['0']['signed_year'];
				} else {
					$date_key = $new_data['0']['signed_year'];
					$date_value = $new_data['0']['signed_year'];
				}
			}
			
			$date_key_list[$date_key] = $date_value;
			$tmp_res['0']['obtained_consents_nbr'][$date_value] = $new_data['0']['COUNT(*)'];
		}
		
		// Get new collections
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$collection_res = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), res.collection_year".($month_period? ", res.collection_month": "")." FROM (
				SELECT DISTINCT col.participant_id, YEAR(col.collection_datetime) AS collection_year".($month_period? ", MONTH(col.collection_datetime) AS collection_month": "").
				" FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				WHERE col.participant_id IS NOT NULL 
				AND col.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res
			GROUP BY res.collection_year".($month_period? ", res.collection_month": "").";");
		foreach($collection_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown');
			if(!empty($new_data['res']['collection_year'])) {
				if($month_period) {
					$date_key = $new_data['res']['collection_year']."-".((strlen($new_data['res']['collection_month']) == 1)?"0":"").$new_data['res']['collection_month'];
					$date_value = $arr_format_month_to_string[$new_data['res']['collection_month']].' '.$new_data['res']['collection_year'];
				} else {
					$date_key = $new_data['res']['collection_year'];
					$date_value = $new_data['res']['collection_year'];
				}
			}
			
			$date_key_list[$date_key] = $date_value;
			$tmp_res['0']['new_collections_nbr'][$date_value] = $new_data['0']['COUNT(*)'];
		}
			
		ksort($date_key_list);
		$error_msg = null;
		if(sizeof($date_key_list) > 20) {
			$error_msg = 'number of report columns will be too big, please redefine parameters';
		}
			
		$array_to_return = array(
			'header' => $header, 
			'data' => $tmp_res,
			'columns_names' => array_values($date_key_list),
			'error_msg' => $error_msg);
		
		return $array_to_return;
	}
	
	function ctrnetCatalogueSubmissionFile($parameters) {
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
			
		// 1- Build Header
		$header = array(
				'title' => __('report_ctrnet_catalogue_name'),
				'description' => 'n/a');
	
		$bank_ids = array();
		if(isset($parameters[0]['bank_id'])) {
			foreach($parameters[0]['bank_id'] as $bank_id) if(!empty($bank_id)) $bank_ids[] = $bank_id;
			if(!empty($bank_ids)) {
				$Bank = AppModel::getInstance("Administrate", "Bank", true);
				$bank_list = $Bank->find('all', array('conditions' => array('id' => $bank_ids)));
				$bank_names = array();
				foreach($bank_list as $new_bank) $bank_names[] = $new_bank['Bank']['name'];
				$header['title'] .= ' ('.__('bank'). ': '.implode(',', $bank_names).')';
			}
		}
		
		// 2- Search data
	
		$bank_conditions = empty($bank_ids)? 'TRUE' : 'col.bank_id IN ('. implode(',',$bank_ids).')';
		$aliquot_type_confitions = $parameters[0]['include_core_and_slide'][0]? 'TRUE' : "ac.aliquot_type NOT IN ('core','slide')";
		$whatman_paper_confitions = $parameters[0]['include_whatman_paper'][0]? 'TRUE' : "ac.aliquot_type NOT IN ('whatman paper')";
		$detail_other_count = $parameters[0]['detail_other_count'][0]? true : false;
				
		$data = array();
				
		// **all**
		
		$tmp_data = array('sample_type' => __('total'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' 
				AND ($bank_conditions)
				AND ($aliquot_type_confitions) 
				AND am.in_stock IN ('yes - available ','yes - not available')
			) AS res;";		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];

		$data[] = $tmp_data;
		
		// **FFPE**
		
		$tmp_data = array('sample_type' => __('FFPE'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => __('tissue').' '.__('block').' ('.__('paraffin').')');
		
		$sql = "	
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				INNER JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ac.aliquot_type = 'block'
				AND blk.block_type = 'paraffin'
			) AS res;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];
		
		$data[] = $tmp_data;
		
		// **frozen tissue**
		
		$tmp_data = array('sample_type' => __('frozen tissue'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ($aliquot_type_confitions) 
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
			) AS res;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];
		
		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type,blk.block_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			LEFT JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type IN ('tissue')
				AND ($aliquot_type_confitions) 
			AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
		$query_results = $this->Report->tryCatchQuery($sql);		
		foreach($query_results as $new_type) $tmp_data['notes'] .= (empty($tmp_data['notes'])? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']).(empty($new_type['blk']['block_type'])? '' : ' ('.__($new_type['blk']['block_type']).')');

		$data[] = $tmp_data;		
		
		// **blood**
		// **pbmc**
		// **buffy coat**
		// **blood cell**
		// **plasma**
		// **serum**
		// **rna**
		// **dna**
		// **cell culture**
		
		$sample_types = "'blood', 'pbmc', 'buffy coat',  'blood cell', 'plasma', 'serum', 'rna', 'dna', 'cell culture'";
		
		$tmp_data = array();
		$sql = "
			SELECT count(*) AS nbr,sample_type, aliquot_type FROM (
				SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ($sample_types)
				AND ($whatman_paper_confitions)	
			) AS res GROUP BY sample_type, aliquot_type;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_res) {
			$sample_type = $new_res['res']['sample_type'];
			$aliquot_type = $new_res['res']['aliquot_type'];
			$tmp_data[$sample_type.$aliquot_type] = array('sample_type' => __($sample_type).' '.__($aliquot_type), 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => '');
		}
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_res) {
			$sample_type = $new_res['res']['sample_type'];
			$aliquot_type = $new_res['res']['aliquot_type'];
			$tmp_data[$sample_type.$aliquot_type]['aliquots_nbr'] = $new_res[0]['nbr'];
			$data[] = $tmp_data[$sample_type.$aliquot_type];
		}
		
		// **Urine**	

		$tmp_data = array('sample_type' => __('urine'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%urine%'
			) AS res;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];
		
		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%urine%'";
		$query_results = $this->Report->tryCatchQuery($sql);
		foreach($query_results as $new_type) $tmp_data['notes'] .= (empty($tmp_data['notes'])? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);
		
		$data[] = $tmp_data;
		
		// **Ascite**
		
		$tmp_data = array('sample_type' => __('ascite'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%ascite%'
			) AS res;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
				$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];

		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%ascite%'";
		$query_results = $this->Report->tryCatchQuery($sql);
		foreach($query_results as $new_type) $tmp_data['notes'] .= (empty($tmp_data['notes'])? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);		

		$data[] = $tmp_data;
		
		// **other**
		
		$other_conditions = "sc.sample_type NOT LIKE '%ascite%' AND sc.sample_type NOT LIKE '%urine%' AND sc.sample_type NOT IN ('tissue', $sample_types)";
		
		if($detail_other_count) {
			
			$tmp_data = array();
			$sql = "
				SELECT count(*) AS nbr,sample_type, aliquot_type FROM (
					SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($other_conditions)
				) AS res GROUP BY sample_type, aliquot_type;";
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			foreach($query_results as $new_res) {
				$sample_type = $new_res['res']['sample_type'];
				$aliquot_type = $new_res['res']['aliquot_type'];
				$tmp_data[$sample_type.$aliquot_type] = array('sample_type' => __($sample_type).' '.__($aliquot_type), 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => '');
			}
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
			foreach($query_results as $new_res) {
				$sample_type = $new_res['res']['sample_type'];
				$aliquot_type = $new_res['res']['aliquot_type'];
				$tmp_data[$sample_type.$aliquot_type]['aliquots_nbr'] = $new_res[0]['nbr'];
				$data[] = $tmp_data[$sample_type.$aliquot_type];
			}			

		} else {
			
			$tmp_data = array('sample_type' => __('other'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
			$sql = "
				SELECT count(*) AS nbr FROM (
					SELECT DISTINCT  %%id%%
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($other_conditions)
				) AS res;";
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
			
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
					$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];
			
			$sql = "
				SELECT DISTINCT sc.sample_type,ac.aliquot_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND ($other_conditions)";
			$query_results = $this->Report->tryCatchQuery($sql);
			foreach($query_results as $new_type) $tmp_data['notes'] .= (empty($tmp_data['notes'])? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);
			
			$data[] = $tmp_data;
		}
		
		
		// Format data form display
		
		$final_data = array();
		foreach($data as $new_row) {
			if($new_row['cases_nbr']) {
				$final_data[][0] = $new_row;
			}
		}

		$array_to_return = array(
			'header' => $header,
			'data' => $final_data,
			'columns_names' => null,
			'error_msg' => null);
	
		return $array_to_return;
	}
	
	function participantIdentifiersSummary($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$header = null;
		$conditions = array();
		
		if(isset($parameters['SelectedItemsForCsv']['Participant']['id'])) $parameters['Participant']['id'] = $parameters['SelectedItemsForCsv']['Participant']['id'];
		if(isset($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions['Participant.id'] = $participant_ids;	
		} else if(isset($parameters['Participant']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['Participant']['participant_identifier_start']))? $parameters['Participant']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['Participant']['participant_identifier_end']))? $parameters['Participant']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "Participant.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "Participant.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions['Participant.participant_identifier'] = $participant_identifiers;
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$misc_identifier_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
// *** NOTE: It's user choice to display report in csv whatever the number of records ***
//		$tmp_res_count = $misc_identifier_model->find('count', array('conditions' => $conditions, 'order' => array('MiscIdentifier.participant_id ASC')));	
// 		if($tmp_res_count > Configure::read('databrowser_and_report_results_display_limit')) {
// 			return array(
// 					'header' => null,
// 					'data' => null,
// 					'columns_names' => null,
// 					'error_msg' => 'the report contains too many results - please redefine search criteria');
// 		}
		$misc_identifiers = $misc_identifier_model->find('all', array('conditions' => $conditions, 'order' => array('MiscIdentifier.participant_id ASC')));
		$data = array();
		foreach($misc_identifiers as $new_ident){
			$participant_id = $new_ident['Participant']['id'];
			if(!isset($data[$participant_id])) {
				$data[$participant_id] = array(
					'Participant' => array(
						'id' => $new_ident['Participant']['id'],
						'participant_identifier' => $new_ident['Participant']['participant_identifier'],
						'first_name' => $new_ident['Participant']['first_name'],
						'last_name' => $new_ident['Participant']['last_name']),
					'0' => array(
						'BR_Nbr' => null,
						'PR_Nbr' => null,
						'hospital_number' => null)
				);
			}
			$data[$participant_id]['0'][str_replace(array(' ', '-'), array('_','_'), $new_ident['MiscIdentifierControl']['misc_identifier_name'])] = $new_ident['MiscIdentifier']['identifier_value'];
		}
		
		return array(
				'header' => $header,
				'data' => $data,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function getAllDerivatives($parameters) {
		if(!AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$header = null;
		$conditions = array();
		// Get Parameters
		if(isset($parameters['SampleMaster']['sample_code'])) {
			//From databrowser
			$selection_labels  = array_filter($parameters['SampleMaster']['sample_code']);
			if($selection_labels) $conditions['SampleMaster.sample_code'] = $selection_labels;
		} else if(isset($parameters['ViewSample']['sample_master_id'])) {
			//From databrowser
			$sample_master_ids  = array_filter($parameters['ViewSample']['sample_master_id']);
			if($sample_master_ids) $conditions['SampleMaster.id'] = $sample_master_ids;
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		// Load Model
		$view_sample_model = AppModel::getInstance("InventoryManagement", "ViewSample", true);
		$sample_master_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		// Build Res
		$sample_master_model->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')));
		$tmp_res_count =  $sample_master_model->find('count', array('conditions' => $conditions, 'fields' => array('SampleMaster.*', 'SampleControl.*'), 'order' => array('SampleMaster.sample_code ASC'), 'recursive' => '0'));
// *** NOTE: Has to control the number of record because the next report code lines can be really time and memory consuming ***
		if($tmp_res_count > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => __('the report contains too many results - please redefine search criteria')." [> $tmp_res_count ".__('lines').']');
		}
		$studied_samples = $sample_master_model->find('all', array('conditions' => $conditions, 'fields' => array('SampleMaster.*', 'SampleControl.*'), 'order' => array('SampleMaster.sample_code ASC'), 'recursive' => '0'));
		$res = array();
		foreach($studied_samples as $new_studied_sample) {		
			$all_derivatives_samples = $this->getChildrenSamples($view_sample_model, array($new_studied_sample['SampleMaster']['id']));
			if($all_derivatives_samples){
				foreach($all_derivatives_samples as $new_derivative_sample) {
					if(array_key_exists('SelectedItemsForCsv', $parameters) && !in_array($new_derivative_sample['ViewSample']['sample_master_id'], $parameters['SelectedItemsForCsv']['ViewSample']['sample_master_id'])) continue;
					$res[] = array_merge($new_studied_sample, $new_derivative_sample);
				}
			}
		}
		return array(
				'header' => $header,
				'data' => $res,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function getChildrenSamples($view_sample_model, $parent_sample_ids = array()){
		if(!AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		if(!empty($parent_sample_ids)) {
			//$view_sample_model->unbindModel(array('hasMany' => array('AliquotMaster')));
			$children_samples = $view_sample_model->find('all', array('conditions' => array('ViewSample.parent_id' => $parent_sample_ids), 'fields' => array('ViewSample.*, DerivativeDetail.*'), 'order' => array('ViewSample.sample_code ASC'), 'recursive' => '0'));
			$children_sample_ids = array();
			foreach($children_samples as $tmp_sample) $children_sample_ids[] = $tmp_sample['ViewSample']['sample_master_id'];
			$sub_children_samples = $this->getChildrenSamples($view_sample_model, $children_sample_ids);
			return array_merge($children_samples, $sub_children_samples);
		}
		return array();
	}
	
	function getAllSpecimens($parameters) {
		if(!AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$header = null;
		$conditions = array("SampleMaster.id != SampleMaster.initial_specimen_sample_id");
		// Get Parameters
		if(isset($parameters['SampleMaster']['sample_code'])) {
			//From databrowser
			$selection_labels  = array_filter($parameters['SampleMaster']['sample_code']);
			if($selection_labels) $conditions['SampleMaster.sample_code'] = $selection_labels;
		} else if(isset($parameters['ViewSample']['sample_master_id'])) {
			//From databrowser
			$sample_master_ids  = array_filter($parameters['ViewSample']['sample_master_id']);
			if($sample_master_ids) $conditions['SampleMaster.id'] = $sample_master_ids;
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		// Load Model
		$view_sample_model = AppModel::getInstance("InventoryManagement", "ViewSample", true);
		$sample_master_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		// Build Res
		$sample_master_model->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')));
		$tmp_res_count = $sample_master_model->find('count', array('conditions' => $conditions, 'fields' => array('SampleMaster.*', 'SampleControl.*'), 'order' => array('SampleMaster.sample_code ASC'), 'recursive' => '0'));
// *** NOTE: Has to control the number of record because the next report code lines can be really time and memory consuming ***
		if($tmp_res_count > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => __('the report contains too many results - please redefine search criteria')." [> $tmp_res_count ".__('lines').']');
		}
		$studied_samples = $sample_master_model->find('all', array('conditions' => $conditions, 'fields' => array('SampleMaster.*', 'SampleControl.*'), 'order' => array('SampleMaster.sample_code ASC'), 'recursive' => '0'));
		$res = array();
		$tmp_initial_specimens = array();
		foreach($studied_samples as $new_studied_sample) {
			$initial_specimen = isset($tmp_initial_specimens[$new_studied_sample['SampleMaster']['initial_specimen_sample_id']])? 
				$tmp_initial_specimens[$new_studied_sample['SampleMaster']['initial_specimen_sample_id']]:
				$view_sample_model->find('first', array('conditions' => array('ViewSample.sample_master_id' => $new_studied_sample['SampleMaster']['initial_specimen_sample_id']), 'fields' => array('ViewSample.*, SpecimenDetail.*'), 'order' => array('ViewSample.sample_code ASC'), 'recursive' => '0'));
			$tmp_initial_specimens[$new_studied_sample['SampleMaster']['initial_specimen_sample_id']] = $initial_specimen;	
			if($initial_specimen){
				if(!(array_key_exists('SelectedItemsForCsv', $parameters) && !in_array($initial_specimen['ViewSample']['sample_master_id'], $parameters['SelectedItemsForCsv']['ViewSample']['sample_master_id']))) $res[] = array_merge($new_studied_sample, $initial_specimen);
			}
		}
		return array(
				'header' => $header,
				'data' => $res,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function getAllChildrenStorage($parameters) {
		if(!AppController::checkLinkPermission('/StorageLayout/StorageMasters/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$header = null;
		$conditions = array();	
		// Get Parameters
		if(isset($parameters['StorageMaster']['selection_label'])) {
			//From databrowser
			$selection_labels  = array_filter($parameters['StorageMaster']['selection_label']);
			if($selection_labels) $conditions['StorageMaster.selection_label'] = $selection_labels;
		} else if(isset($parameters['ViewStorageMaster']['id'])) {
			//From databrowser
			$storage_master_ids  = array_filter($parameters['ViewStorageMaster']['id']);
			if($storage_master_ids) $conditions['StorageMaster.id'] = $storage_master_ids;
		} else if(isset($parameters['NonTmaBlockStorage']['id'])) {
			//From databrowser
			$storage_master_ids  = array_filter($parameters['NonTmaBlockStorage']['id']);
			if($storage_master_ids) $conditions['StorageMaster.id'] = $storage_master_ids;
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		// Load Model
		$storage_master_model = AppModel::getInstance("StorageLayout", "StorageMaster", true);
		$storage_control_model = AppModel::getInstance("StorageLayout", "StorageControl", true);
		// Build Res
		$tmp_res_count = $storage_master_model->find('count', array('conditions' => $conditions, 'fields' => array('StorageMaster.*'), 'order' => array('StorageMaster.selection_label ASC'), 'recursive' => '-1'));	
// *** NOTE: Has to control the number of record because the next report code lines can be really time and memory consuming ***
		if($tmp_res_count > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => __('the report contains too many results - please redefine search criteria')." [> $tmp_res_count ".__('lines').']');
		}
		$tma_storage_contol_ids = $storage_control_model->getTmaBlockStorageTypePermissibleValues();
		$tma_storage_contol_ids = array_keys($tma_storage_contol_ids);
		$studied_storages = $storage_master_model->find('all', array('conditions' => $conditions, 'fields' => array('StorageMaster.*'), 'order' => array('StorageMaster.selection_label ASC'), 'recursive' => '-1'));	
		$res = array();
		foreach($studied_storages as $new_studied_storage) {
			$children_storage_masters = $storage_master_model->children($new_studied_storage['StorageMaster']['id'], false, array('StorageMaster.*'));
			if($children_storage_masters){
				foreach($children_storage_masters as $new_child) {
					if(!in_array($new_child['StorageMaster']['storage_control_id'], $tma_storage_contol_ids)) {
						if(array_key_exists('SelectedItemsForCsv', $parameters) && !in_array($new_child['StorageMaster']['id'], $parameters['SelectedItemsForCsv']['NonTmaBlockStorage']['id'])) continue;
						$res[] = array_merge($new_studied_storage, array('ViewStorageMaster' => $new_child['StorageMaster'], 'NonTmaBlockStorage' => $new_child['StorageMaster']));
					}
				}
			}
		}
		return array(
				'header' => $header,
				'data' => $res,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function getAllRelatedDiagnosis($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$header = null;
		$conditions = array();
		// Get Parameters
		if(isset($parameters['DiagnosisMaster']['id'])) {
			//From databrowser
			$diagnosis_master_ids  = array_filter($parameters['DiagnosisMaster']['id']);
			if($diagnosis_master_ids) $conditions['DiagnosisMaster.id'] = $diagnosis_master_ids;
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			//From databrowser
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions['Participant.participant_identifier'] = $participant_identifiers;
		} else if(isset($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions['DiagnosisMaster.participant_id'] = $participant_ids;
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		// Load Model
		$diagnosis_master_model = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		// Build Res
		$diagnosis_master_model->bindModel(
			array('belongsTo' => array(
				'Participant' => array(
					'className'    => 'ClinicalAnnotation.Participant',
					'foreignKey'    => 'participant_id'))), false);
		$diagnosis_master_model->unbindModel(array('hasMany' => array('Collection')), false);
		$tmp_res_count = $diagnosis_master_model->find('count', array('conditions' => $conditions, 'fields' => array('DISTINCT primary_id'), 'recursive' => '0'));
// *** NOTE: Has to control the number of record because the next report code lines can be really time and memory consuming ***
		if($tmp_res_count > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => __('the report contains too many results - please redefine search criteria')." [> $tmp_res_count ".__('lines').']');
		}
		$tmp_primary_ids = $diagnosis_master_model->find('all', array('conditions' => $conditions, 'fields' => array('DISTINCT primary_id'), 'recursive' => '0'));
		$primary_ids = array();
		foreach($tmp_primary_ids as $new_primary_id) $primary_ids[] = $new_primary_id['DiagnosisMaster']['primary_id'];
		$conditions_2 = array('DiagnosisMaster.primary_id' => $primary_ids);
		if(isset($parameters['SelectedItemsForCsv']['DiagnosisMaster']['id'])) $conditions_2['DiagnosisMaster.id'] = $parameters['SelectedItemsForCsv']['DiagnosisMaster']['id'];
		$res = $diagnosis_master_model->find('all', array('conditions' => $conditions_2, 'fields' => array('Participant.*','DiagnosisMaster.*','DiagnosisControl.*'), 'order'=> array('Participant.participant_identifier ASC', 'DiagnosisMaster.primary_id ASC', 'DiagnosisMaster.dx_date ASC'), 'recursive' => '0'));
		return array(
				'header' => $header,
				'data' => $res,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function countNumberOfElementsPerParticipants($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$header = null;
		$conditions = array();
		
		// Get studied model
		
		$models_list = array('MiscIdentifier' => array('id', array('misc_identifiers'), 'misc identifiers'),
			'ConsentMaster' => array('id', array('consent_masters'), 'consents'),
			'DiagnosisMaster' => array('id', array('diagnosis_masters'), 'diagnosis'),
			'TreatmentMaster' => array('id', array('treatment_masters'), 'treatments'),
			'EventMaster' => array('id', array('event_masters'), 'events'),
			'ReproductiveHistory' => array('id', array('consent_masters'), 'reproductive histories'),
			'FamilyHistory' => array('id', array('family_histories'), 'family histories'),
			'ParticipantMessage' => array('id', array('participant_messages'), 'messages'),
			'ParticipantContact' => array('id', array('participant_contacts'), 'contacts'),
			'ViewCollection' => array('collection_id', array('collections'), 'collections'),
			'TreatmentExtendMaster' => array('id', array('treatment_masters'), 'xxxx'),
				
			'ViewAliquot' => array('aliquot_master_id', array('aliquot_masters', 'collections'), 'aliquots'),
			'ViewSample' => array('sample_master_id', array('sample_masters', 'collections'), 'samples'),
			'QualityCtrl' => array('id', array('quality_ctrls', 'sample_masters', 'collections'), 'quality controls'),
			'SpecimenReviewMaster' => array('id', array('specimen_review_masters', 'sample_masters', 'collections'), 'specimen review'),
			'ViewAliquotUse' => array('id', array('view_aliquot_uses', 'aliquot_masters', 'collections'), 'aliquot uses and events'),
			'AliquotReviewMaster' => array('id', array('aliquot_review_masters', 'aliquot_masters', 'sample_masters', 'collections'), 'aliquot review'));
		$model_name = null;
		foreach(array_keys($models_list) as $tm_model_name) {
			if(isset($parameters[$tm_model_name])) { $model_name = $tm_model_name; break; }
		}
		
		//Get data
		
		if($model_name) {
			list($model_id_key, $ordered_linked_table_names, $header_detail) = $models_list[$model_name];
			$ids = array_filter($parameters[$model_name][$model_id_key]);		
			$ids = empty($ids)? '-1' : implode(',',$ids); 
			$joins = array();
			$delete_constraints = array();
			$model_levels = 0;
			$foreign_key_to_previous_model = null;
			foreach(array_reverse($ordered_linked_table_names) as $new_table_name) {
				$model_levels++;
				if($model_levels == 1) {
					$joins[] = "INNER JOIN $new_table_name ModelLevel1 ON ModelLevel1.participant_id = Participant.id";
					$foreign_key_to_previous_model = preg_replace('/s$/', '_id', $new_table_name);
				} else {
					$joins[] = "INNER JOIN $new_table_name ModelLevel$model_levels ON ModelLevel$model_levels.".$foreign_key_to_previous_model." = ModelLevel".($model_levels-1).".id";
					$foreign_key_to_previous_model = preg_replace('/s$/', '_id', $new_table_name);
				}
				if($new_table_name != 'view_aliquot_uses') $delete_constraints[] = "ModelLevel$model_levels.deleted <> 1";
			}			
			$query = "SELECT count(*) AS nbr_of_elements, Participant.*
				FROM participants AS Participant ".
				implode(' ', $joins).
				" WHERE Participant.deleted <> 1 AND ".
				implode(' AND ', $delete_constraints).
				" AND ModelLevel$model_levels.id IN ($ids)
				GROUP BY Participant.id;";	
			//Set header
			$header = str_replace('%s', __($header_detail), __('number of %s per participant'));
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$data = $participant_model->tryCatchQuery($query);
// *** NOTE: It's user choice to display report in csv whatever the number of records ***		
// 		if(sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
// 			return array(
// 					'header' => null,
// 					'data' => null,
// 					'columns_names' => null,
// 					'error_msg' => 'the report contains too many results - please redefine search criteria');
// 		}
		foreach($data as &$new_row) $new_row['Generated'] = $new_row['0'];
		return array(
			'header' => $header,
			'data' => $data,
			'columns_names' => null,
			'error_msg' => null);
	}
	
}