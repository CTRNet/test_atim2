<?php 

if($treatment_control_id > 0) {
    $reformated_structure_alias = implode(',', array_unique (explode(',', $control_data['TreatmentControl']['form_alias'])));
    $this->Structures->set($reformated_structure_alias.',chus_tx_generated_detail');
    $this->CodingIcdo3Topo = AppModel::getInstance("CodingIcd", "CodingIcdo3Topo", true);
    foreach($this->request->data as &$new_chus_treatment) {
        $chus_conditions = array('TreatmentExtendMaster.treatment_master_id' => $new_chus_treatment['TreatmentMaster']['id'], 'TreatmentExtendMaster.treatment_extend_control_id' => $new_chus_treatment['TreatmentControl']['treatment_extend_control_id']);
        $chus_treatment_extend_data = $this->TreatmentExtendMaster->find('all', array('conditions' => $chus_conditions));
        $tmps_details = array();
        foreach($chus_treatment_extend_data as $new_chus_treatment_extend_data) {
            switch($control_data['TreatmentControl']['tx_method']) {
                case 'biopsy':
                case 'surgery':
                case 'radiotherapy':
                    $tmps_details[] = $this->CodingIcdo3Topo->getDescription($new_chus_treatment_extend_data['TreatmentExtendDetail'][(($control_data['TreatmentControl']['tx_method'] == 'radiotherapy')? 'site' : 'surgical_site')]);
                    break;
                case 'systemic therapy':
                    $tmps_details[] = $new_chus_treatment_extend_data['Drug']['generic_name'];
                    break;
            }
            
        }
        $tmps_details = array_unique($tmps_details);
        sort($tmps_details);
        $new_chus_treatment['Generated']['chus_tx_extend_summary'] = implode(' & ', $tmps_details);
    }
}
