<?php
if (isset($_SESSION['chum_kidney_transp_donor_consent']) && $_SESSION['chum_kidney_transp_donor_consent']) {
    $this->set('contact_type', 'donor');
}
unset($_SESSION['chum_kidney_transp_donor_consent']);