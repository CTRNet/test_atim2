<?php
/** **********************************************************************
 * TFRI-M4S Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */

// Set default blood label(s)
if ($sampleControlData['SampleControl']['sample_type'] == 'blood') {
    $this->request->data['SampleDetail']['blood_type'] = 'EDTA';
} 