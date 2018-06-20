<?php

/** **********************************************************************
 * UHN
 * ***********************************************************************
 *
 * CLinicalAnnotation plugin custom code
 *
 * Class AliquotMasterCustom
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-06-20
 */

if (isset($uhnOverrideData)) {
    // User is creating a new participant found in hospital system
    // Set default data
    $finalOptions['override'] = $uhnOverrideData;
}
