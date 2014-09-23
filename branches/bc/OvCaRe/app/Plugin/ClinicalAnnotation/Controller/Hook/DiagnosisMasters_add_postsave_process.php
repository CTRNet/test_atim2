<?php

	if($dx_ctrl['DiagnosisControl']['category'] == 'recurrence') {
		pr('TODO updateCalculatedFields');
		$this->DiagnosisMaster->updateCalculatedFields($participant_id);
	}
