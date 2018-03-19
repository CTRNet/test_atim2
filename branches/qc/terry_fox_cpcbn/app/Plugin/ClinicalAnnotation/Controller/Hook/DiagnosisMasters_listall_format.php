<?php
$atimStructure['EventMaster'] = $this->Structures->get('form', 'eventmasters_for_dx_tree_view');
$atimStructure['TreatmentMaster'] = $this->Structures->get('form', 'treatmentmasters_for_dx_tree_view');
$atimStructure['DiagnosisMaster'] = $this->Structures->get('form', 'view_diagnosis_for_dx_tree_view');
$this->set('atimStructure', $atimStructure);