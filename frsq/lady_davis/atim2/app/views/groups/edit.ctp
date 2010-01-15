<div class="groups form">
<?php echo $form->create('Group');?>
	<fieldset>
 		<legend><?php __('Edit Group');?></legend>
	<?php
		echo $form->input('Group.id');
		echo $form->input('Group.name');
	?>
	</fieldset>
	<fieldset>
 		<legend><?php __('Permissions');?></legend>
<?php
	$options = array(1 => 'Allow', -1 => 'Deny');

	if(count($this->data['Aro']['Permission'])){
		foreach($this->data['Aro']['Permission'] as $i => $ar){
			echo '<fieldset style="padding: 5px;" id="permission_'.$i.'">';
				echo $form->input('Aro.Permission.'.$i.'.id', array('type' => 'hidden'));
				echo $form->input('Aro.Permission.'.$i.'.aro_id', array('type' => 'hidden'));
				echo $form->input('Aro.Permission.'.$i.'.remove', array('type' => 'checkbox', 'value' => 1));
				echo $form->input('Aro.Permission.'.$i.'.aco_id', array('label' => false, 'type' => 'select', 'options' => $aco_options));
				echo $form->input('Aro.Permission.'.$i.'._create', array('label' => false, 'type' => 'select', 'options' => $options));
			echo '</fieldset>';
		}
	}else{
		echo '<fieldset style="padding: 5px;" id="permission_0">';
			echo $form->input('Aro.Permission.0.aro_id', array('type' => 'hidden'));
			echo $form->input('Aro.Permission.0.remove', array('type' => 'hidden', 'value' => 0));
			echo $form->input('Aro.Permission.0.aco_id', array('type' => 'select', 'options' => $aco_options));
			echo $form->input('Aro.Permission.0._create', array('label' => false, 'type' => 'select', 'options' => $options));
		echo '</fieldset>';
	}
	$permissionsTemplate =
		'<fieldset style="padding: 5px;" id="permission_#{id}">'
		.$form->input('Aro.Permission.#{id}.aro_id', array('type' => 'hidden', 'value' => $this->data['Aro']['id']))
		.$form->input('Aro.Permission.#{id}.remove', array('type' => 'hidden', 'value' => 0))
		.$form->input('Aro.Permission.#{id}.aco_id', array('label' => false, 'type' => 'select', 'options' => $aco_options))
		.$form->input('Aro.Permission.#{id}._create', array('label' => false, 'type' => 'select', 'options' => $options))
		.'<a href="#" onclick="$(\'permission_#{id}\').remove();return false;" class="remove">Remove</a>'
		.'</fieldset>';
	$permissionsTemplate = preg_replace('/\n/','',preg_replace('/"/',"'", preg_replace('/\'/','&quot;',$permissionsTemplate)));
	
	echo '<a id="permissions" href="#" onclick="addPermissions(); return false;">Add</a>
					<script type="text/javascript">
						var next_permission = "'.(count($this->data['Aro']['Permission']) > 0 ? count($this->data['Aro']['Permission']) : 1).'";
						function addPermissions(){
							$("permissions").insert({
								before: "'.$permissionsTemplate.'".interpolate({
									id: next_permission
								})
							});
						next_permission++;
						}
					</script>';

?>
	</fieldset>
<?php echo $form->end('Submit');?>

</div>
<div class="actions">
	<ul>
		<li><?php echo $html->link(__('Delete', true), array('action'=>'delete', $form->value('Group.id')), null, sprintf(__('Are you sure you want to delete # %s?', true), $form->value('Group.id'))); ?></li>
		<li><?php echo $html->link(__('List Groups', true), array('action'=>'index'));?></li>
	</ul>
</div>
