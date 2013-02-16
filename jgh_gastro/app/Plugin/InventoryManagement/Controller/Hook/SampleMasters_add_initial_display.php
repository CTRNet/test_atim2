<?php

	//SET DEFAULT qc_gastro_specimen_code
	Switch($this->request->data['SampleControl']['sample_type']) {
		case 'tissue':
			$this->request->data['SpecimenDetail']['qc_gastro_specimen_code'] = 'T';
			break;
		case 'blood':
			$this->request->data['SpecimenDetail']['qc_gastro_specimen_code'] = 'B';
			break;
		default:
	}
	