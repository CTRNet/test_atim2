<?php

class ParticipantCustom extends Participant
{

    var $name = "Participant";

    var $tableName = "participants";

    function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            $return = array(
                'menu' => array(
                    NULL,
                    'Col# ' . $result['Participant']['participant_identifier']
                ),
                'title' => array(
                    NULL,
                    'Collection# : ' . $result['Participant']['participant_identifier']
                ),
                'structure alias' => 'participants',
                'data' => $result
            );
        }
        
        return $return;
    }

    function validates($options = array())
    {
        $errors = parent::validates($options);
        if (array_key_exists('date_of_death', $this->data['Participant']) && ($this->data['Participant']['date_of_death'])) {
            if ($this->data['Participant']['vital_status'] != 'deceased') {
                $this->validationErrors['vital_status'][] = __('vital status mismatch');
                return false;
            }
        }
        return $errors;
    }

    function updateParticipantLastEventRecorded($participant_id)
    {
        if ($participant_id) {
            $participant_data = $this->getOrRedirect($participant_id);
            $last_date_data = $this->query("SELECT MAX(final_date_and_accuracy) AS final_date_and_accuracy, participant_id 
				FROM (
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(date_of_death,'#',IFNULL(date_of_death_accuracy,'c')) as date_and_accuracy, id as participant_id FROM participants WHERE date_of_death IS NOT NULL AND deleted <> 1 AND id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(qc_lady_last_contact_date,'#','c') as date_and_accuracy, id as participant_id FROM participants WHERE qc_lady_last_contact_date IS NOT NULL AND deleted <> 1 AND id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(consent_signed_date,'#',IFNULL(consent_signed_date_accuracy,'c')) as date_and_accuracy, participant_id FROM consent_masters WHERE consent_signed_date IS NOT NULL AND deleted <> 1 AND participant_id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(status_date,'#',IFNULL(status_date_accuracy,'c')) as date_and_accuracy, participant_id FROM consent_masters WHERE status_date IS NOT NULL AND deleted <> 1 AND participant_id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(dx_date,'#',IFNULL(dx_date_accuracy,'c')) as date_and_accuracy, participant_id FROM diagnosis_masters WHERE dx_date IS NOT NULL AND deleted <> 1 AND participant_id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(event_date,'#',IFNULL(event_date_accuracy,'c')) as date_and_accuracy, participant_id FROM event_masters WHERE event_date IS NOT NULL AND deleted <> 1 AND participant_id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(start_date,'#',IFNULL(start_date_accuracy,'c')) as date_and_accuracy, participant_id FROM treatment_masters WHERE start_date IS NOT NULL AND deleted <> 1 AND participant_id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(finish_date,'#',IFNULL(finish_date_accuracy,'c')) as date_and_accuracy, participant_id FROM treatment_masters WHERE finish_date IS NOT NULL AND deleted <> 1 AND participant_id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(SUBSTR(collection_datetime,1,10),'#',IFNULL(collection_datetime_accuracy,'c')) as date_and_accuracy, participant_id FROM collections WHERE collection_datetime IS NOT NULL AND (collection_datetime_accuracy IS NULL OR collection_datetime_accuracy NOT IN ('h', 'i')) AND deleted <> 1 AND participant_id = $participant_id
					) Res GROUP BY participant_id
					UNION ALL 
					SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
						select concat(SUBSTR(collection_datetime,1,10),'#','c') as date_and_accuracy, participant_id FROM collections WHERE collection_datetime IS NOT NULL AND collection_datetime_accuracy IN ('h', 'i') AND deleted <> 1 AND participant_id = $participant_id
					) Res GROUP BY participant_id
				) ResPerParticipant GROUP BY participant_id");
            if ($last_date_data && array_key_exists('final_date_and_accuracy', $last_date_data['0']['0'])) {
                $qc_lady_last_event_recorded = substr($last_date_data['0']['0']['final_date_and_accuracy'], 0, 10);
                $qc_lady_last_event_recorded_accuracy = substr($last_date_data['0']['0']['final_date_and_accuracy'], 11, 1);
                if ($participant_data['Participant']['qc_lady_last_event_recorded'] != $qc_lady_last_event_recorded || $participant_data['Participant']['qc_lady_last_event_recorded_accuracy'] != $qc_lady_last_event_recorded_accuracy) {
                    $this->check_writable_fields = false;
                    $this->data = array();
                    $this->id = $participant_id;
                    $this->save(array(
                        'qc_lady_last_event_recorded' => $qc_lady_last_event_recorded,
                        'qc_lady_last_event_recorded_accuracy' => $qc_lady_last_event_recorded_accuracy
                    ), false);
                    $this->check_writable_fields = true;
                }
            }
        }
    }
}
