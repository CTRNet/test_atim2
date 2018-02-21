<?php
/** **********************************************************************
 * CUSM-CIM Project.
* ***********************************************************************
*
* InventoryManagement plugin custom code
*
* @author N. Luc - CTRNet (nicolas.luc@gmail.com)
* @since 2018-02-21
*/

// Genrated the collection acquisition_label being equal to the id of the record
$this->Collection->data = array();
$this->Collection->addWritableField(array(
    'acquisition_label'
));
if (!$this->Collection->save(array(
    'Collection' => array(
        'acquisition_label' => $this->Collection->id
    )
))) {
    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}