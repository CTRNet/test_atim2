<?php
class ReviewMastersController extends InventoryManagementAppController {
	
	var $name = 'ReviewMasters';
	var $uses = array (
		'ReviewControl',
		'ReviewMaster',
		'SampleMaster',
		'AliquotMaster',
		'PathCollectionReview',
		'ReviewDetail',
		'Menu'
	);

	var $components = array (
		'Summaries'
	);
	var $helpers = array (
		'Summaries'
	);

	function beforeFilter() {
		
		// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility 
		$this->othAuth->controller = &$this;
		$this->othAuth->init();
		$this->othAuth->check();
		
		// CakePHP function to re-combine dat/time select fields 
		$this->cleanUpFields();
		
	}
	
	function index() {
		// nothing...
	}

	function listall($menu_id = NULL, $review_sample_group = NULL, $collection_id = null) {

		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'inv_CAN_00', 'inv_CAN_23', $collection_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'inv_CAN_23', $menu_id, $collection_id );

		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray('review_masters'));
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_' . 
				$this->params['controller'] . '_' . 
				$this->params['action']));
		
		// get all collection samples listed into the same collection sample group
		$criteria = 'SampleMaster.collection_id ="' . $collection_id . '" ' .
			'AND SampleMaster.initial_specimen_sample_type ="' . $review_sample_group . '"';
		$collection_group_sample_list 
			= $this->SampleMaster->generateList($criteria, null, null, '{n}.SampleMaster.id', '{n}');

		$this->set('collection_group_sample_list', $collection_group_sample_list);

		// set FORM variable, for HELPER call on VIEW 
		$this->set('menu_id', $menu_id);
		$this->set('review_sample_group', $review_sample_group);
		$this->set('collection_id', $collection_id);

		// get existing sample report
		$criteria = array ();
		$criteria['collection_id'] = $collection_id;
		$criteria['review_sample_group'] = $review_sample_group;
		$criteria = array_filter($criteria);

		list ($order, $limit, $page) = $this->Pagination->init($criteria);
		$this->set('review_masters', $this->ReviewMaster->findAll($criteria, NULL, $order, $limit, $page));
			
		// Get existing report that could be created for this type of collection group
		$conditions = array ();
		$conditions['review_sample_group'] = $review_sample_group;
		$conditions = array_filter($conditions);
		
		$this->set('review_controls', $this->ReviewControl->findAll($conditions));

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}

	function detail($menu_id = NULL, $review_sample_group = NULL, $collection_id = null, $review_master_id = null) {

		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_23', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_23', $menu_id, $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);

		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));

		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray($this->params['plugin'] . '_' . 
			$this->params['controller'] . '_' . 
			$this->params['action']));

		// set FORM variable, for HELPER call on VIEW 
		$this->set('menu_id', $menu_id);
		$this->set('review_sample_group', $review_sample_group);
		$this->set('collection_id', $collection_id);

		// REVIEW MASTER info defines REVIEWDETAIL info, including FORM alias 

		// read REVIEWMASTER info, which contains FORM alias and DETAIL tablename 
		$this->ReviewMaster->id = $review_master_id;
		$review_master_data = $this->ReviewMaster->read();
		if(empty($review_master_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}
		
		$this->ReviewControl->id = $review_master_data['ReviewMaster']['review_control_id'];
		$review_control_data = $this->ReviewControl->read();
		if(empty($review_control_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}		
		
		// FORM alias, from REVIEW MASTER field 
		$this->set('ctrapp_form', $this->Forms->getFormArray($review_control_data['ReviewControl']['form_alias']));

		// start new instance of REVIEWDETAIL model, using TABLENAME from REVIEW MASTER 
		$this->ReviewDetail = new ReviewDetail(false, $review_control_data['ReviewControl']['detail_tablename']);
		$this->ReviewDetail->id = $review_master_id;
		$review_specific_data = $this->ReviewDetail->read();
		if(empty($review_specific_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}
		
		// merge both datasets into a SINGLE dataset, set for VIEW 
		$this->set('data', array_merge($review_master_data, $review_specific_data));

		// get all collection samples listed into the same collection sample group
		$criteria = 'SampleMaster.collection_id ="' . $collection_id . '" ' .
			'AND SampleMaster.initial_specimen_sample_type ="' . $review_sample_group . '"';
		$collection_group_sample_list 
			= $this->SampleMaster->generateList($criteria, null, null, '{n}.SampleMaster.id', '{n}');

		$this->set('collection_group_sample_list', $collection_group_sample_list);

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}

	function add($menu_id = NULL, $review_sample_group = NULL, $collection_id = null, $review_control_id = null) {

		if (isset ($this->params['form']['review_control_id'])) {
			// get REVIEWCONTROL ID from LISTALL add form submit 
			$review_control_id = $this->params['form']['review_control_id'];			
		}
		
		if(empty($review_control_id)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}

		// read REVIEWCONTROL info, which contains FORM alias and DETAIL tablename 
		$this->ReviewControl->id = $review_control_id;
		$review_control_data = $this->ReviewControl->read();
		if(empty($review_control_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}

		// start new instance of REVIEWDETAIL model, using TABLENAME from REVIEW MASTER 
		$this->ReviewDetail = new ReviewDetail(false, $review_control_data['ReviewControl']['detail_tablename']);

		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_23', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_23', $menu_id, $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);

		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray($review_control_data['ReviewControl']['form_alias']));

		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));

		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_' . 
				$this->params['controller'] . '_' . 
				$this->params['action']));

		// set FORM variable, for HELPER call on VIEW 
		$this->set('menu_id', $menu_id);
		$this->set('review_type', $review_control_data['ReviewControl']['review_type']);
		$this->set('review_sample_group', $review_sample_group);
		$this->set('collection_id', $collection_id);
		$this->set('review_control_id', $review_control_id);

		// get all collection samples listed into the same collection sample group
		$criteria = 'SampleMaster.collection_id ="' . $collection_id . '" ' .
			'AND SampleMaster.initial_specimen_sample_type ="' . $review_sample_group . '"';
		$collection_group_sample_list 
			= $this->SampleMaster->generateList($criteria, null, null, '{n}.SampleMaster.id', '{n}');

		$this->set('collection_group_sample_list', $collection_group_sample_list);

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if (!empty ($this->data)) {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray($review_control_data['ReviewControl']['form_alias']) as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if (!$this->ReviewMaster->validates($this->data['ReviewMaster'])) {
				$submitted_data_validates = false;
			}
			
			if(isset($this->data['ReviewDetail'])){
				$this->cleanUpFields('ReviewDetail');
			
				// Validates Fields
				if(!$this->ReviewDetail->validates($this->data['ReviewDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {

				// ** Save Data **
							
				$bool_save_done = TRUE;
		
				// Save MASTER data
				$review_master_id = NULL;
				
				if($this->ReviewMaster->save($this->data['ReviewMaster'])){
					$review_master_id = $this->ReviewMaster->getLastInsertId();
				} else {
					$bool_save_done = FALSE;
				}
				
				//Save Specimen or Derivative Data
				if($bool_save_done) {

					$this->data['ReviewDetail']['id'] = $review_master_id;
					$this->data['ReviewDetail']['review_master_id'] = $review_master_id;
				
					// save DerivativeDetail data 
					if(!$this->ReviewDetail->save($this->data['ReviewDetail'])){
						$bool_save_done = FALSE;
					}
					
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_rev_master_general_error'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash('Your data has been saved.', 
						"/review_masters/listall/$menu_id/$review_sample_group/$collection_id");				
				}
				
			}

		}

	} // add

	function edit($menu_id = NULL, $review_sample_group = NULL, $collection_id = null, $review_master_id = null) {

		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_23', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_23', $menu_id, $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);

		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));

		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_' . 
				$this->params['controller'] . '_' . 
				$this->params['action']));

		// set FORM variable, for HELPER call on VIEW 
		$this->set('menu_id', $menu_id);
		$this->set('review_sample_group', $review_sample_group);
		$this->set('collection_id', $collection_id);
		$this->set('review_master_id', $review_master_id);

		// read REVIEWMASTER info
		$this->ReviewMaster->id = $review_master_id;
		$review_master_data = $this->ReviewMaster->read();
		if(empty($review_master_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}

		$this->ReviewControl->id = $review_master_data['ReviewMaster']['review_control_id'];
		$review_control_data = $this->ReviewControl->read();
		if(empty($review_control_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}		

		// start new instance of REVIEWDETAIL model, using TABLENAME from REVIEW MASTER 
		$this->ReviewDetail = new ReviewDetail(false, $review_control_data['ReviewControl']['detail_tablename']);
		$this->ReviewDetail->id = $review_master_id;
		$review_specific_data = $this->ReviewDetail->read();
		if(empty($review_specific_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}
					
		// FORM alias, from REVIEW MASTER field 
		$this->set('ctrapp_form', $this->Forms->getFormArray($review_control_data['ReviewControl']['form_alias']));

		// get all collection samples listed into the same collection sample group
		$criteria = 'SampleMaster.collection_id ="' . $collection_id . '" ' .
			'AND SampleMaster.initial_specimen_sample_type ="' . $review_sample_group . '"';
		$collection_group_sample_list 
			= $this->SampleMaster->generateList($criteria, null, null, '{n}.SampleMaster.id', '{n}');

		$this->set('collection_group_sample_list', $collection_group_sample_list);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if (empty ($this->data)) {

			// merge both datasets into a SINGLE dataset, set for VIEW 
			$this->data = array_merge($review_master_data, $review_specific_data);
			$this->set('data', $this->data);

		} else {

			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray( $review_control_data['ReviewControl']['form_alias'] ) as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			$submitted_data_validates = TRUE;		

			// Validates Fields of Master Table
			if(!$this->ReviewMaster->validates($this->data['ReviewMaster'])){
				$submitted_data_validates = FALSE;
			}
			
			if(isset($this->data['ReviewDetail'])){
				$this->cleanUpFields('ReviewDetail');
				
				// Validates Fields of Details Table
				if(!$this->ReviewDetail->validates($this->data['ReviewDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
					
			if ($submitted_data_validates) {
				
				// ** Save Data **
							
				$bool_save_done = TRUE;
		
				// Save MASTER data
				if(!$this->ReviewMaster->save($this->data['ReviewMaster'])){
					$bool_save_done = FALSE;
				}
				
				if($bool_save_done && isset($this->data['ReviewDetail'])){			
					// Detail should be recorded
					
					// Save DETAIL data 
					if(!$this->ReviewDetail->save($this->data['ReviewDetail'])){
						$bool_save_done = FALSE;
					}
					
				}
					
				if(!$bool_save_done){
					$this->redirect('/pages/err_rev_master_general_error'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash('Your data has been updated.', 
						"/review_masters/listall/$menu_id/$review_sample_group/$collection_id");				
				}
											
			} // end action done after validation
		} // end data save	 		

	} // edit


	function delete($menu_id = NULL, $review_sample_group = NULL, $collection_id = null, $review_master_id = null) {

		// read REVIEWMASTER info
		$this->ReviewMaster->id = $review_master_id;
		$review_master_data = $this->ReviewMaster->read();
		if(empty($review_master_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}

		$this->ReviewControl->id = $review_master_data['ReviewMaster']['review_control_id'];
		$review_control_data = $this->ReviewControl->read();
		if(empty($review_control_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}		

		// start new instance of REVIEWDETAIL model, using TABLENAME from REVIEW MASTER 
		$this->ReviewDetail = new ReviewDetail(false, $review_control_data['ReviewControl']['detail_tablename']);
		$this->ReviewDetail->id = $review_master_id;
		$review_specific_data = $this->ReviewDetail->read();
		if(empty($review_specific_data)){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		// delete MASTER/DETAIL rows 
		$bool_del_error = FALSE;
		
		if($this->ReviewMaster->del($review_master_id)) {
			if(!$this->ReviewDetail->del($review_master_id)) {
				$bool_del_error = TRUE;
			}			
		} else {
			$bool_del_error = TRUE;
		}

		if($bool_del_error){
			$this->redirect('/pages/err_rev_master_general_error'); 
			exit;
		}

		$this->flash('Your data has been deleted.',
				"/review_masters/listall/$menu_id/$review_sample_group/$collection_id");

	}

}
?>
