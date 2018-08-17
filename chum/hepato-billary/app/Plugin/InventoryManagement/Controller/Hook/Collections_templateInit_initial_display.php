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
    'h'
)) ? 'h' : $viewCollectionData['ViewCollection']['collection_datetime_accuracy'];



$this->request->data['SpecimenDetail']['reception_datetime'] = $tmpCollectionDateTime;
$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $tmpCollectionDateTimeAccuracy;
$this->request->data['SpecimenDetail']['reception_by'] = 'louise rousseau';

$this->request->data['DerivativeDetail']['creation_datetime'] = $tmpCollectionDateTime;
$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $tmpCollectionDateTimeAccuracy;
$this->request->data['DerivativeDetail']['creation_by'] = 'louise rousseau';
//$this->request->data['DerivativeDetail']['creation_site'] = "cr. st-luc";


$this->request->data['AliquotMaster']['storage_datetime'] = $tmpCollectionDateTime;
$this->request->data['AliquotMaster']['storage_datetime_accuracy'] = $tmpCollectionDateTimeAccuracy;
$this->request->data['AliquotMaster']['qc_hb_stored_by'] = 'louise rousseau';
