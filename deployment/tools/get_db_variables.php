<?php
	$var_envs = (include 'env.php');
	$db_vars = $var_envs['db']['connection']['default']['host'] . ' ' .
		$var_envs['db']['connection']['default']['dbname'] . ' ' .
		$var_envs['db']['connection']['default']['username'] . ' ' .
		$var_envs['db']['connection']['default']['password'];

	echo $db_vars;

