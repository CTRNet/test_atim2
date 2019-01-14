<?php
// new April 16 2018 , changed this to calculate correct age at dx and not just by year
// revised as a postsave July 25 2018, as it was causing errors for day ot year unknown
$dxMasterData = $this->DiagnosisMaster->find('first', array(
    'conditions' => array(
        'DiagnosisMaster.id' => $diagnosisMasterId,
        'DiagnosisMaster.participant_id' => $participantId
    )
));

$endDate = $dxMasterData['DiagnosisMaster']['dx_date'];
echo $endDate;
$startDate = $participantData['Participant']['date_of_birth'];
echo $startDate;

$startDt = date_create($startDate);
$endDt = date_create($endDate);

$dtinter = date_diff($startDt, $endDt);

echo $dtinter->format("%a");

$agedx = floor($dtinter->format("%a") / 365.2425);
echo $agedx;

if ($agedx > 0) {
    
    $queryToUpdate = "UPDATE diagnosis_masters SET diagnosis_masters.age_at_dx = " . $agedx . " WHERE " . $diagnosisMasterId . "=diagnosis_masters.id";
    "";
    $this->DiagnosisMaster->tryCatchQuery($queryToUpdate);
    $this->DiagnosisMaster->tryCatchQuery(str_replace("diagnosis_masters", "diagnosis_masters_revs", $queryToUpdate));
}