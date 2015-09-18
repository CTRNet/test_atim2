<?php
	
	// @author Stephen Fung
	// @since 2015-06-24
	// BB-87
	// Chronology will now display consent dates of the customized consent forms
	
	if (array_key_exists('ccbr_date_formal_consent', $consent['ConsentDetail'])) {
		
		$chronolgy_data_consent['date'] = $consent['ConsentDetail']['ccbr_date_formal_consent'];
		
	} elseif (array_key_exists('bcch_date_formal_consent', $consent['ConsentDetail'])) {
		
		$chronolgy_data_consent['date'] = $consent['ConsentDetail']['bcch_date_formal_consent'];
		
	} elseif (array_key_exists('bcwh_date_formal_consent', $consent['ConsentDetail'])) {
		
		$chronolgy_data_consent['date'] = $consent['ConsentDetail']['bcwh_date_formal_consent'];
		
	} elseif (array_key_exists('bcwh_maternal_date_formal_consent', $consent['ConsentDetail'])) {
		
		$chronolgy_data_consent['date'] = $consent['ConsentDetail']['bcwh_maternal_date_formal_consent'];
		
	}
