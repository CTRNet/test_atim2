<?php

class TreatmentMastersControllerCustom extends TreatmentMastersController
{

    var $paginate = array(
        'TreatmentMaster' => array(
            'limit' => pagination_amount,
            'order' => 'TreatmentMaster.start_date DESC'
        )
    );

    public function listallBasedOnControlId($participantId, $treatmentControlId, $intervalStartDate = null, $intervalStartDateAccuracy = '', $intervalFinishDate = null, $intervalFinishDateAccuracy = '')
    {
        // *** Specific list display based on control_id
        $participantData = $this->Participant->getOrRedirect($participantId);
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%'));
        $treatmentControl = $this->TreatmentControl->getOrRedirect($treatmentControlId);
        $this->Structures->set(($treatmentControl['TreatmentControl']['tx_method'] == 'procure medication worksheet') ? '' : $treatmentControl['TreatmentControl']['form_alias']);
        if (is_null($intervalStartDate) && is_null($intervalFinishDate)) {
            // 1- No Date Restriction (probably generic listall form)
            $this->request->data = $this->paginate($this->TreatmentMaster, array(
                'TreatmentMaster.participant_id' => $participantId,
                'TreatmentMaster.treatment_control_id' => $treatmentControlId
            ));
        } else {
            // 2- Date Restriction (probaby list linked to Medication Worksheet detail display or Follow-up Worksheet detail display)
            $intervalStartDate = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $intervalStartDate) ? $intervalStartDate : '';
            $intervalFinishDate = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $intervalFinishDate) ? $intervalFinishDate : '';
            $drugsListConditions = array(
                'TreatmentMaster.participant_id' => $participantId,
                'TreatmentMaster.treatment_control_id' => $treatmentControlId
            );
            if ($intervalStartDate && $intervalFinishDate) {
                $drugsListConditions[]['OR'] = array(
                    "TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
                    "TreatmentMaster.start_date IS NOT NULL AND '$intervalStartDate' <= TreatmentMaster.start_date  AND TreatmentMaster.start_date <= '$intervalFinishDate'",
                    "TreatmentMaster.finish_date IS NOT NULL AND '$intervalStartDate' <= TreatmentMaster.finish_date AND TreatmentMaster.finish_date <= '$intervalFinishDate'",
                    "TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NOT NULL AND '$intervalFinishDate' < TreatmentMaster.finish_date",
                    "TreatmentMaster.finish_date IS NULL AND TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date < '$intervalStartDate'",
                    "TreatmentMaster.start_date < $intervalStartDate AND '$intervalFinishDate' < TreatmentMaster.finish_date"
                );
            } elseif ($intervalStartDate) {
                $drugsListConditions[]['OR'] = array(
                    "TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
                    "TreatmentMaster.finish_date IS NOT NULL AND TreatmentMaster.finish_date >= '$intervalStartDate'"
                );
            } elseif ($intervalFinishDate) {
                $drugsListConditions[]['OR'] = array(
                    "TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
                    "TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date <= '$intervalFinishDate'"
                );
            }
            $this->request->data = $this->paginate($this->TreatmentMaster, $drugsListConditions);
        }
    }
}