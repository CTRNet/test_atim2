<?php
	
	if(isset($controls_for_subform_display)) {
		foreach($controls_for_subform_display as &$new_ctrl) {
			if(isset($new_ctrl['EventControl']['event_type'])) $new_ctrl['EventControl']['ev_header'] = __($new_ctrl['EventControl']['event_type']);
		}
	}
	$this->set('controls_for_subform_display', $controls_for_subform_display);
