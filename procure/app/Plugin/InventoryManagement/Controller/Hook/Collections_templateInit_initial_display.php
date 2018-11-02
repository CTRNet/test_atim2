<?php
$viewCollectionData = $this->ViewCollection->find('first', array(
    'conditions' => array(
        'ViewCollection.collection_id' => $collectionId
    ),
    'recursive' => - 1
));
$tmpCollectionDateTime = $viewCollectionData['ViewCollection']['collection_datetime'];
$tmpCollectionDateTimeAccuracy = in_array($viewCollectionData['ViewCollection']['collection_datetime_accuracy'], array(
    'c',
    'i'
)) ? 'h' : $viewCollectionData['ViewCollection']['collection_datetime_accuracy'];

$this->request->data['SpecimenDetail']['reception_datetime'] = $tmpCollectionDateTime;
$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $tmpCollectionDateTimeAccuracy;
$this->request->data['DerivativeDetail']['creation_datetime'] = $tmpCollectionDateTime;
$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $tmpCollectionDateTimeAccuracy;

$strgLength = 10;
switch ($tmpCollectionDateTimeAccuracy) {
    case 'y':
    case 'm':
        $strgLength = 4;
        break;
    case 'd':
        $strgLength = 7;
        break;
}

$this->request->data['SampleDetail']['procure_collection_site'] = 'clinic';

$this->request->data['AliquotMaster']['storage_datetime'] = $tmpCollectionDateTime;
$this->request->data['AliquotMaster']['storage_datetime_accuracy'] = $tmpCollectionDateTimeAccuracy;

$tmpCollectionDateTime = substr($tmpCollectionDateTime, 0, $strgLength);
$this->request->data['0']['procure_serum_creation_datetime'] = $tmpCollectionDateTime;
$this->request->data['0']['procure_serum_storage_datetime'] = $tmpCollectionDateTime;
if ($strgLength == 10) {
    $tmpCollectionDateTime = date('Y-m-d', strtotime($tmpCollectionDateTime . ' +1 days'));
}
$this->request->data['0']['procure_pbmc_storage_datetime'] = $tmpCollectionDateTime;
$this->request->data['0']['procure_date_at_minus_80'] = $tmpCollectionDateTime;
