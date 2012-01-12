<?php
	$atim_structure['StructureFormat'] = array(); 
	
	$structure_links = array(
		'top'=>'/Customize/passwords/index'
	);
	
	$extras = '
		<table class="columns detail" cellspacing="0">
			<tbody>
			
				<tr>
					<td class="label no_border">
						'.__( 'newpassword', true ).'
					</td>
					<td class="content empty no_border">
						<input name="data[User][new_password]" class="required password" size="30" value="" type="password" id="UserNewPassword" />
					</td>
					<td class="help no_border">
						<span class="help error">&nbsp;</span>
					</td>
				</tr>
				
				<tr>
					<td class="label">
						'.__( 'confirmpassword', true ).'
					</td>
					<td class="content">
						<input name="data[User][confirm_password]" class="required password" size="30" value="" type="password" id="UserConfirmPassword" />
					</td>
					<td class="help">
						<span class="help error">&nbsp;</span>
					</td>
				</tr>
				
			</tbody>
		</table>
	';
	
	$this->Structures->build($atim_structure, array( 'type'=>'edit', 'links'=>$structure_links, 'extras' => $extras));
?>