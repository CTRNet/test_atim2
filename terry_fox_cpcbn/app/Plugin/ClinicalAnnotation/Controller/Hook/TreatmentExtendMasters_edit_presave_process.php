<?php
if (isset($this->request->data['FunctionManagement']['autocomplete_treatment_drug_id'])) {
    $tmpDrugDetection = $this->Drug->getDrugIdFromDrugDataAndCode($this->request->data['FunctionManagement']['autocomplete_treatment_drug_id']);
    $drugTypeAllowed = str_replace(
        array('hormonotherapy drugs', 'bone treatment drugs', 'HR treatment drugs', 'chemotherapy drugs', "'"),
        array('hormonal', 'bone', 'HR', 'chemotherapy', "''"),
        $txExtendData['TreatmentExtendControl']['type']);
    if (isset($tmpDrugDetection['Drug']['type']) && $tmpDrugDetection['Drug']['type'] != $drugTypeAllowed) {
        $this->TreatmentExtendMaster->validationErrors['autocomplete_treatment_drug_id'][] = 'at least one selected drug does not match the type of the treatment';
        $submittedDataValidates = false;
    }
}
