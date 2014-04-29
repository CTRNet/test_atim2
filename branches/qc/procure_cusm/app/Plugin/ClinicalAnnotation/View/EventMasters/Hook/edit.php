<?php
	if(isset($default_procure_form_identification)) $final_options['override']['EventMaster.procure_form_identification'] = $default_procure_form_identification;
	if(isset($followup_identification_list)) $final_options['dropdown_options'] = array('EventDetail.followup_event_master_id' => $followup_identification_list);
