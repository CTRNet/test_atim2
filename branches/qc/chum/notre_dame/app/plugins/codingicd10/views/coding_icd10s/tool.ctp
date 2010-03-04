<table style="margin-top: 20px;">
<?php
	
		
		$javascript_codeblock = '
				icd10_category = document.getElementById(\'CodingIcd10/category\');
				icd10_category = icd10_category.options[ icd10_category.selectedIndex ].getAttribute(\'value\');
				
				icd10_group = document.getElementById(\'CodingIcd10/icd_group\');
				icd10_group = icd10_group.options[ icd10_group.selectedIndex ].getAttribute(\'value\');
				
				icd10_site = document.getElementById(\'CodingIcd10/site\');
				icd10_site = icd10_site.options[ icd10_site.selectedIndex ].getAttribute(\'value\');
				
				icd10_subsite = document.getElementById(\'CodingIcd10/subsite\');
				icd10_subsite = icd10_subsite.options[ icd10_subsite.selectedIndex ].getAttribute(\'value\');
				
				new Ajax.Updater( \'lightwindow_contents\', \''.$html->url( '/codingicd10/coding_icd10s/tool/'.$field_id.'/' ).'\'+icd10_category+\'/\'+icd10_group+\'/\'+icd10_site+\'/\'+icd10_subsite, {asynchronous:true, evalScripts:true} );
		';
		//new Ajax.Updater( \'coding_icd10s_tool_'.$field_id.'\', \''.$html->url( '/coding_icd10s/tool/'.$field_id.'/' ).'\'+icd10_category+\'/\'+icd10_group+\'/\'+icd10_site+\'/\'+icd10_subsite, {asynchronous:true, evalScripts:true} );
		
		
		$html_attributes = array();
		$html_attributes['onChange'] = $javascript_codeblock;
		
		// categories
		
			$coding_icd10_category_selected = null;
			$coding_icd10_category = array( 'NULL'=>'All Categories...' );
			
			foreach ( $icd10_listall as $icd10 ) {
				if ( !in_array( $icd10['CodingIcd10']['category'], $coding_icd10_category ) ) {
					$coding_icd10_category[ $icd10['CodingIcd10']['category'] ] = $icd10['CodingIcd10']['category'];
					
					//$coding_icd10_category_selected = $coding_icd10_category_selected;
				}
			}
			
			$coding_icd10_category = array_filter($coding_icd10_category);
			$coding_icd10_category_selected = count($coding_icd10_category)<2 ? null : $coding_icd10_category_selected;
		
		// groups
		
			$coding_icd10_group_selected = null;
			$coding_icd10_group = array( 'NULL'=>'All Groups...' );
			
			foreach ( $icd10_listall as $icd10 ) {
				if ( !in_array( $icd10['CodingIcd10']['icd_group'], $coding_icd10_group ) ) {
					$coding_icd10_group[ $icd10['CodingIcd10']['icd_group'] ] = $icd10['CodingIcd10']['icd_group'];
					
					//$coding_icd10_group_selected = $coding_icd10_group_selected;
				}
			}
			
			$coding_icd10_group = array_filter($coding_icd10_group);
			$coding_icd10_group_selected = count($coding_icd10_group)<2 ? null : $coding_icd10_group_selected;
		
		// sites
			
			$coding_icd10_site_selected = null;
			$coding_icd10_site = array( 'NULL'=>'All Sites...' );
			
			foreach ( $icd10_listall as $icd10 ) {
				if ( !in_array( $icd10['CodingIcd10']['site'], $coding_icd10_site ) ) {
					$coding_icd10_site[ $icd10['CodingIcd10']['site'] ] = $icd10['CodingIcd10']['site'];
					
					//$coding_icd10_site_selected = $coding_icd10_site_selected;
				}
			}
		
			$coding_icd10_site = array_filter($coding_icd10_site);
			$coding_icd10_site_selected = count($coding_icd10_site)<2 ? null : $coding_icd10_site_selected;
		
		// subsites
			
			$coding_icd10_subsite_selected = null;
			$coding_icd10_subsite = array( 'NULL'=>'All Subsites...' );
			
			foreach ( $icd10_listall as $icd10 ) {
				if ( !in_array( $icd10['CodingIcd10']['subsite'], $coding_icd10_subsite ) ) {
					$coding_icd10_subsite[ $icd10['CodingIcd10']['subsite'] ] = $icd10['CodingIcd10']['subsite'];
					
					//$coding_icd10_subsite_selected = $coding_icd10_subsite_selected;
				}
			}
			
			$coding_icd10_subsite = array_filter($coding_icd10_subsite);
			$coding_icd10_subsite_selected = count($coding_icd10_subsite)<2 ? null : $coding_icd10_subsite_selected;
		
		// display
		echo('
			
			<tr><td colspan="2" style="padding: 0px 0px 10px 0px;"><label>'.__('Search ICD-10 Codes', null).'</label></td></tr>
			
			<tr><td>'.__('category', null).'</td><td>'.$form->select( 'CodingIcd10/category', $coding_icd10_category, $coding_icd10_category_selected, $html_attributes, NULL, false ).'</td></tr>
			<tr><td>'.__('group', null).'</td><td>'.$form->select( 'CodingIcd10/icd_group', $coding_icd10_group, $coding_icd10_group_selected, $html_attributes, NULL, false ).'</td></tr>
			<tr><td>'.__('site', null).'</td><td>'.$form->select( 'CodingIcd10/site', $coding_icd10_site, $coding_icd10_site_selected, $html_attributes, NULL, false ).'</td></tr>
			<tr><td>'.__('subsite', null).'</td><td>'.$form->select( 'CodingIcd10/subsite', $coding_icd10_subsite, $coding_icd10_subsite_selected, $html_attributes, NULL, false ).'</td></tr>
			
		');
		
		unset($html_attributes['onChange']);
		// $html_attributes['size'] = 20;
		
		$coding_icd10_id_selected = null;
		$coding_icd10_id = array();
		foreach ( $icd10_listall as $icd10 ) {
			$coding_icd10_id[ $icd10['CodingIcd10']['id'] ] = $icd10['CodingIcd10']['id'].' - '.$icd10['CodingIcd10']['description'];
		}
		$coding_icd10_id = array_filter($coding_icd10_id);
		
		$javascript_inline = '';
		$javascript_inline .= 'icd10_code_pulldown = document.getElementById(\'CodingIcd10/id\'); ';
		$javascript_inline .= 'icd10_code_pulldown = icd10_code_pulldown.options[ icd10_code_pulldown.selectedIndex ].getAttribute(\'value\'); ';
		$javascript_inline .= 'icd10_field_name = document.getElementById(\''.$field_id.'\'); ';
		$javascript_inline .= 'icd10_field_name.value = icd10_code_pulldown; ';
		
		echo('
				<tr><td colspan="2" style="padding: 20px 0px 10px 0px;"><label>Listing '.count($icd10_listall).' All Codes...</label></td></tr>
				<tr><td colspan="2">'.$form->select( 'CodingIcd10/id', $coding_icd10_id, NULL, $html_attributes, NULL, false ).'
				
				<span class="button" style="padding: 15px;"><a class="tools" onclick="'.$javascript_inline.' myLightWindow.deactivate();">Populate field with this code...</a></span>
				</td></tr>
				
		');
	
?>
</table>