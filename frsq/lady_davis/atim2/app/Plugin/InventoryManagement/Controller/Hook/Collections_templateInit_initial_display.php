<?php
/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Inventory Management plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
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
$this->request->data['AliquotMaster']['storage_datetime'] = $tmpCollectionDateTime;
$this->request->data['AliquotMaster']['storage_datetime_accuracy'] = $tmpCollectionDateTimeAccuracy;