<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// To speed up the collection deletion process, we delete the collection
// automatically after the participant to collection link deletion.
if(!$this->Collection->atimDelete($collectionId, true)) {
    $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
}

	