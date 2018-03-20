<?php
if (empty($errors)) {
    $drug_ids = array();
    foreach ($this->request->data as $newTxExtendRecord) {
        $drug_ids[] = $newTxExtendRecord['TreatmentExtendMaster']['drug_id'];
    }
    if ($drug_ids) {
        $drugTypeAllowed = str_replace(
            array('hormonotherapy', 'other treatment bone specific', 'other treatment HR specific', "'"), 
            array('hormonal', 'bone', 'HR', "''"), 
            $txMasterData['TreatmentControl']['tx_method']);
        $drugTypeNotAllowed = $this->Drug->find('count', array(
            'conditions' => array(
                'Drug.id' => $drug_ids,
                "Drug.type NOT LIKE '$drugTypeAllowed'"
            )
        ));
        if ($drugTypeNotAllowed) {
            $errors['autocomplete_treatment_drug_id']['at least one selected drug does not match the type of the treatment'][] = '';
        }
    }
}