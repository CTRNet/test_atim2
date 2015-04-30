<?php

/* 
@author Stephen Fung
@since 2014-04-17
Eventum ID: 3213
Enabling "Contact" for "Study"
*/

class StudyContactsControllerCustom extends StudyContactsController {

		function add( $study_summary_id) {
				/*
		pr('Has to be reviewed before to be used in prod.');
		$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		exit;*/
				if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

				// MANAGE DATA
				$study_contact_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
				if(empty($study_contact_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

				// MANAGE FORM, MENU AND ACTION BUTTONS

				// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));
				// $this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));
				$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));

				// CUSTOM CODE: FORMAT DISPLAY DATA

				$hook_link = $this->hook('format');
				if( $hook_link ) { require($hook_link); }

				if ( !empty($this->request->data) ) {

					// LAUNCH SAVE PROCESS
					// 1- SET ADDITIONAL DATA
					$this->StudyContact->addWritableField('study_summary_id');
					$this->request->data['StudyContact']['study_summary_id'] = $study_summary_id;

					// 2- LAUNCH SPECIAL VALIDATION PROCESS
					$submitted_data_validates = true;

					// ... special validations

					// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
					$hook_link = $this->hook('presave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}

					if($submitted_data_validates) {
						// 4- SAVE
						if ( $this->StudyContact->save($this->request->data) ) {
							$hook_link = $this->hook('postsave_process');
							if( $hook_link ) {
								require($hook_link);
							}
							$this->atimFlash(__('your data has been saved'),'/Study/StudyContacts/detail/'.$study_summary_id.'/'.$this->StudyContact->id );
						}
					}
				}
		}
}

?>
