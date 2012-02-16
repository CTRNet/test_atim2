<?php

	if(!empty($parent_dx) && $dx_ctrl['DiagnosisControl']['controls_type'] == 'ovcare' && $parent_dx['DiagnosisControl']['controls_type'] == 'ovcare') {
		$this->flash('you are not allowed to add a secondary ovcare to a primary ovcare', 'javascript:history.back();');
	}

?>