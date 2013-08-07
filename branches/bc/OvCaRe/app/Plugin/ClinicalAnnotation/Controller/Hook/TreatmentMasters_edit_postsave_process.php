<?php

	if($treatment_master_data['TreatmentControl']['tx_method'] == 'procedure - surgery biopsy') $this->DiagnosisMaster->updateCalculatedFields($participant_id);
