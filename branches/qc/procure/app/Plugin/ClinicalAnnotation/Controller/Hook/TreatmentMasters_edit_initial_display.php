<?php
$DrugModel = AppModel::getInstance("Drug", "Drug", true);
$this->request->data['FunctionManagement']['autocomplete_treatment_drug_id'] = $DrugModel->getDrugDataAndCodeForDisplay(array(
    'Drug' => array(
        'id' => $this->request->data['TreatmentMaster']['procure_drug_id']
    )
));

AppController::addWarningMsg("procure_dose_frequence_change_warning");