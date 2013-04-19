<?php

	if($treatment_master_data['TreatmentControl']['tx_method'] == 'surgery') $this->DiagnosisMaster->updateCalculatedFields($participant_id);
