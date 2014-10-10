<?php

	if($dx_ctrl['DiagnosisControl']['category'] == 'recurrence') {
		$this->DiagnosisMaster->updateCalculatedFields($participant_id);
	}
