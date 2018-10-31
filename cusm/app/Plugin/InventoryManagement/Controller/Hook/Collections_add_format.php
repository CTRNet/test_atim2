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
 
if (! $needToSave) {
    if (! isset($this->request->data['Collection']['bank_id'])) {
        $this->request->data['Collection']['bank_id'] = $this->Session->read('Auth.User.Group.bank_id');
    }
    if (! isset($this->request->data['Collection']['collection_site'])) {
        $this->request->data['Collection']['collection_site'] = 'montreal general hospital';
    }
}