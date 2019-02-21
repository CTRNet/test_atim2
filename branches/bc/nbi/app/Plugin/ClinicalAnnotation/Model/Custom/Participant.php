<?php
/**
 * **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2019-02-21
 */
 
class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    private $fieldsWithRestrictedAccess = array(
        "Participant.first_name",
        "Participant.middle_name",
        "Participant.last_name",
        "Participant.date_of_birth",
        "Participant.bc_nbi_phn_number",
        "Participant.bc_nbi_bc_cancer_agency_id"
    );

    public function beforeFind($queryData)
    {
        // Manage search on nominal information for participants of the retropsective bank
        if (($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions'])) {
            // Non-administrator user
            // Limit access to prospecitve bank participant when confidential/critical information is part of the query conditions
            $restrictionToProspectiveBankParticipant = false;
            foreach ($this->fieldsWithRestrictedAccess as $newFieldToTest) {
                if (AppModel::isFieldUsedAsCondition($newFieldToTest, $queryData['conditions'])) {
                    $restrictionToProspectiveBankParticipant = true;
                }
            }
            if ($restrictionToProspectiveBankParticipant) {
                if (! (isset($queryData['conditions']["Participant.bc_nbi_retrospective_bank"]) && $queryData['conditions']["Participant.bc_nbi_retrospective_bank"] == 'n') && ! in_array("Participant.bc_nbi_retrospective_bank = 'n'", $queryData['conditions'])) {
                    AppController::addWarningMsg(__('your search will be limited to participant of the prospective bank only'));
                }
                $queryData['conditions'][] = "Participant.bc_nbi_retrospective_bank = 'n'";
            }
        }
        return $queryData;
    }

    public function afterFind($results, $primary = false)
    {
        // Manage display on nominal information for participants of the retropsective bank
        $results = parent::afterFind($results);
        if ($_SESSION['Auth']['User']['group_id'] != '1') {
            // Non-administrator user
            // Hide confidential/critical information of the participants of the retrospecive bank
            if (isset($results[0]['Participant'])) {
                foreach ($results as &$result) {
                    if ((! isset($result['Participant']['bc_nbi_retrospective_bank'])) || $result['Participant']['bc_nbi_retrospective_bank'] == 'y') {
                        foreach ($this->fieldsWithRestrictedAccess as $newCriticalField) {
                            list ($model, $field) = explode('.', $newCriticalField);
                            $result[$model][$field] = CONFIDENTIAL_MARKER;
                        }
                    }
                }
            } elseif (isset($results['Participant'])) {
                // Should never happen
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
        return $results;
    }
}